CLASS lhc_zi_deldash_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_deldash_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_deldash_hdr RESULT result.

    METHODS deliverydetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_deldash_hdr~deliverydetails.

    METHODS updatedata FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_deldash_hdr~updatedata.

    METHODS checkdel FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_deldash_hdr~checkdel.

    METHODS print FOR MODIFY
      IMPORTING keys FOR ACTION zi_deldash_hdr~print RESULT result.

   METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION zi_deldash_hdr~cancel RESULT result.

ENDCLASS.

CLASS lhc_zi_deldash_hdr IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_deldash_hdr IN LOCAL MODE
         ENTITY zi_deldash_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).


    result = VALUE #(
        FOR gs_header IN header
        ( %tky               = gs_header-%tky

          %assoc-_item    = COND #( WHEN gfs_header-delivery IS NOT INITIAL
                                    THEN if_abap_behv=>fc-o-disabled
                                    ELSE if_abap_behv=>fc-o-enabled )

         %action-cancel    = COND #( WHEN gs_header-canind  IS NOT INITIAL
                                     THEN if_abap_behv=>fc-o-disabled
                                     ELSE if_abap_behv=>fc-o-enabled )

         %action-edit      = COND #( WHEN gs_header-canind  IS NOT INITIAL
                                     THEN if_abap_behv=>fc-o-disabled
                                     ELSE if_abap_behv=>fc-o-enabled )

        ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updatedata.
    DATA : gs_item TYPE zdt_deldash_itm.

    READ ENTITIES OF zi_deldash_hdr IN LOCAL MODE
           ENTITY zi_deldash_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    gfs_header-status    = 'CREATED'.
    SELECT SINGLE MAX( revision ) FROM zdt_deldash_hdr
    WHERE delivery = @gfs_header-delivery INTO @DATA(lv_rev).
    gfs_header-revision = lv_rev + 1.


    SELECT * FROM i_deliverydocumentitem WHERE deliverydocument = @gfs_header-delivery
    INTO TABLE @DATA(lt_docitm).

    LOOP AT lt_docitm INTO DATA(ls_docitm).
      gs_item-delivery    = gfs_header-delivery.
      gs_item-plant       = ls_docitm-plant.
      gs_item-posnr       = ls_docitm-deliverydocumentitem.
      gs_item-matnr       = ls_docitm-material.
      gs_item-qty         = ls_docitm-actualdeliveryquantity.

      SELECT SINGLE productdescription FROM i_productdescription
      WHERE product = @ls_docitm-product AND language = 'E'
      INTO @gs_item-maktx.

      SELECT SINGLE consumptiontaxctrlcode FROM i_productplantbasic
      WHERE product = @ls_docitm-material AND plant = @ls_docitm-plant
      INTO @gs_item-hsn.

      SELECT SINGLE * FROM i_product WHERE product = @ls_docitm-material
      INTO @DATA(ls_product).

      gs_item-nwt = ls_product-netweight.
      gs_item-gwt = ls_product-grossweight.
      gs_item-unit = ls_product-weightunit.
      CLEAR : ls_product.

      SELECT SINGLE YY1_CustomerRequiredDe_sdi, AdditionalMaterialGroup1 FROM I_SalesDocumentItem
      WHERE SalesDocument = @ls_docitm-ReferenceSDDocument and SalesDocumentItem = @ls_docitm-ReferenceSDDocumentItem
      INTO ( @gs_item-cusreqdt, @gs_item-revno ).


      "SELECT * from I_ProductSales into table @data(lt_temp).

      gs_item-meins       = ls_docitm-baseunit.


      MODIFY ENTITIES OF zi_deldash_hdr IN LOCAL MODE
      ENTITY zi_deldash_hdr
      CREATE BY \_item
      FROM VALUE #( ( id      = gfs_header-id
                      %target = VALUE #( (     %cid                = gs_item-delivery && gs_item-posnr

                                               delivery            = gs_item-delivery
                                               posnr               = gs_item-posnr
                                               plant               = gs_item-plant
                                               matnr               = gs_item-matnr
                                               maktx               = gs_item-maktx
                                               meins               = gs_item-meins
                                               qty                 = gs_item-qty
                                               hsn                 = gs_item-hsn
                                               nwt                 = gs_item-nwt
                                               gwt                 = gs_item-gwt
                                               unit                = gs_item-unit

                                               %control-delivery     = if_abap_behv=>mk-on
                                               %control-posnr        = if_abap_behv=>mk-on
                                               %control-plant        = if_abap_behv=>mk-on
                                               %control-matnr        = if_abap_behv=>mk-on
                                               %control-maktx        = if_abap_behv=>mk-on
                                               %control-meins        = if_abap_behv=>mk-on
                                               %control-qty          = if_abap_behv=>mk-on
                                               %control-hsn          = if_abap_behv=>mk-on
                                               %control-nwt          = if_abap_behv=>mk-on
                                               %control-gwt          = if_abap_behv=>mk-on
                                               %control-unit         = if_abap_behv=>mk-on
                                        ) ) ) )
                      MAPPED FINAL(ls_mapped)
                      FAILED FINAL(ls_failed)
                      REPORTED FINAL(ls_reported).

    ENDLOOP.

    MODIFY ENTITIES OF zi_deldash_hdr IN LOCAL MODE
                ENTITY zi_deldash_hdr
                UPDATE FIELDS ( revision status )
                WITH VALUE #( ( %tky          = gfs_header-%tky
                                revision      = gfs_header-revision
                                status        = gfs_header-status
                            ) ).


  ENDMETHOD.

   METHOD cancel.
    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    READ ENTITIES OF zi_deldash_hdr IN LOCAL MODE
           ENTITY zi_deldash_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    gfs_header-canind    = 'X'.
    gfs_header-cancelby  = sy-uname.
    gfs_header-status    = 'CLOSED'.

    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
    gfs_header-cancelon = lv_date.

    MODIFY ENTITIES OF zi_deldash_hdr IN LOCAL MODE
               ENTITY zi_deldash_hdr
               UPDATE FIELDS ( canind cancelby cancelon status ) "
               WITH VALUE #( ( %tky          = gfs_header-%tky
                               canind        = gfs_header-canind
                               cancelby      = gfs_header-cancelby
                               cancelon      = gfs_header-cancelon
                               status        = gfs_header-status
                           ) ).

    READ ENTITIES OF zi_deldash_hdr IN LOCAL MODE
           ENTITY zi_deldash_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.

  METHOD deliverydetails.
    READ ENTITIES OF zi_deldash_hdr IN LOCAL MODE
           ENTITY zi_deldash_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    SELECT SINGLE deliverydocument, shiptoparty FROM i_deliverydocument
    WHERE deliverydocument = @gfs_header-delivery INTO @DATA(ls_del).

    IF ls_del IS NOT INITIAL.

      gfs_header-shpprtycode = ls_del-shiptoparty.

      SELECT SINGLE customername, streetname, cityname, region, postalcode, country
      FROM i_customer WHERE customer = @ls_del-shiptoparty INTO @DATA(ls_cust).

      gfs_header-shpprtyname = ls_cust-customername.
      gfs_header-shpprtyadd1 = ls_cust-streetname && |, | && ls_cust-cityname.

      SELECT SINGLE countryname FROM i_countrytext WHERE country = @ls_cust-country AND language = 'E'
      INTO @DATA(lv_landx).

      SELECT SINGLE regionname FROM i_regiontext WHERE country = @ls_cust-country AND region = @ls_cust-region
      AND language = 'E' INTO @DATA(lv_regio).

      gfs_header-shpprtyadd2 = lv_regio && |, | && lv_landx && |, | && ls_cust-postalcode.

      SELECT SINGLE referencesddocument FROM i_deliverydocumentitem
      WHERE deliverydocument = @gfs_header-delivery INTO @DATA(lv_so).
      IF lv_so IS NOT INITIAL.
        SELECT SINGLE yy1_portofloading1_sdh AS pol, yy1_portofdischarge1_sdh AS pod,
        yy1_countryofdestinat_sdh AS cod, yy1_countryoforigin_sdh AS coo,
        YY1_FinalDestination_sdh as fdes
        FROM i_salesdocument WHERE salesdocument = @lv_so
        INTO @DATA(ls_sodet).
        IF ls_sodet IS NOT INITIAL.
          SELECT SINGLE text FROM zi_pod_f4 WHERE value_low = @ls_sodet-pod  INTO @gfs_header-pod.
          SELECT SINGLE text FROM zi_pol_f4 WHERE value_low = @ls_sodet-pol  INTO @gfs_header-pol.
          SELECT SINGLE text FROM zi_coo_f4 WHERE value_low = @ls_sodet-coo  INTO @gfs_header-coo.
          SELECT SINGLE text FROM zi_cod_f4 WHERE value_low = @ls_sodet-cod  INTO @gfs_header-cod.
          SELECT SINGLE text FROM zi_fd_f4  WHERE value_low = @ls_sodet-fdes INTO @gfs_header-Findes.
        ENDIF.
      ENDIF.

      MODIFY ENTITIES OF zi_deldash_hdr IN LOCAL MODE
                 ENTITY zi_deldash_hdr
                 UPDATE FIELDS ( shpprtycode shpprtyname shpprtyadd1 shpprtyadd2 pod pol coo cod findes )
                 WITH VALUE #( ( %tky          = gfs_header-%tky
                                 shpprtycode   = gfs_header-shpprtycode
                                 shpprtyname   = gfs_header-shpprtyname
                                 shpprtyadd1   = gfs_header-shpprtyadd1
                                 shpprtyadd2   = gfs_header-shpprtyadd2
                                 pod           = gfs_header-pod
                                 pol           = gfs_header-pol
                                 coo           = gfs_header-coo
                                 cod           = gfs_header-cod
                                 findes        = gfs_header-findes
                             ) ).
    ENDIF.

  ENDMETHOD.

  METHOD checkdel.
    READ ENTITIES OF zi_deldash_hdr IN LOCAL MODE
           ENTITY zi_deldash_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE deliverydocument FROM i_deliverydocument
    WHERE deliverydocument = @gfs_header-delivery INTO @DATA(ls_del).
    IF ls_del IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_deldash_hdr WHERE delivery = @gfs_header-delivery AND canind <> 'X'
      INTO @DATA(ls_packlist_hdr).
      IF ls_packlist_hdr IS NOT INITIAL.
        DATA(lv_msg1) = |Delivery Data already created|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_deldash_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_deldash_hdr.
      ENDIF.
    ELSE.
      lv_msg1 = |Please provide valid Delivery Number|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_deldash_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg1 ) )
      TO reported-zi_deldash_hdr.
    ENDIF.
  ENDMETHOD.

  METHOD print.
    READ ENTITIES OF zi_deldash_hdr IN LOCAL MODE
           ENTITY zi_deldash_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT DATA(header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

        <fs_print>-invprint = 'X'.
         <fs_print>-Flag    = 'A'.

        MODIFY ENTITIES OF zi_deldash_hdr IN LOCAL MODE
                ENTITY zi_deldash_hdr
                UPDATE
                FIELDS ( invprint Flag )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 invprint =  <fs_print>-invprint
                                 Flag     =  <fs_print>-Flag
                                  %control-invprint   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_deldash_hdr IN LOCAL MODE
         ENTITY  zi_deldash_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
ENDMETHOD.
ENDCLASS.

CLASS lhc_zi_deldash_itm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_deldash_itm RESULT result.

ENDCLASS.

CLASS lhc_zi_deldash_itm IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_deldash_hdr IN LOCAL MODE
           ENTITY zi_deldash_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITIES OF zi_deldash_hdr IN LOCAL MODE
           ENTITY zi_deldash_itm
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(item).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_deldash_hdr DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_deldash_hdr IMPLEMENTATION.

  METHOD save_modified.

    IF update-zi_deldash_hdr IS NOT INITIAL.

      DATA(lt_head) = update-zi_deldash_hdr.
      READ TABLE lt_head INDEX 1 INTO DATA(wa_head).

      IF wa_head-Flag = 'A'.

      TRY.
          "Initialize Template Store Client
          DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
            iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
            iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
          ).

          DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSD_DELDASHPRNT' ).
          TRY.
              lo_store->get_schema_by_name( iv_form_name = 'PROFORMAINVOICE' ).
            CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
"" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
 "" multiple times and hence user was unable to generate print
*              IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
*                lo_store->set_schema(
*                  iv_form_name = 'PROFORMAINVOICE'
*                  is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
*                ).
*              ELSE.
*              ENDIF.
"" End Of Comment KJ 06.06.2025
          ENDTRY.


          DATA(lt_keys)     = lo_fdp_util->get_keys( ).
          lt_keys[ name = 'DELIVERYDOCUMENT' ]-value = lt_head[ 1 ]-delivery.
          TRY.
              DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
            CATCH cx_fp_fdp_error INTO DATA(lo_exception).
          ENDTRY.
          DATA(ls_template) = lo_store->get_template_by_name(
            iv_get_binary    = abap_true
            iv_form_name     = 'PROFORMAINVOICE'
            iv_template_name = 'PROFORMAINVOICE'
          ).

          DATA: lv_text   TYPE char120,
                lv_printq TYPE char32.

          SELECT SINGLE * FROM zdt_print_queue WHERE cbuser = @sy-uname INTO @DATA(ls_printq).
          IF sy-subrc = 0.
            lv_printq = ls_printq-printque.
          ELSE.
            lv_printq = 'ZDEFAULT'.
          ENDIF.

          cl_fp_ads_util=>render_4_pq(
            EXPORTING
              iv_locale       = 'en_US'
              iv_pq_name      = lv_printq "'SHIPPING_INSTRUCT'
              iv_xml_data     = lv_xml
              iv_xdp_layout   = ls_template-xdp_template
              is_options      = VALUE #(
                trace_level = 4 "Use 0 in production environment
          )
            IMPORTING
              ev_trace_string = DATA(lv_trace)
              ev_pdl          = DATA(lv_pdf)
          ).

          lv_text = |PROFORMA INVOICE PRINT | && lt_head[ 1 ]-Delivery.
          cl_print_queue_utils=>create_queue_item_by_data(
            iv_qname            = lv_printq
            iv_print_data       = lv_pdf
            iv_name_of_main_doc = lv_text
            iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
          ).

        CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
      ENDTRY.
    ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
