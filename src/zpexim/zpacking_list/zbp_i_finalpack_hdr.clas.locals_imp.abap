CLASS lhc_zi_finalpack_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_finalpack_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_finalpack_hdr RESULT result.

    METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION zi_finalpack_hdr~cancel RESULT result.
*
*    METHODS print FOR MODIFY
*      IMPORTING keys FOR ACTION zi_finalpack_hdr~print RESULT result.
*
    METHODS deliverydetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_finalpack_hdr~deliverydetails.
*
    METHODS determinepackinglist FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_finalpack_hdr~determinepackinglist.
*
    METHODS checkdel FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_finalpack_hdr~checkdel.
    METHODS prnt FOR MODIFY
      IMPORTING keys FOR ACTION zi_finalpack_hdr~prnt RESULT result.
    METHODS get_prfld FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_finalpack_hdr~get_prfld.
    METHODS update FOR MODIFY
      IMPORTING keys FOR ACTION zi_finalpack_hdr~update RESULT result.

ENDCLASS.

CLASS lhc_zi_finalpack_hdr IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
         ENTITY zi_finalpack_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).
    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>).

    result = VALUE #(
        FOR gs_head IN header
        ( %tky                   = gs_head-%tky

*          %action-cancel         = COND #( WHEN gs_head-canind  IS NOT INITIAL
*                                             OR <head>-packinglist  IS INITIAL
*                                           THEN if_abap_behv=>fc-o-disabled
*                                           ELSE if_abap_behv=>fc-o-enabled )

          %assoc-_item           = if_abap_behv=>fc-o-disabled

          %assoc-_item1          = if_abap_behv=>fc-o-disabled

*          %action-edit           = COND #( WHEN gs_head-canind  IS NOT INITIAL
*                                           THEN if_abap_behv=>fc-o-disabled
*                                           ELSE if_abap_behv=>fc-o-enabled )

        ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD cancel.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
           ENTITY zi_finalpack_hdr
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

    MODIFY ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
               ENTITY zi_finalpack_hdr
               UPDATE FIELDS ( canind cancelby cancelon status )
               WITH VALUE #( ( %tky          = gfs_header-%tky
                               canind        = gfs_header-canind
                               cancelby      = gfs_header-cancelby
                               cancelon      = gfs_header-cancelon
                               status        = gfs_header-status
                           ) ).

    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
           ENTITY zi_finalpack_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.
*
*  METHOD print.
*  ENDMETHOD.
*
  METHOD deliverydetails.

    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
           ENTITY zi_finalpack_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    gfs_header-comm_inv = |{ gfs_header-comm_inv ALPHA = IN }|.

    SELECT SINGLE plant, salesordersalesorganization
    FROM i_billingdocumentitem
    WHERE billingdocument  = @gfs_header-comm_inv INTO @DATA(ls_del).
    IF ls_del IS NOT INITIAL.
      gfs_header-salesorg = ls_del-salesordersalesorganization.
      gfs_header-plant = ls_del-plant.
    ENDIF.

    MODIFY ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
               ENTITY zi_finalpack_hdr
               UPDATE FIELDS ( salesorg plant )
               WITH VALUE #( ( %tky          = gfs_header-%tky
                               salesorg      = gfs_header-salesorg
                               plant         = gfs_header-plant
                           ) ).

  ENDMETHOD.
*
  METHOD determinepackinglist.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.
    DATA lv_packlist1(10) TYPE n.
    DATA : gs_item TYPE zdt_finlpack_itm.

    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
           ENTITY zi_finalpack_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header)
           FAILED FINAL(head_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    IF gfs_header-packinglist IS INITIAL.

      gfs_header-comm_inv = |{ gfs_header-comm_inv ALPHA = IN }|.

      gfs_header-packinglist = gfs_header-comm_inv.
      gfs_header-createdby   = sy-uname.
      gfs_header-changeddby  = sy-uname.
*      CLEAR : lv_rev.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      gfs_header-createdon = lv_date.
      gfs_header-changedon = lv_date.
      gfs_header-createdat = lv_time.
      gfs_header-changedat = lv_time.
      gfs_header-status    = 'CREATED'.

      SELECT *
      FROM zcds_commercial_inv
      WHERE billingdocument = @gfs_header-comm_inv
      INTO TABLE @DATA(lt_docitm).


      LOOP AT lt_docitm INTO DATA(ls_docitm).
        gs_item-packinglist = gfs_header-packinglist.
        gs_item-comm_inv    = gfs_header-comm_inv.
        gs_item-delivery    = ls_docitm-delivery.
        gs_item-plant       = ls_docitm-plant.
        gs_item-posnr       = ls_docitm-posnr.
        gs_item-matnr       = ls_docitm-matnr.
        gs_item-qty         = ls_docitm-qty.
        gs_item-maktx       = ls_docitm-maktx.
        gs_item-meins       = ls_docitm-meins.
        gs_item-matnetwt    = ls_docitm-matnetwt.
        gs_item-wtunit      = ls_docitm-wtunit.
        gs_item-packmat     = ls_docitm-packmat.
        gs_item-packqty     = ls_docitm-packqty.
        gs_item-packmatnwt  = ls_docitm-packmatnwt.
        gs_item-netwt       = ls_docitm-netwt.
        gs_item-growt       = ls_docitm-growt.
        gs_item-priority    = ls_docitm-priority .
        gs_item-eachnetwt   = ls_docitm-eachnetwt .
        gs_item-eachgrowt   = ls_docitm-eachgrowt .
        gs_item-packmattyp  = ls_docitm-packmattyp .
        gs_item-mateachpkg  = ls_docitm-mateachpkg .

        MODIFY ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
        ENTITY zi_finalpack_hdr
        CREATE BY \_item
        FROM VALUE #( ( id      = gfs_header-id
                        %target = VALUE #( (     %cid                = gs_item-packinglist && gs_item-delivery && gs_item-posnr

                                                 packinglist         = gs_item-packinglist
                                                 comm_inv            = gs_item-comm_inv
                                                 delivery            = gs_item-delivery
                                                 posnr               = gs_item-posnr
                                                 plant               = gs_item-plant
                                                 matnr               = gs_item-matnr
                                                 maktx               = gs_item-maktx
                                                 meins               = gs_item-meins
                                                 qty                 = gs_item-qty
                                                 packmatnwt          = gs_item-packmatnwt
                                                 eachnetwt           = gs_item-eachnetwt
                                                 eachgrowt           = gs_item-eachgrowt
                                                 packmat             = gs_item-packmat
                                                 packqty             = gs_item-packqty
                                                 netwt               = gs_item-netwt
                                                 growt               = gs_item-growt
                                                 priority            = gs_item-priority
                                                 wtunit              = gs_item-wtunit
                                                 matnetwt            = gs_item-matnetwt
                                                 packmattyp          = gs_item-packmattyp
                                                 mateachpkg          = gs_item-mateachpkg

                                                 %control-packinglist  = if_abap_behv=>mk-on
                                                 %control-comm_inv     = if_abap_behv=>mk-on
                                                 %control-delivery     = if_abap_behv=>mk-on
                                                 %control-posnr        = if_abap_behv=>mk-on
                                                 %control-plant        = if_abap_behv=>mk-on
                                                 %control-matnr        = if_abap_behv=>mk-on
                                                 %control-maktx        = if_abap_behv=>mk-on
                                                 %control-meins        = if_abap_behv=>mk-on
                                                 %control-qty          = if_abap_behv=>mk-on
                                                 %control-packmatnwt   = if_abap_behv=>mk-on
                                                 %control-eachnetwt    = if_abap_behv=>mk-on
                                                 %control-eachgrowt    = if_abap_behv=>mk-on
                                                 %control-packmat      = if_abap_behv=>mk-on
                                                 %control-packqty      = if_abap_behv=>mk-on
                                                 %control-netwt        = if_abap_behv=>mk-on
                                                 %control-growt        = if_abap_behv=>mk-on
                                                 %control-wtunit       = if_abap_behv=>mk-on
                                                 %control-packmattyp   = if_abap_behv=>mk-on
                                                 %control-mateachpkg   = if_abap_behv=>mk-on
                                                 %control-priority     = if_abap_behv=>mk-on
                                                 %control-matnetwt     = if_abap_behv=>mk-on

                                          ) ) ) )
                        MAPPED FINAL(ls_mapped)
                        FAILED FINAL(ls_failed)
                        REPORTED FINAL(ls_reported).

      ENDLOOP.


      MODIFY ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
                ENTITY zi_finalpack_hdr
                UPDATE FIELDS ( packinglist comm_inv createdby createdon createdat changeddby changedon changedat status )
                WITH VALUE #( ( %tky          = gfs_header-%tky
                                packinglist   = gfs_header-packinglist
                                comm_inv      = gfs_header-comm_inv
                                plant         = gfs_header-plant
                                salesorg      = gfs_header-salesorg
                                createdby     = gfs_header-createdby
                                createdon     = gfs_header-createdon
                                createdat     = gfs_header-createdat
                                changeddby    = gfs_header-changeddby
                                changedon     = gfs_header-changedon
                                changedat     = gfs_header-createdat
                                status        = gfs_header-status
                            ) ).

    ENDIF.

  ENDMETHOD.
*
  METHOD checkdel.

    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
         ENTITY zi_finalpack_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    gfs_header-comm_inv = |{ gfs_header-comm_inv ALPHA = IN }|.

    SELECT SINGLE billingdocument
    FROM i_billingdocumentitem
    WHERE billingdocument  = @gfs_header-comm_inv INTO @DATA(ls_del).
    IF ls_del IS NOT INITIAL.
      SELECT SINGLE *
      FROM zdt_finlpack_hdr
      WHERE packinglist = @gfs_header-comm_inv
      AND   canind <> 'X'
      INTO @DATA(ls_packlist_hdr).
      IF ls_packlist_hdr IS NOT INITIAL.
        DATA(lv_msg1) = |Packing List already created for this Commercial Invoice Number|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_finalpack_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_finalpack_hdr.
      ENDIF.
    ELSE.
      lv_msg1 = |Please provide valid Commercial Invoice Number|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_finalpack_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg1 ) )
      TO reported-zi_finalpack_hdr.
    ENDIF.

  ENDMETHOD.

  METHOD prnt.
    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
                 ENTITY zi_finalpack_hdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT DATA(header)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(header_failed).

    SELECT * FROM zdt_packpr_tmg
    INTO TABLE @DATA(lt_printitm).


    LOOP AT lt_printitm INTO DATA(ls_printitem).
      IF ls_printitem-field = 'PACKAGENO'.
        ls_printitem-fieldname = 'PKG NO'.
        UPDATE zdt_packpr_tmg
        SET fieldname = @ls_printitem-fieldname
        WHERE field = 'PACKAGENO'.
      ENDIF.
      IF ls_printitem-field =  'EACHPACKAGENETWT'.
        ls_printitem-fieldname = 'EACH PKG NET WT'.
        UPDATE zdt_packpr_tmg
     SET fieldname = @ls_printitem-fieldname
     WHERE field = 'EACHPACKAGENETWT'.
      ENDIF.
      IF ls_printitem-field = 'EACHPACKAGEGROSSWT'.
        ls_printitem-fieldname = 'EACH PKG GROSS WT'.
        UPDATE zdt_packpr_tmg
   SET fieldname = @ls_printitem-fieldname
   WHERE field = 'EACHPACKAGEGROSSWT'.
      ENDIF.


    ENDLOOP.


    READ ENTITY zi_finalpack_hdr
       BY \_item1
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(lt_item).

    DATA lt_update TYPE TABLE FOR UPDATE zi_fplprintfield.

    LOOP AT lt_item INTO DATA(ls_item).

      DATA(lv_new) = ls_item-fieldname.

      CASE ls_item-fieldname.
        WHEN 'EACH PACKAGE NET WT'.
          lv_new = 'EACH PKG NET WT'.
        WHEN 'PACKAGE NO'.
          lv_new = 'PKG NO'.
        WHEN 'EACH PACKAGE GROSS WT'.
          lv_new = 'EACH PKG GROSS WT'.
      ENDCASE.

      IF lv_new <> ls_item-fieldname.

        APPEND VALUE #(
           id = ls_item-id
        item      = ls_item-item
        packinglist  = ls_item-packinglist
          field  = ls_item-field
          fieldname = lv_new
          printallow = ls_item-printallow
          printseq   = ls_item-printseq
          %control-fieldname = if_abap_behv=>mk-on
        ) TO lt_update.

      ENDIF.

    ENDLOOP.

    IF lt_update IS NOT INITIAL.
      MODIFY ENTITIES OF zi_finalpack_hdr
        IN LOCAL MODE
        ENTITY zi_fplprintfield
        UPDATE FROM lt_update.
    ENDIF.





    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

        MODIFY ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
                ENTITY zi_finalpack_hdr
                UPDATE
                FIELDS ( prnt )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 prnt =  'Y'
                                  %control-prnt   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
         ENTITY  zi_finalpack_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD get_prfld.
    DATA : gs_item TYPE zdt_packprint.

    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
           ENTITY zi_finalpack_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT * FROM zdt_packpr_tmg
    INTO TABLE @DATA(lt_printitm).


loop at lt_printitm into data(ls_printitem).

if ls_printitem-field = 'EACHPACKAGENETWT'.
if ls_printitem-fieldname is INITIAL.
update zdt_packpr_tmg
set fieldname = 'EACH PKG NET WT'
where field = 'EACHPACKAGENETWT'.

MODIFY lt_printitm from ls_printitem TRANSPORTING fieldname.
endif.
endif.
endloop.



    LOOP AT lt_printitm ASSIGNING FIELD-SYMBOL(<lfs_printitm>).

      MODIFY ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
      ENTITY zi_finalpack_hdr
      CREATE BY \_item1
      FROM VALUE #( ( id      = gfs_header-id
                      %target = VALUE #( (     %cid      = gfs_header-packinglist && <lfs_printitm>-field
                                               field      = <lfs_printitm>-field
                                               fieldname  = <lfs_printitm>-fieldname
                                               printallow = <lfs_printitm>-printallow
                                               printseq   = <lfs_printitm>-printseq

                                               %control-field     = if_abap_behv=>mk-on
                                               %control-fieldname = if_abap_behv=>mk-on
                                               %control-printallow           = if_abap_behv=>mk-on
                                               %control-printseq            = if_abap_behv=>mk-on
                                        ) )
                        ) )
                      MAPPED FINAL(ls_mapped)
                      FAILED FINAL(ls_failed)
                      REPORTED FINAL(ls_reported).

    ENDLOOP.
  ENDMETHOD.

  METHOD update.

    DATA : lt_item TYPE TABLE OF zdt_fitem_data.
    DATA : ls_item LIKE LINE OF lt_item.

    DATA: lv_col1 TYPE char100.
    DATA: lv_col2 TYPE char100.
    DATA: lv_col3 TYPE char100.
    DATA: lv_col4 TYPE char100.
    DATA: lv_col5 TYPE char100.
    DATA: lv_col6 TYPE char100.
    DATA: lv_col7 TYPE char100.
    DATA: lv_col8 TYPE char100.
    DATA: lv_col9 TYPE char100.
    DATA: lv_col10 TYPE char100.
    DATA: lv_col11 TYPE char100.
    DATA: lv_col12 TYPE char100.
    DATA: lv_col13 TYPE char100.
    DATA: lv_col14 TYPE char100.
    DATA: lv_col15 TYPE char100.
    DATA: lv_col16 TYPE char100.
    DATA: lv_col17 TYPE char100.
    DATA: lv_col18 TYPE char100.
    DATA: lv_col19 TYPE char100.


    DATA : ls_col_table TYPE zdt_tab_propfpl.
    DATA : lt_col_table TYPE TABLE OF zdt_tab_propfpl.

    DATA: lt_max_values  TYPE TABLE OF string,
          lt_max_lengths TYPE TABLE OF i.
    DATA : flag_length TYPE i.
    DATA : col_name TYPE char100.
    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
             ENTITY zi_finalpack_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT DATA(header).

    READ ENTITY zi_finalpack_hdr
      BY  \_item1
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(item_failed).





    DATA(ls_header) = header[ 1 ].

    DATA(lt_item01) = item[].
    DELETE lt_item01 WHERE printallow IS INITIAL.
    SORT lt_item01 ASCENDING BY printseq.

    SELECT a~billingdocument,a~billingdocumentitem,
           b~billingquantityunit,b~billingquantity,b~conditionratevalue,b~priority,
           b~transactioncurrency,b~consumptiontaxctrlcodetext1,b~purchaseorderbycustomer,
           b~customerpurchaseorderdate,b~additionalmaterialgroup1,
           b~consumptiontaxctrlcode,b~packqty,b~packmattyp,b~eachnetwt,b~eachgrowt,
           b~qty,b~netwt,b~growt, b~mateachpkg,b~meins,b~contno,b~material,
           b~billingdocumentitemtext,
           b~billingdocumentdate,b~underlyingpurchaseorderitem,b~materialbycustomer
    FROM i_billingdocumentitem AS a
    LEFT OUTER JOIN zcds_finalplitem_sort AS b ON b~billingdocument = a~billingdocument
                                        AND b~billingdocumentitem = a~billingdocumentitem
     WHERE a~billingdocument = @ls_header-comm_inv
     INTO TABLE @DATA(lt_billitem).


    "Item ~ Header Row
    LOOP AT lt_item01 ASSIGNING FIELD-SYMBOL(<fs_print1>).
      IF <fs_print1> IS ASSIGNED.
        ls_item-billingdocument = ls_header-comm_inv.
        ls_item-billingdocumentitem = '00000'.
        IF <fs_print1>-fieldname = 'ITEM DESCRIPTION'.
          DATA(flag) = 'S'.
          flag_length = <fs_print1>-printseQ.
        ENDIF.

        IF sy-tabix = 1.
          ls_item-col1 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 2.
          ls_item-col2 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 3.
          ls_item-col3 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 4.
          ls_item-col4 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 5.
          ls_item-col5 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 6.
          ls_item-col6 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 7.
          ls_item-col7 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 8.
          ls_item-col8 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 9.
          ls_item-col9 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 10.
          ls_item-col10 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 11.
          ls_item-col11 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 12.
          ls_item-col12 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 13.
          ls_item-col13 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 14.
          ls_item-col14 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 15.
          ls_item-col15 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 16.
          ls_item-col16 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 17.
          ls_item-col17 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 18.
          ls_item-col18 = <fs_print1>-fieldname.
        ELSEIF sy-tabix = 19.
          ls_item-col19 = <fs_print1>-fieldname.
        ENDIF.
      ENDIF.
    ENDLOOP.

    APPEND ls_item TO lt_item.
    DELETE zdt_fitem_data FROM @ls_item.
    CLEAR : ls_item.



    "logic here read inside loop and assign values
    DATA : lv_no_col TYPE i.
    " Item ~ Body Row
    LOOP AT lt_billitem ASSIGNING FIELD-SYMBOL(<fs_item>).
      IF <fs_item> IS ASSIGNED.
        ls_item-billingdocument = ls_header-comm_inv.
        ls_item-billingdocumentitem = <fs_item>-billingdocumentitem.
        ls_item-priority            = <fs_item>-priority.
        LOOP AT lt_item01 ASSIGNING FIELD-SYMBOL(<fs_print>).
          IF <fs_print> IS ASSIGNED.
            lv_no_col = sy-tabix.
            IF sy-tabix = 1.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col1 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col1 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col1 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col1 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col1 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col1 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col1 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col1 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col1 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col1 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
             FROM zi_matfld
             WHERE product = @<fs_item>-material
             INTO @ls_item-col1      .
*                ls_item-col1 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col1 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col1 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col1 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col1 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col1 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col1 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col1 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col1 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 2.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col2 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col2 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col2 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col2 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col2 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col2 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col2 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col2 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col2 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col2 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
          FROM zi_matfld
          WHERE product = @<fs_item>-material
          INTO @ls_item-col2      .
*                ls_item-col2 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col2 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col2 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col2 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col2 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col2 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col2 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col2 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col2 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 3.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col3 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col3 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col3 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col3 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col3 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col3 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col3 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col3 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col3 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col3 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
      FROM zi_matfld
      WHERE product = @<fs_item>-material
      INTO @ls_item-col3      .
*                ls_item-col3 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col3 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col3 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col3 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col3 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col3 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col3 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col3 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col3 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 4.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col4 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col4 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col4 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col4 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col4 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col4 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col4 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col4 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col4 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col4 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
      FROM zi_matfld
      WHERE product = @<fs_item>-material
      INTO @ls_item-col4      .
*                ls_item-col4 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col4 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col4 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col4 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col4 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col4 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col4 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col4 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col4 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 5.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col5 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col5 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col5 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col5 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col5 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col5 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col5 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col5 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col5 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col5 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
FROM zi_matfld
WHERE product = @<fs_item>-material
INTO @ls_item-col5      .
*                ls_item-col5 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col5 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col5 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col5 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col5 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col5 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col5 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col5 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col5 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 6.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col6 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col6 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col6 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col6 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col6 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col6 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col6 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col6 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col6 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col6 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @ls_item-col6      .
*                ls_item-col6 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col6 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col6 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col6 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col6 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col6 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col6 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col6 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col6 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 7.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col7 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col7 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col7 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col7 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col7 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col7 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col7 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col7 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col7 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col7 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                   FROM zi_matfld
                   WHERE product = @<fs_item>-material
                   INTO @ls_item-col7      .
*                ls_item-col7 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col7 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col7 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col7 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col7 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col7 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col7 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col7 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col7 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 8.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col8 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col8 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col8 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col8 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col8 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col8 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col8 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col8 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col8 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col8 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                   FROM zi_matfld
                   WHERE product = @<fs_item>-material
                   INTO @ls_item-col8.
*                ls_item-col8 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col8 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col8 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col8 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col8 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col8 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col8 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col8 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col8 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 9.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col9 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col9 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col9 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col9 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col9 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col9 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col9 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col9 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col9 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col9 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
FROM zi_matfld
WHERE product = @<fs_item>-material
INTO @ls_item-col9      .
*                ls_item-col9 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026  ``ww2`2 ``
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col9 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col9 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col9 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col9 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col9 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col9 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col9 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col9 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 10.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col10 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col10 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col10 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col10 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col10 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col10 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col10 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col10 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col10 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col10 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
FROM zi_matfld
WHERE product = @<fs_item>-material
INTO @ls_item-col10      .
*                ls_item-col10 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col10 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col10 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col10 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col10 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col10 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col10 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col10 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col10 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 11.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col11 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col11 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col11 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col11 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col11 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col11 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col11 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col11 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col11 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col11 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
FROM zi_matfld
WHERE product = @<fs_item>-material
INTO @ls_item-col11     .
*                ls_item-col11 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col11 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col11 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col11 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col11 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col11 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col11 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col11 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col11 = <fs_item>-billingquantityunit.
              ENDIF.

            ELSEIF  sy-tabix = 12.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col12 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col12 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col12 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col12 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col12 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col12 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col12 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col12 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col12 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col12 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
FROM zi_matfld
WHERE product = @<fs_item>-material
INTO @ls_item-col12      .
*                ls_item-col12 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col12 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col12 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col12 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col12 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col12 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col12 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col12 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col12 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 13.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col13 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col13 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col13 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col13 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col13 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col13 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col13 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col13 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col13 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col13 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
FROM zi_matfld
WHERE product = @<fs_item>-material
INTO @ls_item-col13      .
*                ls_item-col13 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col13 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col13 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col13 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col13 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col13 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col13 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col13 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col13 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 14.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col14 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col14 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col14 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col14 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col14 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col14 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col14 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col14 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col14 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col14 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
FROM zi_matfld
WHERE product = @<fs_item>-material
INTO @ls_item-col14      .
*                ls_item-col14 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col14 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col14 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col14 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col14 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col14 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col14 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col14 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col14 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 15.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col15 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col15 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col15 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col15 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col15 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col15 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col15 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col15 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col15 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col15 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
FROM zi_matfld
WHERE product = @<fs_item>-material
INTO @ls_item-col15      .
*                ls_item-col15 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col15 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col15 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col15 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col15 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col15 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col15 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col15 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col15 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 16.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col16 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col16 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col16 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col16 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col16 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col16 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col16 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col16 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col16 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col16 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
FROM zi_matfld
WHERE product = @<fs_item>-material
INTO @ls_item-col16      .
*                ls_item-col16 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col16 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col16 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col16 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col16 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col16 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col16 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col16 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col16 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 17.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col17 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col17 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col17 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col17 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col17 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col17 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col17 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col17 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col17 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col17 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
FROM zi_matfld
WHERE product = @<fs_item>-material
INTO @ls_item-col17      .
*                ls_item-col17 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col17 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col17 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col17 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col17 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col17 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col17 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col17 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col17 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 18.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col18 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col18 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col18 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col18 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col18 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col18 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col18 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col18 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col18 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col18 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
FROM zi_matfld
WHERE product = @<fs_item>-material
INTO @ls_item-col18      .
*                ls_item-col18 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col18 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col18 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col18 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col18 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col18 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col18 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col18 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col18 = <fs_item>-billingquantityunit.
              ENDIF.
            ELSEIF  sy-tabix = 19.
              IF <fs_print>-field = 'CONTAINERNO'.
                ls_item-col19 = <fs_item>-contno.
              ELSEIF <fs_print>-field = 'CUSTOMERHSN'.
                ls_item-col19 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'CUSTOMERODATE'.
                ls_item-col19 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'CUSTOMERONO'.
                ls_item-col19 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'EACHPACKAGEGROSSWT'.
                ls_item-col19 = <fs_item>-eachgrowt.
              ELSEIF <fs_print>-field = 'EACHPACKAGENETWT'.
                ls_item-col19 = <fs_item>-eachnetwt.
              ELSEIF <fs_print>-field = 'FOREIGNDESCRIPTION'.
                ls_item-col19 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'GROSSTOTALWT'.
                ls_item-col19 = <fs_item>-growt.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col19 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col19 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'ITEMDESCRIPTION'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
FROM zi_matfld
WHERE product = @<fs_item>-material
INTO @ls_item-col19      .
*                ls_item-col19 = <fs_item>-BillingDocumentItemText.  "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col19 = <fs_item>-underlyingpurchaseorderitem.
              ELSEIF <fs_print>-field = 'NETTOTALWT'.
                ls_item-col19 = <fs_item>-netwt.
              ELSEIF <fs_print>-field = 'PACKAGENO'.
                ls_item-col19 = <fs_item>-packqty.
              ELSEIF <fs_print>-field = 'PACKAGETYPE'.
                ls_item-col19 = <fs_item>-packmattyp.
              ELSEIF <fs_print>-field = 'QTY/PACK'.
                ls_item-col19 = <fs_item>-mateachpkg.
              ELSEIF <fs_print>-field = 'REVISIONO'.
                ls_item-col19 = <fs_item>-additionalmaterialgroup1.
              ELSEIF <fs_print>-field = 'TOTALQTY'.
                ls_item-col19 = <fs_item>-qty.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col19 = <fs_item>-billingquantityunit.
              ENDIF.

            ENDIF.
          ENDIF.
        ENDLOOP.
        APPEND ls_item TO lt_item.
        DELETE zdt_fitem_data FROM @ls_item.
        CLEAR : ls_item.
      ENDIF.
    ENDLOOP.

    DELETE FROM zdt_fitem_data WHERE billingdocument = @ls_header-comm_inv.

    MODIFY zdt_fitem_data FROM TABLE @lt_item.


    " Fill the response table
    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
         ENTITY  zi_finalpack_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header1 IN header_1
                      ( %tky   = ls_header1-%tky
                        %param = ls_header1 ) ).

    DATA(lt_col) = lt_item[].

    FIELD-SYMBOLS: <fs_row>  TYPE any,
                   <fs_cell> TYPE any.

    " Initialize max lengths with zero for each column in the first row


    DO lv_no_col + 3 TIMES.
      APPEND 0 TO lt_max_lengths.
      APPEND '' TO lt_max_values.
    ENDDO.

    LOOP AT lt_col ASSIGNING <fs_row>.
      DO .
        ASSIGN COMPONENT sy-index OF STRUCTURE <fs_row> TO <fs_cell>.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
        READ TABLE lt_max_lengths ASSIGNING FIELD-SYMBOL(<fs_length>)  INDEX  sy-index.
        IF sy-subrc = 0 AND strlen( <fs_cell> ) > <fs_length>.
          <fs_length> = strlen( <fs_cell> ).
          lt_max_values[ sy-index ] = <fs_cell>.
        ENDIF.
      ENDDO.
    ENDLOOP.

    LOOP AT lt_max_values INTO DATA(lv_value).
      CONDENSE lv_value.
      IF sy-tabix = 2.
        ls_col_table-billingdocument = lv_value.
      ELSEIF  sy-tabix = 3.
        ls_col_table-billingdocumentitem = lv_value.
      ELSEIF sy-tabix = 4.
        ls_col_table-col1 = lv_value.
      ELSEIF sy-tabix = 5.
        ls_col_table-col2 = lv_value.
      ELSEIF sy-tabix = 6.
        ls_col_table-col3 = lv_value.
      ELSEIF sy-tabix = 7.
        ls_col_table-col4 = lv_value.
      ELSEIF sy-tabix = 8.
        ls_col_table-col5 = lv_value.
      ELSEIF sy-tabix = 9.
        ls_col_table-col6 = lv_value.
      ELSEIF sy-tabix = 10.
        ls_col_table-col7 = lv_value.
      ELSEIF sy-tabix = 11.
        ls_col_table-col8 = lv_value.
      ELSEIF sy-tabix = 12.
        ls_col_table-col9 = lv_value.
      ELSEIF sy-tabix = 13.
        ls_col_table-col10 = lv_value.
      ELSEIF sy-tabix = 14.
        ls_col_table-col11 = lv_value.
      ELSEIF sy-tabix = 15.
        ls_col_table-col12 = lv_value.
      ELSEIF sy-tabix = 16.
        ls_col_table-col13 = lv_value.
      ELSEIF sy-tabix = 17.
        ls_col_table-col14 = lv_value.
      ELSEIF sy-tabix = 18.
        ls_col_table-col15 = lv_value.
      ELSEIF sy-tabix = 19.
        ls_col_table-col16 = lv_value.
      ELSEIF sy-tabix = 20.
        ls_col_table-col17 = lv_value.
      ELSEIF sy-tabix = 21.
        ls_col_table-col18 = lv_value.
      ELSEIF sy-tabix = 22.
        ls_col_table-col19 = lv_value.
      ENDIF.
    ENDLOOP.

    DATA : ls_tab_prop TYPE zdt_tab_propfpl.


    IF flag IS NOT INITIAL.
      col_name = |{ 'COL' }{ flag_length }|.

    ENDIF.

    zcl_finalpl_tablprop=>calc_len( EXPORTING p_str = ls_col_table no_of_col = lv_no_col CHANGING p_tab_prop = ls_tab_prop ).
    IF sy-subrc = 0.
      ls_tab_prop-billingdocument = ls_col_table-billingdocument.
      IF col_name IS NOT INITIAL.
        IF col_name = 'COL1'.
          ls_tab_prop-col1 = '40mm'.
        ENDIF.
        IF    col_name = 'COL2'.
          ls_tab_prop-col2 = '40mm'.
        ENDIF.
        IF   col_name = 'COL3'.
          ls_tab_prop-col3 = '40mm'.
        ENDIF.
        IF   col_name = 'COL4'.
          ls_tab_prop-col4 = '40mm'.
        ENDIF.
        IF   col_name = 'COL5'.
          ls_tab_prop-col5 = '40mm'.
        ENDIF.
        IF   col_name = 'COL6'.
          ls_tab_prop-col6 = '40mm'.
        ENDIF.
        IF   col_name = 'COL7'.
          ls_tab_prop-col7 = '40mm'.
        ENDIF.
        IF   col_name = 'COL8'.
          ls_tab_prop-col8 = '40mm'.
        ENDIF.
        IF   col_name = 'COL9'.
          ls_tab_prop-col9 = '40mm'.
        ENDIF.
        IF   col_name = 'COL10'.
          ls_tab_prop-col10 = '40mm'.
        ENDIF.
        IF   col_name = 'COL11'.
          ls_tab_prop-col11 = '40mm'.
        ENDIF.
        IF   col_name = 'COL12'.
          ls_tab_prop-col12 = '40mm'.
        ENDIF.
        IF   col_name = 'COL13'.
          ls_tab_prop-col13 = '40mm'.
        ENDIF.
        IF   col_name = 'COL14'.
          ls_tab_prop-col14 = '40mm'.
        ENDIF.
        IF   col_name = 'COL15'.
          ls_tab_prop-col15 = '40mm'.
        ENDIF.
        IF   col_name = 'COL16'.
          ls_tab_prop-col16 = '40mm'.
        ENDIF.
        IF   col_name = 'COL17'.
          ls_tab_prop-col17 = '40mm'.
        ENDIF.
      ENDIF.

      MODIFY zdt_tab_propfpl FROM @ls_tab_prop.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_finalpack_itm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_finalpack_itm RESULT result.

*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR zi_finalpack_itm RESULT result.
*
*    METHODS copy FOR MODIFY
*      IMPORTING keys FOR ACTION zi_finalpack_itm~copy RESULT result.
*
    METHODS updateval FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_finalpack_itm~updateval.

    METHODS updatedate FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_finalpack_itm~updatedate.

ENDCLASS.

CLASS lhc_zi_finalpack_itm IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
            ENTITY zi_finalpack_hdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(header_failed).
    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>).


  ENDMETHOD.

*  METHOD get_instance_authorizations.
*  ENDMETHOD.
*
*  METHOD copy.
*  ENDMETHOD.
*
  METHOD updateval.

    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
             ENTITY zi_finalpack_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_finalpack_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item).


    SELECT a~priority, a~packqty FROM @item AS a
    WHERE a~priority IS NOT INITIAL AND a~packqty IS NOT INITIAL
    INTO TABLE @DATA(item_2).

    LOOP AT item INTO DATA(ls_item) WHERE priority IS NOT INITIAL.

      READ TABLE item_2 INTO DATA(ls_item_2) WITH KEY priority = ls_item-priority.
      IF  ls_item_2 IS NOT INITIAL.
        ls_item-mateachpkg = ( ls_item-qty / ls_item_2-packqty ).
        ls_item-eachnetwt = ( ls_item-qty / ls_item_2-packqty ) * ls_item-matnetwt.
        ls_item-netwt = ls_item-qty * ls_item-matnetwt.

        MODIFY ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
        ENTITY zi_finalpack_itm
        UPDATE FIELDS ( eachnetwt netwt mateachpkg )
        WITH VALUE #( id = ls_item-id
                      ( %tky          = ls_item-%tky
                        eachnetwt     = ls_item-eachnetwt
                        netwt         = ls_item-netwt
                        mateachpkg    = ls_item-mateachpkg
                      ) ).
      ENDIF.
      CLEAR : ls_item, ls_item_2.
    ENDLOOP.

    READ ENTITY zi_finalpack_hdr
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(item_upd).

    SELECT a~priority, SUM( a~eachnetwt ) AS eachnetwt, SUM( a~netwt ) AS netwt
    FROM @item_upd AS a
    WHERE a~priority IS NOT INITIAL
    GROUP BY a~priority
    INTO TABLE @DATA(item_upd2).

    LOOP AT item_upd INTO DATA(ls_item_upd)
    WHERE priority IS NOT INITIAL.
      READ TABLE item_upd2 INTO DATA(ls_item_upd2) WITH KEY priority = ls_item_upd-priority.
      IF ls_item_upd IS NOT INITIAL.
        IF ls_item_upd-packqty IS NOT INITIAL.
          ls_item_upd-eachgrowt = ls_item_upd2-eachnetwt + ls_item_upd-packmatnwt.
          ls_item_upd-growt = ls_item_upd2-netwt + ( ls_item_upd-packmatnwt * ls_item_upd-packqty ).
        ELSE.
          CLEAR : ls_item_upd-eachgrowt, ls_item_upd-growt.
        ENDIF.
        MODIFY ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
        ENTITY zi_finalpack_itm
        UPDATE FIELDS ( eachgrowt growt )
        WITH VALUE #( id = ls_item_upd-id
                      ( %tky          = ls_item_upd-%tky
                        eachgrowt     = ls_item_upd-eachgrowt
                        growt         = ls_item_upd-growt
                      ) ).
      ENDIF.
      CLEAR : ls_item_upd, ls_item_upd2.
    ENDLOOP.

  ENDMETHOD.

  METHOD updatedate.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
           ENTITY zi_finalpack_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    gfs_header-changeddby  = sy-uname.

    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

    gfs_header-changedon = lv_date.
    gfs_header-createdat = lv_time.

    MODIFY ENTITIES OF zi_finalpack_hdr IN LOCAL MODE
              ENTITY zi_finalpack_hdr
              UPDATE FIELDS ( changeddby changedon changedat )
              WITH VALUE #( ( %tky          = gfs_header-%tky
                              changeddby    = gfs_header-changeddby
                              changedon     = gfs_header-changedon
                              changedat     = gfs_header-createdat
                          ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_finalpack_hdr DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_finalpack_hdr IMPLEMENTATION.

  METHOD save_modified.
    IF update-zi_finalpack_hdr IS NOT INITIAL.

      DATA: lv_printq TYPE char32.

      SELECT SINGLE * FROM zdt_print_queue WHERE cbuser = @sy-uname INTO @DATA(ls_printq).
      IF sy-subrc = 0.
        lv_printq = ls_printq-printque.
      ELSE.
        lv_printq = 'ZDEFAULT'.
      ENDIF.
      DATA(lt_head) = update-zi_finalpack_hdr.
      READ TABLE lt_head INDEX 1 INTO DATA(wa_head).

      IF wa_head-prnt = 'Y'.
        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSD_FINALPLFORM' ) ." 'ZSERV_D_PRINT' ).
*                                                                iv_root_node          = 'ZVSHIPNOT' ).

            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'FINALPACKLIST' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
                "" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
                "" multiple times and hence user was unable to generate print
***                IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
***                  lo_store->set_schema(
***                    iv_form_name = 'FINALPACKLIST'
***                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
***                  ).
***                ELSE.
***                ENDIF.
                "" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys)     = lo_fdp_util->get_keys( ).
*        lt_keys[ name = 'ID' ]-value = lt_head[ 1 ]-id.
            lt_keys[ name = 'BILLINGDOCUMENT' ]-value = lt_head[ 1 ]-comm_inv.
*          DATA(lv_sh) = VALUE #( lt_head[ 1 ]-Id OPTIONAL ).
            TRY.
                DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception).
            ENDTRY.
            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'FINALPACKLIST'
              iv_template_name = 'FINALPACKLIST'
            ).
*            cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml
*                                                  iv_xdp_layout   = ls_template-xdp_template
*                                                  iv_locale       = 'en_US'
*                                                  is_options      = VALUE #(
*                                                              trace_level = 4 )
*                                        IMPORTING ev_pdf          = DATA(lv_pdf01)
*                                                  ev_trace_string = DATA(lv_trace01)
*                                                   ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      = lv_printq
                iv_xml_data     = lv_xml
                iv_xdp_layout   = ls_template-xdp_template
                is_options      = VALUE #(
                  trace_level = 4 "Use 0 in production environment
            )
              IMPORTING
                ev_trace_string = DATA(lv_trace)
                ev_pdl          = DATA(lv_pdf)
            ).

            DATA: lv_text TYPE char120.
            DATA: lv_fdpl TYPE char120.

            lv_fdpl = lt_head[ 1 ]-comm_inv.

            lv_text = |FINAL PACKING LIST PRINT | && lv_fdpl.
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

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
