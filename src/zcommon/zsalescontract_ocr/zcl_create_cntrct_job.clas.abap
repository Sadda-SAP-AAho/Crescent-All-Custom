CLASS zcl_create_cntrct_job DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    CONSTANTS:
      c_contract_type   TYPE string VALUE 'KM',
      c_order_reason    TYPE string VALUE '001',
      c_country_origin  TYPE string VALUE 'IND',
      c_port_of_loading TYPE string VALUE 'KOL',
      c_price_condition TYPE string VALUE 'ZPR1',
      c_validity_days   TYPE i      VALUE 60,
      c_cid_header      TYPE string VALUE 'HDR',
      c_dms_stage_type  TYPE string VALUE 'SC-STG',
      c_dms_final_type  TYPE string VALUE 'SC',
      c_dms_cfg_entity  TYPE string VALUE 'SC',
      headername        TYPE string VALUE 'x-functions-key',
      headervalue       TYPE string VALUE 'DMS-FUNCTION-KEY',
      container         TYPE string VALUE 'DMS-CONTAINER'.

    CONSTANTS:
      c_srv_download TYPE if_com_management=>ty_cscn_outb_srv_id VALUE 'ZOS_DOWNLOAD_REST',
      c_srv_upload   TYPE if_com_management=>ty_cscn_outb_srv_id VALUE 'ZOS_UPLOAD_REST'.

    TYPES tt_item TYPE STANDARD TABLE OF zr_scitm WITH EMPTY KEY.
    TYPES tt_line TYPE STANDARD TABLE OF zr_scitm-linenumber WITH EMPTY KEY.

    TYPES: BEGIN OF ty_item_resolved,
             linenumber    TYPE i,
             material      TYPE matnr,
             partnumber    TYPE c LENGTH 60,
             conditiontype TYPE c LENGTH 4,
             extnprice     TYPE decfloat34,
             plant         TYPE werks_d,
             orderqty      TYPE decfloat34,
             uom           TYPE meins,
             unitprice     TYPE decfloat34,
             currency      TYPE waers,
           END OF ty_item_resolved,
           tt_item_resolved TYPE STANDARD TABLE OF ty_item_resolved WITH EMPTY KEY.

    TYPES: BEGIN OF ty_map,
             key   TYPE string,
             value TYPE string,
           END OF ty_map,
           tt_map TYPE HASHED TABLE OF ty_map WITH UNIQUE KEY key.

    TYPES: BEGIN OF ty_error_res,
             error TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
           END OF ty_error_res.

    TYPES: BEGIN OF ty_upload_res,
             issuccess TYPE string,
             message   TYPE string,
             data      TYPE string,
           END OF ty_upload_res.

    DATA mt_material  TYPE tt_map.
    DATA mt_prodplant TYPE tt_map.   " product/plant -> X
    DATA mt_uom       TYPE tt_map.   " ext/int unit  -> internal unit
    DATA mo_log       TYPE REF TO if_bali_log.

    METHODS run_job.
    METHODS load_masters
      IMPORTING it_items TYPE tt_item.
    METHODS process_document
      IMPORTING is_hdr   TYPE zr_schdr
                it_items TYPE tt_item.
    METHODS validate_header
      IMPORTING is_hdr TYPE zr_schdr
      RAISING   zcx_cntrct_job.
    METHODS resolve_customer
      IMPORTING is_hdr       TYPE zr_schdr
      RETURNING VALUE(rv_bp) TYPE i_customersalesarea-customer
      RAISING   zcx_cntrct_job.
    METHODS resolve_items
      IMPORTING is_hdr          TYPE zr_schdr
                it_items        TYPE tt_item
      RETURNING VALUE(rt_items) TYPE tt_item_resolved
      RAISING   zcx_cntrct_job.
    METHODS find_existing_contract
      IMPORTING is_hdr             TYPE zr_schdr
                iv_sold_to         TYPE i_customersalesarea-customer
      RETURNING VALUE(rv_contract) TYPE vbeln.
    METHODS drop_items_on_contract
      IMPORTING iv_contract TYPE vbeln
      CHANGING  ct_items    TYPE tt_item_resolved
                ct_done     TYPE tt_line.
    METHODS create_sales_contract
      IMPORTING is_hdr             TYPE zr_schdr
                iv_sold_to         TYPE i_customersalesarea-customer
                iv_contract        TYPE vbeln OPTIONAL
                it_items           TYPE tt_item_resolved
      RETURNING VALUE(rv_contract) TYPE vbeln
      RAISING   zcx_cntrct_job.
    METHODS add_file_to_dms
      IMPORTING iv_contract  TYPE vbeln
                iv_stage_key TYPE zr_dms-refobjectkey
      RAISING   zcx_cntrct_job.
    METHODS new_client
      IMPORTING iv_service_id    TYPE if_com_management=>ty_cscn_outb_srv_id
      RETURNING VALUE(ro_client) TYPE REF TO if_web_http_client
      RAISING   zcx_cntrct_job.
    METHODS save_staging
      IMPORTING iv_docuuid  TYPE zr_schdr-docuuid
                iv_contract TYPE vbeln   OPTIONAL
                it_done     TYPE tt_line OPTIONAL
                iv_error    TYPE string  OPTIONAL
                iv_posted   TYPE abap_bool.
    METHODS add_msg
      IMPORTING iv_severity TYPE c DEFAULT 'I'
                iv_text     TYPE string.
    METHODS save_appl_log.
ENDCLASS.



CLASS zcl_create_cntrct_job IMPLEMENTATION.

  METHOD if_apj_dt_exec_object~get_parameters.
  ENDMETHOD.

  METHOD if_apj_rt_exec_object~execute.
    run_job( ).
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    run_job( ).
    out->write( `Run finished - see Application Log` ).
  ENDMETHOD.


  METHOD run_job.
    " SAP allows ONE sales document per session -> exactly one staging document per run.
    " Documents with an error wait until the user clears the error log in the UI.
    SELECT FROM zr_schdr
      FIELDS *
      WHERE ispostedsap IS INITIAL
        AND errorlog    IS INITIAL
      ORDER BY orderdate, ponumber
      INTO TABLE @DATA(lt_hdr)
      UP TO 1 ROWS.

    IF lt_hdr IS INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_hdr) = lt_hdr[ 1 ].

    SELECT FROM zr_scitm
      FIELDS *
      WHERE docuuid   = @ls_hdr-docuuid
        AND lineadded IS INITIAL
      ORDER BY linenumber
      INTO TABLE @DATA(lt_items).

    process_document( is_hdr = ls_hdr it_items = lt_items ).
    save_appl_log( ).
  ENDMETHOD.


  METHOD process_document.
    DATA lv_contract TYPE vbeln.
    DATA lv_sold_to  TYPE i_customersalesarea-customer.
    DATA lt_done     TYPE tt_line.
    DATA lv_warning  TYPE string.

    TRY.
        validate_header( is_hdr ).
        lv_contract = is_hdr-salescontract.

        IF it_items IS NOT INITIAL.
          load_masters( it_items ).

          " ALL open lines must be valid before anything is posted
          DATA(lt_resolved) = resolve_items( is_hdr = is_hdr it_items = it_items ).

          IF lv_contract IS INITIAL.
            lv_sold_to  = resolve_customer( is_hdr ).
            lv_contract = find_existing_contract( is_hdr = is_hdr iv_sold_to = lv_sold_to ).
          ENDIF.

          " never add a line twice to the same contract
          IF lv_contract IS NOT INITIAL.
            drop_items_on_contract( EXPORTING iv_contract = lv_contract
                                    CHANGING  ct_items    = lt_resolved
                                              ct_done     = lt_done ).
          ENDIF.

          IF lt_resolved IS NOT INITIAL.
            lv_contract = create_sales_contract( is_hdr      = is_hdr
                                                 iv_sold_to  = lv_sold_to
                                                 iv_contract = lv_contract
                                                 it_items    = lt_resolved ).
            lt_done = VALUE #( BASE lt_done FOR ls_r IN lt_resolved ( ls_r-linenumber ) ).
          ENDIF.
        ENDIF.

        IF lv_contract IS INITIAL.
          RAISE EXCEPTION NEW zcx_cntrct_job( iv_text = `No open items and no sales contract on this document` ).
        ENDIF.

        " attachment failure must NOT lose the contract
        TRY.
            add_file_to_dms( iv_contract = lv_contract iv_stage_key = is_hdr-docuuid ).
          CATCH zcx_cntrct_job INTO DATA(lx_dms).
            lv_warning = |Contract { lv_contract ALPHA = OUT } saved; attachment failed: { lx_dms->get_text( ) }|.
        ENDTRY.

        save_staging( iv_docuuid  = is_hdr-docuuid
                      iv_contract = lv_contract
                      it_done     = lt_done
                      iv_error    = lv_warning
                      iv_posted   = xsdbool( lv_warning IS INITIAL ) ).

        add_msg( iv_severity = COND #( WHEN lv_warning IS INITIAL THEN 'S' ELSE 'W' )
                 iv_text     = COND #( WHEN lv_warning IS INITIAL
                                       THEN |PO { is_hdr-ponumber }: contract { lv_contract ALPHA = OUT } posted|
                                       ELSE |PO { is_hdr-ponumber }: { lv_warning }| ) ).

      CATCH zcx_cntrct_job INTO DATA(lx_job).
        ROLLBACK ENTITIES.            " clean buffer, otherwise the staging commit below would fail too
        save_staging( iv_docuuid  = is_hdr-docuuid
                      iv_contract = lv_contract   " keeps existing/found contract, never blanks it
                      it_done     = lt_done
                      iv_error    = lx_job->get_text( )
                      iv_posted   = abap_false ).
        add_msg( iv_severity = 'E' iv_text = |PO { is_hdr-ponumber }: { lx_job->get_text( ) }| ).

      CATCH cx_root INTO DATA(lx_root).
        ROLLBACK ENTITIES.
        save_staging( iv_docuuid  = is_hdr-docuuid
                      iv_contract = lv_contract
                      it_done     = lt_done
                      iv_error    = |Unexpected error: { lx_root->get_text( ) }|
                      iv_posted   = abap_false ).
        add_msg( iv_severity = 'E' iv_text = |PO { is_hdr-ponumber }: { lx_root->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.


  METHOD validate_header.
    DATA lt_missing TYPE string_table.

    IF is_hdr-ponumber            IS INITIAL. APPEND `PO number`            TO lt_missing. ENDIF.
    IF is_hdr-customername        IS INITIAL. APPEND `customer name`        TO lt_missing. ENDIF.
    IF is_hdr-orderdate           IS INITIAL. APPEND `order date`           TO lt_missing. ENDIF.
    IF is_hdr-currency            IS INITIAL. APPEND `currency`             TO lt_missing. ENDIF.
    IF is_hdr-salesorganization   IS INITIAL. APPEND `sales organization`   TO lt_missing. ENDIF.
    IF is_hdr-distributionchannel IS INITIAL. APPEND `distribution channel` TO lt_missing. ENDIF.
    IF is_hdr-division            IS INITIAL. APPEND `division`             TO lt_missing. ENDIF.

    IF lt_missing IS NOT INITIAL.
      RAISE EXCEPTION NEW zcx_cntrct_job(
        iv_text = |Missing required header fields: { concat_lines_of( table = lt_missing sep = `, ` ) }| ).
    ENDIF.
  ENDMETHOD.


  METHOD load_masters.
    " ---- Units: only the codes used in this document ----
    DATA lr_uom TYPE RANGE OF i_unitofmeasure-unitofmeasure_e.
    lr_uom = VALUE #( FOR ls_u IN it_items WHERE ( uom IS NOT INITIAL )
                      ( sign = 'I' option = 'EQ' low = ls_u-uom ) ).
    IF lr_uom IS NOT INITIAL.
      SELECT FROM i_unitofmeasure
        FIELDS unitofmeasure, unitofmeasure_e
        WHERE unitofmeasure_e IN @lr_uom
           OR unitofmeasure   IN @lr_uom
        INTO TABLE @DATA(lt_uom).
      LOOP AT lt_uom INTO DATA(ls_uom).            " external code has priority
        INSERT VALUE #( key = ls_uom-unitofmeasure_e value = ls_uom-unitofmeasure ) INTO TABLE mt_uom.
      ENDLOOP.
      LOOP AT lt_uom INTO ls_uom.                  " internal code as fallback
        INSERT VALUE #( key = ls_uom-unitofmeasure value = ls_uom-unitofmeasure ) INTO TABLE mt_uom.
      ENDLOOP.
    ENDIF.

    " ---- Materials: all part numbers of the document in one SELECT ----
    DATA lr_key TYPE RANGE OF i_product-product.
    lr_key = VALUE #( FOR ls_i IN it_items
                      ( sign = 'I' option = 'EQ'
                        low  = COND #( WHEN ls_i-productcode IS NOT INITIAL
                                       THEN ls_i-productcode ELSE ls_i-partnumber ) ) ).
    DELETE lr_key WHERE low IS INITIAL.
    SORT lr_key BY low.
    DELETE ADJACENT DUPLICATES FROM lr_key COMPARING low.

    IF lr_key IS INITIAL.
      RETURN.
    ENDIF.

    SELECT FROM i_product
      FIELDS product, productmanufacturernumber, industrystandardname
      WHERE (    product                   IN @lr_key
              OR productmanufacturernumber IN @lr_key
              OR industrystandardname      IN @lr_key )
        AND ismarkedfordeletion = @abap_false
      INTO TABLE @DATA(lt_prod).

    " priority: product > manufacturer part number > industry standard name
    LOOP AT lt_prod INTO DATA(ls_p).
      INSERT VALUE #( key = ls_p-product value = ls_p-product ) INTO TABLE mt_material.
    ENDLOOP.
    LOOP AT lt_prod INTO ls_p WHERE productmanufacturernumber IS NOT INITIAL.
      INSERT VALUE #( key = ls_p-productmanufacturernumber value = ls_p-product ) INTO TABLE mt_material.
    ENDLOOP.
    LOOP AT lt_prod INTO ls_p WHERE industrystandardname IS NOT INITIAL.
      INSERT VALUE #( key = ls_p-industrystandardname value = ls_p-product ) INTO TABLE mt_material.
    ENDLOOP.

    " last resort: description - only if exactly ONE product has it
    DATA lr_desc TYPE RANGE OF i_productdescription-productdescription.
    LOOP AT lr_key INTO DATA(ls_key).
      IF NOT line_exists( mt_material[ key = CONV string( ls_key-low ) ] ).
        APPEND VALUE #( sign = 'I' option = 'EQ' low = ls_key-low ) TO lr_desc.
      ENDIF.
    ENDLOOP.

    IF lr_desc IS NOT INITIAL.
      SELECT FROM i_productdescription
        FIELDS productdescription, product
        WHERE language           = @sy-langu
          AND productdescription IN @lr_desc
        INTO TABLE @DATA(lt_desc).

      LOOP AT lt_desc INTO DATA(ls_d).
        DATA(lv_hits) = REDUCE i( INIT n = 0
                                  FOR ls_x IN lt_desc WHERE ( productdescription = ls_d-productdescription )
                                  NEXT n = n + 1 ).
        IF lv_hits = 1.
          INSERT VALUE #( key = ls_d-productdescription value = ls_d-product ) INTO TABLE mt_material.
        ENDIF.
      ENDLOOP.
    ENDIF.

    " ---- Product x plant extension in one SELECT ----
    TYPES: BEGIN OF ty_pp,
             product TYPE i_productplantbasic-product,
             plant   TYPE i_productplantbasic-plant,
           END OF ty_pp.
    DATA lt_pp TYPE SORTED TABLE OF ty_pp WITH UNIQUE KEY product plant.

    LOOP AT it_items INTO DATA(ls_item) WHERE plant IS NOT INITIAL.
      DATA(lv_search) = CONV string( COND #( WHEN ls_item-productcode IS NOT INITIAL
                                             THEN ls_item-productcode ELSE ls_item-partnumber ) ).
      ASSIGN mt_material[ key = lv_search ] TO FIELD-SYMBOL(<ls_mat>).
      IF sy-subrc = 0.
        INSERT VALUE #( product = <ls_mat>-value plant = ls_item-plant ) INTO TABLE lt_pp.
      ENDIF.
    ENDLOOP.

    IF lt_pp IS NOT INITIAL.
      SELECT FROM i_productplantbasic
        FIELDS product, plant
        FOR ALL ENTRIES IN @lt_pp
        WHERE product = @lt_pp-product
          AND plant   = @lt_pp-plant
        INTO TABLE @DATA(lt_pp_db).
      LOOP AT lt_pp_db INTO DATA(ls_ppdb).
        INSERT VALUE #( key = |{ ls_ppdb-product }/{ ls_ppdb-plant }| value = 'X' ) INTO TABLE mt_prodplant.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD resolve_items.
    DATA lt_err TYPE string_table.

    LOOP AT it_items INTO DATA(ls_i).
      DATA(lv_errors_before) = lines( lt_err ).
      DATA(lv_key) = CONV string( COND #( WHEN ls_i-productcode IS NOT INITIAL
                                          THEN ls_i-productcode ELSE ls_i-partnumber ) ).

      ASSIGN mt_material[ key = lv_key ] TO FIELD-SYMBOL(<ls_mat>).
      IF sy-subrc <> 0.
        APPEND |Line { ls_i-linenumber }: part '{ lv_key }' not found in master data| TO lt_err.
      ELSEIF ls_i-plant IS INITIAL.
        APPEND |Line { ls_i-linenumber }: plant missing| TO lt_err.
      ELSEIF NOT line_exists( mt_prodplant[ key = |{ <ls_mat>-value }/{ ls_i-plant }| ] ).
        APPEND |Line { ls_i-linenumber }: material { <ls_mat>-value } not extended to plant { ls_i-plant }| TO lt_err.
      ENDIF.

      ASSIGN mt_uom[ key = CONV string( ls_i-uom ) ] TO FIELD-SYMBOL(<ls_uom>).
      IF sy-subrc <> 0.
        APPEND |Line { ls_i-linenumber }: unit '{ ls_i-uom }' not found| TO lt_err.
      ENDIF.

      IF ls_i-orderqty <= 0.
        APPEND |Line { ls_i-linenumber }: quantity must be greater than 0| TO lt_err.
      ENDIF.

      IF lines( lt_err ) = lv_errors_before.          " this line is clean
        APPEND VALUE #( linenumber    = ls_i-linenumber
                        material      = <ls_mat>-value
                        partnumber    = ls_i-partnumber
                        conditiontype = ls_i-conditiontype
                        extnprice     = ls_i-extprice
                        plant         = ls_i-plant
                        orderqty      = ls_i-orderqty
                        uom           = <ls_uom>-value
                        unitprice     = ls_i-unitprice
                        currency      = is_hdr-currency ) TO rt_items.
      ENDIF.
    ENDLOOP.

    IF lt_err IS NOT INITIAL.
      RAISE EXCEPTION NEW zcx_cntrct_job( iv_text = concat_lines_of( table = lt_err sep = `; ` ) ).
    ENDIF.
  ENDMETHOD.


  METHOD resolve_customer.
    " 1) By code (with leading zeros) - must be extended to the header's sales area
    IF is_hdr-customercode IS NOT INITIAL.
      DATA(lv_code) = CONV i_customersalesarea-customer( |{ is_hdr-customercode ALPHA = IN WIDTH = 10 }| ).
      SELECT SINGLE FROM i_customersalesarea
        FIELDS customer
        WHERE customer            = @lv_code
          AND salesorganization   = @is_hdr-salesorganization
          AND distributionchannel = @is_hdr-distributionchannel
          AND division            = @is_hdr-division
        INTO @rv_bp.
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
    ENDIF.

    " 2) Exact name in this sales area - must be unique
    SELECT FROM i_businesspartner AS bp
      INNER JOIN i_customersalesarea AS csa ON csa~customer = bp~businesspartner
      FIELDS DISTINCT bp~businesspartner
      WHERE bp~organizationbpname1   = @is_hdr-customername
        AND csa~salesorganization   = @is_hdr-salesorganization
        AND csa~distributionchannel = @is_hdr-distributionchannel
        AND csa~division            = @is_hdr-division
      INTO TABLE @DATA(lt_hits)
      UP TO 2 ROWS.

    IF lines( lt_hits ) = 1.
      rv_bp = lt_hits[ 1 ]-businesspartner.
      RETURN.
    ELSEIF lines( lt_hits ) > 1.
      RAISE EXCEPTION NEW zcx_cntrct_job(
        iv_text = |Customer name '{ is_hdr-customername }' matches several customers - enter the customer code| ).
    ENDIF.

    " 3) Case-insensitive 'contains' - accepted ONLY if exactly one customer matches
    DATA(lv_name) = to_upper( condense( CONV string( is_hdr-customername ) ) ).
    REPLACE ALL OCCURRENCES OF `#` IN lv_name WITH `##`.
    REPLACE ALL OCCURRENCES OF `%` IN lv_name WITH `#%`.
    REPLACE ALL OCCURRENCES OF `_` IN lv_name WITH `#_`.
    DATA(lv_pattern) = |%{ lv_name }%|.

    CLEAR lt_hits.
    SELECT FROM i_businesspartner AS bp
      INNER JOIN i_customersalesarea AS csa ON csa~customer = bp~businesspartner
      FIELDS DISTINCT bp~businesspartner
      WHERE upper( bp~organizationbpname1 ) LIKE @lv_pattern ESCAPE '#'
        AND csa~salesorganization   = @is_hdr-salesorganization
        AND csa~distributionchannel = @is_hdr-distributionchannel
        AND csa~division            = @is_hdr-division
      INTO TABLE @lt_hits
      UP TO 2 ROWS.

    IF lines( lt_hits ) = 1.
      rv_bp = lt_hits[ 1 ]-businesspartner.
      RETURN.
    ELSEIF lines( lt_hits ) > 1.
      RAISE EXCEPTION NEW zcx_cntrct_job(
        iv_text = |Customer '{ is_hdr-customername }' matches several customers - enter the customer code| ).
    ENDIF.

    RAISE EXCEPTION NEW zcx_cntrct_job(
      iv_text = |Customer '{ is_hdr-customername }' ({ is_hdr-customercode }) not found in sales area | &&
                |{ is_hdr-salesorganization }/{ is_hdr-distributionchannel }/{ is_hdr-division }| ).
  ENDMETHOD.


  METHOD find_existing_contract.
    " returning parameter is initial on every call -> no stale value
    SELECT SINGLE FROM i_salescontracttp
      FIELDS salescontract
      WHERE purchaseorderbycustomer    = @is_hdr-ponumber
        AND soldtoparty                = @iv_sold_to
        AND yy1_poentrymailrecddat_sdh = @is_hdr-orderdate
      INTO @rv_contract.
  ENDMETHOD.


  METHOD drop_items_on_contract.
    SELECT FROM i_salescontractitem
      FIELDS product, materialbycustomer
      WHERE salescontract = @iv_contract
      INTO TABLE @DATA(lt_existing).

    IF lt_existing IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT ct_items INTO DATA(ls_item).
      DATA(lv_tabix) = sy-tabix.
      IF line_exists( lt_existing[ product            = ls_item-material
                                   materialbycustomer = ls_item-partnumber ] ).
        APPEND ls_item-linenumber TO ct_done.        " already on contract -> only flag it
        DELETE ct_items INDEX lv_tabix.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD create_sales_contract.
    DATA lt_item_create  TYPE TABLE FOR CREATE i_salescontracttp\_item.
    DATA lt_price_create TYPE TABLE FOR CREATE i_salescontractitemtp\_itempricingelement.
    DATA lt_msgs         TYPE string_table.
    DATA lv_idx          TYPE i.

    APPEND INITIAL LINE TO lt_item_create ASSIGNING FIELD-SYMBOL(<ls_parent>).
    IF iv_contract IS NOT INITIAL.
      <ls_parent>-salescontract = iv_contract.
    ELSE.
      <ls_parent>-%cid_ref = c_cid_header.
    ENDIF.

    LOOP AT it_items INTO DATA(ls_item).
      lv_idx += 1.
      DATA(lv_item_cid) = |I{ lv_idx }|.

      APPEND VALUE #( %cid                  = lv_item_cid
                      product               = ls_item-material
                      requestedquantity     = ls_item-orderqty
                      requestedquantityunit = ls_item-uom
                      transactioncurrency   = ls_item-currency
                      plant                 = ls_item-plant
                      materialbycustomer    = ls_item-partnumber
                      %control = VALUE #( product               = if_abap_behv=>mk-on
                                          requestedquantity     = if_abap_behv=>mk-on
                                          requestedquantityunit = if_abap_behv=>mk-on
                                          transactioncurrency   = if_abap_behv=>mk-on
                                          plant                 = if_abap_behv=>mk-on
                                          materialbycustomer    = if_abap_behv=>mk-on ) )
        TO <ls_parent>-%target.

      IF ls_item-conditiontype = c_price_condition.
        APPEND VALUE #( %cid_ref = lv_item_cid
                        salescontract           = space
                        salescontractitem       = space
                        %target  = VALUE #( ( %cid                = |P{ lv_idx }|
                                              conditiontype       = c_price_condition
                                              conditioncurrency   = ls_item-currency
                                              conditionrateamount = ls_item-unitprice
                                               %control                = VALUE #(
                                                  conditiontype      = if_abap_behv=>mk-on
                                                  conditioncurrency  = if_abap_behv=>mk-on
                                                  conditionrateamount = if_abap_behv=>mk-on
                                                  conditionamount    = if_abap_behv=>mk-on
                                             ) )
                                          ) )
          TO lt_price_create.
      ENDIF.
    ENDLOOP.

    IF iv_contract IS NOT INITIAL.
      " ---- add lines to existing contract ----
      MODIFY ENTITIES OF i_salescontracttp
        ENTITY salescontract
          CREATE BY \_item FROM lt_item_create
        ENTITY salescontractitem
          CREATE BY \_itempricingelement
          FIELDS ( conditiontype conditioncurrency conditionrateamount conditionamount )
          WITH lt_price_create
        MAPPED   DATA(ls_mapped)
        FAILED   DATA(ls_failed)
        REPORTED DATA(ls_reported).
    ELSE.
      " ---- new contract ----
      SELECT SINGLE FROM zi_codmastertable
        FIELDS codcode
        WHERE codcodenam = @is_hdr-customercountry
        INTO @DATA(lv_dest_country).

      MODIFY ENTITIES OF i_salescontracttp
        ENTITY salescontract
          CREATE FIELDS ( salescontracttype salesorganization distributionchannel organizationdivision
                          soldtoparty purchaseorderbycustomer transactioncurrency sddocumentreason
                          salescontractvaliditystartdate salescontractvalidityenddate
                          yy1_countryofdestinat_sdh yy1_countryoforigin_sdh
                          yy1_portofloading1_sdh yy1_poentrymailrecddat_sdh )
          WITH VALUE #( (
            %cid                           = c_cid_header
            salescontracttype              = c_contract_type
            salesorganization              = is_hdr-salesorganization
            distributionchannel            = is_hdr-distributionchannel
            organizationdivision           = is_hdr-division
            soldtoparty                    = iv_sold_to
            purchaseorderbycustomer        = is_hdr-ponumber
            transactioncurrency            = is_hdr-currency
            sddocumentreason               = c_order_reason
            salescontractvaliditystartdate = is_hdr-orderdate
            salescontractvalidityenddate   = cl_abap_context_info=>get_system_date( ) + c_validity_days
            yy1_countryofdestinat_sdh      = lv_dest_country
            yy1_countryoforigin_sdh        = c_country_origin
            yy1_portofloading1_sdh         = c_port_of_loading
            yy1_poentrymailrecddat_sdh     = is_hdr-orderdate ) )
          CREATE BY \_item FROM lt_item_create
        ENTITY salescontractitem
          CREATE BY \_itempricingelement
          FIELDS ( conditiontype conditioncurrency conditionrateamount conditionamount )
          WITH lt_price_create
        MAPPED   ls_mapped
        FAILED   ls_failed
        REPORTED ls_reported.
    ENDIF.

    " ---- interaction phase failed: collect ALL messages, clean the buffer ----
    IF ls_failed IS NOT INITIAL.
      LOOP AT ls_reported-salescontract INTO DATA(ls_r1) WHERE %msg IS BOUND.
        APPEND ls_r1-%msg->if_message~get_text( ) TO lt_msgs.
      ENDLOOP.
      LOOP AT ls_reported-salescontractitem INTO DATA(ls_r2) WHERE %msg IS BOUND.
        APPEND ls_r2-%msg->if_message~get_text( ) TO lt_msgs.
      ENDLOOP.
      LOOP AT ls_reported-slscontractitempricingelement INTO DATA(ls_r3) WHERE %msg IS BOUND.
        APPEND ls_r3-%msg->if_message~get_text( ) TO lt_msgs.
      ENDLOOP.
      ROLLBACK ENTITIES.
      RAISE EXCEPTION NEW zcx_cntrct_job(
        iv_text = |Contract not created: { COND string( WHEN lt_msgs IS NOT INITIAL
                                                        THEN concat_lines_of( table = lt_msgs sep = `; ` )
                                                        ELSE `no message returned` ) }| ).
    ENDIF.

    " ---- save phase (only CONVERT KEY between BEGIN and END) ----
    COMMIT ENTITIES BEGIN
      RESPONSE OF i_salescontracttp
      FAILED   DATA(ls_commit_failed)
      REPORTED DATA(ls_commit_reported).

    IF ls_commit_failed IS INITIAL AND iv_contract IS INITIAL.
      LOOP AT ls_mapped-salescontract ASSIGNING FIELD-SYMBOL(<ls_map>).
        CONVERT KEY OF i_salescontracttp FROM <ls_map>-%pid TO <ls_map>-%key.
        rv_contract = <ls_map>-%key-salescontract.
      ENDLOOP.
    ENDIF.
    COMMIT ENTITIES END.

    IF ls_commit_failed IS NOT INITIAL.
      LOOP AT ls_commit_reported-salescontract INTO DATA(ls_c1) WHERE %msg IS BOUND.
        APPEND ls_c1-%msg->if_message~get_text( ) TO lt_msgs.
      ENDLOOP.
      LOOP AT ls_commit_reported-salescontractitem INTO DATA(ls_c2) WHERE %msg IS BOUND.
        APPEND ls_c2-%msg->if_message~get_text( ) TO lt_msgs.
      ENDLOOP.
      LOOP AT ls_commit_reported-slscontractitempricingelement INTO DATA(ls_c3) WHERE %msg IS BOUND.
        APPEND ls_c3-%msg->if_message~get_text( ) TO lt_msgs.
      ENDLOOP.
      ROLLBACK ENTITIES.
      RAISE EXCEPTION NEW zcx_cntrct_job(
        iv_text = |Contract save failed: { COND string( WHEN lt_msgs IS NOT INITIAL
                                                        THEN concat_lines_of( table = lt_msgs sep = `; ` )
                                                        ELSE `no message returned` ) }| ).
    ENDIF.

    IF iv_contract IS NOT INITIAL.
      rv_contract = iv_contract.
    ENDIF.

    IF rv_contract IS INITIAL.
      RAISE EXCEPTION NEW zcx_cntrct_job( iv_text = `Contract saved but no number was returned` ).
    ENDIF.
  ENDMETHOD.


  METHOD add_file_to_dms.
    " ---- staged file of this staging document ----
    SELECT SINGLE FROM zr_dms
      FIELDS docuuid, doclink, title
      WHERE refobjecttype = @c_dms_stage_type
        AND refobjectkey  = @iv_stage_key
      INTO @DATA(ls_file).

    IF sy-subrc <> 0.
      " already moved to this contract in an earlier run -> nothing to do
      SELECT SINGLE FROM zr_dms
        FIELDS docuuid
        WHERE refobjecttype = @c_dms_final_type
          AND refobjectkey  = @iv_contract
        INTO @DATA(lv_already).
      IF sy-subrc = 0.
        RETURN.
      ENDIF.
      RAISE EXCEPTION NEW zcx_cntrct_job( iv_text = `File not found` ).
    ENDIF.

    " ---- config: both integration values in one SELECT ----
    SELECT FROM zr_integration
      FIELDS intgmodule, intgpath
      WHERE intgmodule = @container
         OR intgmodule = @headervalue
      INTO TABLE @DATA(lt_intg).

    DATA(lv_container)    = CONV string( VALUE #( lt_intg[ intgmodule = container ]-intgpath OPTIONAL ) ).
    DATA(lv_header_value) = CONV string( VALUE #( lt_intg[ intgmodule = headervalue ]-intgpath OPTIONAL ) ).

    SELECT SINGLE FROM zr_dms_config
      FIELDS path
      WHERE entity = @c_dms_cfg_entity
      INTO @DATA(lv_cfg_path).

    IF lv_container IS INITIAL OR lv_cfg_path IS INITIAL.
      RAISE EXCEPTION NEW zcx_cntrct_job( iv_text = `DMS configuration (container / path) missing` ).
    ENDIF.

    " ---- download ----
    DATA(lo_dl) = new_client( c_srv_download ).
    TRY.
        DATA(lo_dl_req) = lo_dl->get_http_request( ).
        lo_dl_req->set_query(
          |container={ cl_web_http_utility=>escape_url( lv_container ) }| &&
          |&blobPath={ cl_web_http_utility=>escape_url( CONV string( ls_file-doclink ) ) }| ).
        lo_dl_req->set_header_field( i_name = headername i_value = lv_header_value ).

        DATA(lo_dl_resp)   = lo_dl->execute( if_web_http_client=>get ).
        DATA(lv_dl_status) = lo_dl_resp->get_status( )-code.
        DATA(lv_file)      = lo_dl_resp->get_binary( ).
        lo_dl->close( ).
      CATCH cx_web_http_client_error cx_web_message_error INTO DATA(lx_dl).
        RAISE EXCEPTION NEW zcx_cntrct_job( iv_text = |File download failed: { lx_dl->get_text( ) }| previous = lx_dl ).
    ENDTRY.

    IF lv_dl_status <> 200 OR lv_file IS INITIAL.
      RAISE EXCEPTION NEW zcx_cntrct_job( iv_text = |File download failed: HTTP { lv_dl_status }| ).
    ENDIF.

    " ---- upload ----
    DATA(lv_folder) = |{ lv_cfg_path }/{ iv_contract }|.
    DATA(lv_title)  = replace( val = CONV string( ls_file-title ) sub = `"` with = `` occ = 0 ).

    DATA(lo_ul) = new_client( c_srv_upload ).
    TRY.
        DATA(lv_boundary) = |---ABAPBoundary{ cl_system_uuid=>create_uuid_c32_static( ) }|.
        DATA(lo_req) = lo_ul->get_http_request( ).
        lo_req->set_header_field( i_name = 'Content-Type' i_value = |multipart/form-data; boundary={ lv_boundary }| ).
        lo_req->set_header_field( i_name = headername i_value = lv_header_value ).

        DATA(lo_p_cont) = lo_req->add_multipart( ).
        lo_p_cont->set_header_field( i_name = 'Content-Disposition' i_value = 'form-data; name="Container"' ).
        lo_p_cont->set_text( lv_container ).

        DATA(lo_p_path) = lo_req->add_multipart( ).
        lo_p_path->set_header_field( i_name = 'Content-Disposition' i_value = 'form-data; name="CurrentPath"' ).
        lo_p_path->set_text( lv_folder ).

        DATA(lo_p_file) = lo_req->add_multipart( ).
        lo_p_file->set_header_field( i_name  = 'Content-Disposition'
                                     i_value = |form-data; name="File"; filename="{ lv_title }"| ).
        lo_p_file->set_header_field( i_name = 'Content-Type' i_value = 'application/octet-stream' ).
        lo_p_file->set_binary( lv_file ).

        DATA(lo_ul_resp)   = lo_ul->execute( if_web_http_client=>post ).
        DATA(lv_ul_status) = lo_ul_resp->get_status( )-code.
        DATA(lv_body)      = lo_ul_resp->get_text( ).
        lo_ul->close( ).
      CATCH cx_web_http_client_error cx_web_message_error cx_uuid_error INTO DATA(lx_ul).
        RAISE EXCEPTION NEW zcx_cntrct_job( iv_text = |File upload failed: { lx_ul->get_text( ) }| previous = lx_ul ).
    ENDTRY.

    DATA error_res TYPE ty_error_res.
    DATA ls_upload TYPE ty_upload_res.

    " HTTP error -> the API returns the real reason in error[ 1 ]
    IF lv_ul_status <> 200 AND lv_ul_status <> 201.
      TRY.
          xco_cp_json=>data->from_string( lv_body )->write_to( REF #( error_res ) ).
        CATCH cx_root ##NO_HANDLER.
      ENDTRY.
      RAISE EXCEPTION NEW zcx_cntrct_job(
        iv_text = |API request failed with status { lv_ul_status }: | &&
                  COND string( WHEN error_res-error IS NOT INITIAL THEN error_res-error[ 1 ] ELSE lv_body ) ).
    ENDIF.

    TRY.
        xco_cp_json=>data->from_string( lv_body )->write_to( REF #( ls_upload ) ).
      CATCH cx_root ##NO_HANDLER.
    ENDTRY.

    IF to_lower( ls_upload-issuccess ) <> `true`.
      TRY.
          xco_cp_json=>data->from_string( lv_body )->write_to( REF #( error_res ) ).
        CATCH cx_root ##NO_HANDLER.
      ENDTRY.
      RAISE EXCEPTION NEW zcx_cntrct_job(
        iv_text = COND string( WHEN error_res-error IS NOT INITIAL THEN error_res-error[ 1 ]
                               WHEN ls_upload-message IS NOT INITIAL THEN ls_upload-message
                               ELSE |Upload not successful: { lv_body }| ) ).
    ENDIF.

    " ---- move DMS record from staging to the contract ----
    MODIFY ENTITIES OF zr_dms
      ENTITY zrdms
        UPDATE FIELDS ( refobjecttype refobjectkey doclink )
        WITH VALUE #( ( %tky-docuuid  = ls_file-docuuid
                        refobjecttype = c_dms_final_type
                        refobjectkey  = iv_contract
                        doclink       = |{ lv_folder }/{ ls_file-title }| ) )
      FAILED   DATA(ls_failed)
      REPORTED DATA(ls_reported).

    IF ls_failed IS INITIAL.
      COMMIT ENTITIES RESPONSE OF zr_dms
        FAILED   DATA(ls_commit_failed)
        REPORTED DATA(ls_commit_reported).
    ENDIF.

    IF ls_failed IS NOT INITIAL OR ls_commit_failed IS NOT INITIAL.
      ROLLBACK ENTITIES.
      RAISE EXCEPTION NEW zcx_cntrct_job( iv_text = `File uploaded, but the DMS record could not be updated` ).
    ENDIF.
  ENDMETHOD.


  METHOD new_client.
    TRY.
        ro_client = cl_web_http_client_manager=>create_by_http_destination(
                      cl_http_destination_provider=>create_by_comm_arrangement(
                        comm_scenario  = 'ZCS_DMS'
                        comm_system_id = 'DMS_INT'
                        service_id     = iv_service_id ) ).
      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx).
        RAISE EXCEPTION NEW zcx_cntrct_job( iv_text = |DMS destination { iv_service_id }: { lx->get_text( ) }| previous = lx ).
    ENDTRY.
  ENDMETHOD.


  METHOD save_staging.
    " ONE commit: header (contract no, error, posted) + all item flags
    DATA lt_hdr TYPE TABLE FOR UPDATE zr_schdr.
    DATA lt_itm TYPE TABLE FOR UPDATE zr_scitm.

    lt_hdr = VALUE #( (
      %tky-docuuid  = iv_docuuid
      salescontract = iv_contract
      errorlog      = iv_error
      ispostedsap   = iv_posted
      %control      = VALUE #(
        " never overwrite an existing contract number with blank
        salescontract = COND #( WHEN iv_contract IS NOT INITIAL THEN if_abap_behv=>mk-on ELSE if_abap_behv=>mk-off )
        errorlog      = if_abap_behv=>mk-on
        ispostedsap   = if_abap_behv=>mk-on ) ) ).

    lt_itm = VALUE #( FOR lv_line IN it_done
                      ( %tky-docuuid       = iv_docuuid
                        %tky-linenumber    = lv_line
                        lineadded          = abap_true
                        %control-lineadded = if_abap_behv=>mk-on ) ).

    MODIFY ENTITIES OF zr_schdr
      ENTITY zrschdr UPDATE FROM lt_hdr
      ENTITY zrscitm UPDATE FROM lt_itm
      FAILED   DATA(ls_failed)
      REPORTED DATA(ls_reported).

    IF ls_failed IS INITIAL.
      COMMIT ENTITIES RESPONSE OF zr_schdr
        FAILED   DATA(ls_commit_failed)
        REPORTED DATA(ls_commit_reported).
    ENDIF.

    IF ls_failed IS NOT INITIAL OR ls_commit_failed IS NOT INITIAL.
      ROLLBACK ENTITIES.
      " Staging could not be written -> this document will be picked again next run.
      add_msg( iv_severity = 'E'
               iv_text     = |Staging update failed for document { iv_docuuid } | &&
                             |(contract { iv_contract }, error: { iv_error })| ).
    ENDIF.
  ENDMETHOD.


  METHOD add_msg.
    TRY.
        IF mo_log IS NOT BOUND.
          mo_log = cl_bali_log=>create_with_header(
                     cl_bali_header_setter=>create( object    = 'ZCNTRCT_JOB'
                                                    subobject = 'CREATE' ) ).
        ENDIF.
        mo_log->add_item( cl_bali_free_text_setter=>create( severity = iv_severity
                                                            text     = CONV #( iv_text ) ) ).
      CATCH cx_bali_runtime ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.


  METHOD save_appl_log.
    CHECK mo_log IS BOUND.
    TRY.
        cl_bali_log_db=>get_instance( )->save_log( log                        = mo_log
                                                   assign_to_current_appl_job = abap_true ).
        COMMIT WORK.
      CATCH cx_bali_runtime ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
