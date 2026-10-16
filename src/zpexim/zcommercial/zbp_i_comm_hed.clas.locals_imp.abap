CLASS lhc_zi_comm_hed DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_comm_hed RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_comm_hed RESULT result.

    METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION zi_comm_hed~cancel RESULT result.

    METHODS print FOR MODIFY
      IMPORTING keys FOR ACTION zi_comm_hed~print RESULT result.

    METHODS shipnotdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_comm_hed~shipnotdetails.

    METHODS details FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_comm_hed~details.

    METHODS checkdoc FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_comm_hed~checkdoc.

    METHODS get_printfld FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_comm_hed~get_printfld.
    METHODS update FOR MODIFY
      IMPORTING keys FOR ACTION zi_comm_hed~update RESULT result.
    METHODS commprint FOR MODIFY
      IMPORTING keys FOR ACTION zi_comm_hed~commprint RESULT result.
    METHODS commsplitval FOR MODIFY
      IMPORTING keys FOR ACTION zi_comm_hed~commsplitval RESULT result.
    METHODS finalinvoicefob FOR MODIFY
      IMPORTING keys FOR ACTION zi_comm_hed~finalinvoicefob RESULT result.


ENDCLASS.

CLASS lhc_zi_comm_hed IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
             ENTITY zi_comm_hed
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(lt_header).
    CHECK lt_header IS NOT INITIAL .

    result = VALUE #( FOR ls_header IN lt_header
                      ( %tky         = ls_header-%tky

*/-- Comment for Edit Item Line Test in PRD--*
***                        %assoc-_item      =  if_abap_behv=>fc-o-disabled

                      ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD cancel.
  ENDMETHOD.

  METHOD checkdoc.
    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
             ENTITY zi_comm_hed
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header1).

    DATA(gfs_header1) = VALUE #( header1[ 1 ]  OPTIONAL ).
    IF gfs_header1-commid IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_comm_hed
      WHERE commid = @gfs_header1-commid
      INTO @DATA(ls_del1).
      IF ls_del1 IS NOT INITIAL.

        DATA(lv_msg1) = |Document Already Exists|.
        APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_comm_hed.

        APPEND VALUE #( %tky        = gfs_header1-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_comm_hed.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD details.
    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
          ENTITY zi_comm_hed
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(header)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(header_failed).

    DATA(ls_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zr_comminv_f4
    WHERE billingdocument = @ls_header-commid
    INTO @DATA(wa_det).

    IF sy-subrc = 0.
      ls_header-documentdate = wa_det-billingdocumentdate.
      ls_header-customercode = wa_det-customer.
      ls_header-customername = wa_det-customerfullname.
    ENDIF.

    SELECT SINGLE * FROM zcds_custbank
                    WHERE billingdocument = @ls_header-commid INTO @DATA(ls_custbank).
    IF sy-subrc EQ 0.
      ls_header-payrecvbank     = ls_custbank-bankname.
      ls_header-payrecvbankadrc = ls_custbank-streetname && | | && ls_custbank-cityname.
    ENDIF.


    MODIFY ENTITIES OF zi_comm_hed IN LOCAL MODE
              ENTITY zi_comm_hed
              UPDATE
              FIELDS ( documentdate customercode customername
                       payrecvbank payrecvbankadrc )
              WITH VALUE #( ( %tky = ls_header-%tky
                              documentdate    = ls_header-documentdate
                              customercode    = ls_header-customercode
                              customername    = ls_header-customername
                              payrecvbank     = ls_header-payrecvbank
                              payrecvbankadrc = ls_header-payrecvbankadrc

                              ) ).

  ENDMETHOD.

  METHOD shipnotdetails.
    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
        ENTITY zi_comm_hed
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(header)
        " TODO: variable is assigned but never used (ABAP cleaner)
        FAILED FINAL(header_failed).

    DATA(ls_header) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zcds_ship_not_hdr
     WHERE billingdoc = @ls_header-commid
      INTO @DATA(wa_input).
    IF sy-subrc = 0.
      ls_header-customername = wa_input-customerfullname.
      ls_header-gstinvno     = wa_input-gstinv.
      ls_header-invdate      = wa_input-gstinvdt.
      ls_header-companyname  = wa_input-name.
      ls_header-comadd1      = wa_input-caddress1.
      ls_header-comadd2      = wa_input-caddress2.
      ls_header-creationdate = wa_input-creationdate.
      ls_header-creationtime = wa_input-creationtime.
      ls_header-indexno      = wa_input-externalitemid.
      ls_header-pono         = wa_input-purchaseorderbycustomer.
      ls_header-polineno     = wa_input-underlyingpurchaseorderitem.
      ls_header-podate       = wa_input-customerpurchaseorderdate.

    ENDIF.

    SELECT SINGLE * FROM zcds_ship_not_hdr1
     WHERE billingdocument = @ls_header-commid
      INTO @DATA(wa_input1).
    IF sy-subrc = 0.
      ls_header-sono = wa_input1-salesdocument.
      ls_header-salesnoteno  = wa_input1-referencesddocument.
      ls_header-itemcode     = wa_input1-materialbycustomer.
      ls_header-itemname     = wa_input1-billingdocumentitemtext.
      ls_header-quantity     = wa_input1-billingquantity.
      ls_header-sumquantity  = wa_input1-sum_qty.
      ls_header-stuffingdate = wa_input1-stuffdt.
      ls_header-containerno  = wa_input1-contno.
      ls_header-shippingline = wa_input1-shipline.

    ENDIF.


    MODIFY ENTITIES OF zi_comm_hed IN LOCAL MODE
      ENTITY zi_comm_hed
      UPDATE
      FIELDS ( comadd1 comadd2 companyname creationdate creationtime customername gstinvno invdate
      sono salesnoteno itemcode itemname quantity sumquantity stuffingdate containerno shippingline
      pono indexno podate polineno )
      WITH VALUE #( ( %tky = ls_header-%tky
                      companyname  = ls_header-companyname
                      comadd1      = ls_header-comadd1
                      comadd2      = ls_header-comadd2
                      customername = ls_header-customername
                      gstinvno     = ls_header-gstinvno
                      invdate      = ls_header-invdate
                      creationdate = ls_header-creationdate
                      creationtime = ls_header-creationtime
                      sono         = ls_header-sono
                      salesnoteno  = ls_header-salesnoteno
                      itemcode     = ls_header-itemcode
                      itemname     = ls_header-itemname
                      quantity     = ls_header-quantity
                      sumquantity  = ls_header-sumquantity
                      stuffingdate = ls_header-stuffingdate
                      containerno  = ls_header-containerno
                      shippingline = ls_header-shippingline
                      podate       = ls_header-podate
                      pono         = ls_header-pono
                      polineno     = ls_header-polineno
                      indexno      = ls_header-indexno
                   ) ).

  ENDMETHOD.

  METHOD print.
    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
           ENTITY zi_comm_hed
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT DATA(header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

        <fs_print>-tprint = 'X'.
        <fs_print>-flag   = 'A'.

        MODIFY ENTITIES OF zi_comm_hed IN LOCAL MODE
                ENTITY zi_comm_hed
                UPDATE
                FIELDS ( tprint flag )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 tprint =  <fs_print>-tprint
                                 flag   =  <fs_print>-flag
                                  %control-tprint   = if_abap_behv=>mk-on
                                  %control-flag   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
         ENTITY  zi_comm_hed
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD get_printfld.

    DATA : gs_item TYPE zdt_comprintfld.

    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
           ENTITY zi_comm_hed
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT * FROM zdt_printfield
    INTO TABLE @DATA(lt_printitm).


*    APPEND VALUE #(                              "Added by Infocus on 26th Dec 2025
*      client     = sy-mandt
*      field      = 'UNIT_WT'
*      fieldname  = 'UNIT_WT'
*      printallow = abap_true
*      printseq   = 15
*    ) TO lt_printitm.
*
*    APPEND VALUE #(
*      client     = sy-mandt
*      field      = 'TOTAL_WT'
*      fieldname  = 'TOTAL_WT'
*      printallow = abap_true
*      printseq   = 16
*    ) TO lt_printitm.
*
*    APPEND VALUE #(
*      client     = sy-mandt
*      field      = 'STEEL_UNIT_WT'
*      fieldname  = 'STEEL_UNIT_WT'
*      printallow = abap_true
*      printseq   = 17
*    ) TO lt_printitm.
*
*    APPEND VALUE #(
*  client     = sy-mandt
*  field      = 'NON_STEEL_UNIT_WT'
*  fieldname  = 'NON_STEEL_UNIT_WT'
*  printallow = abap_true
*  printseq   = 18
*) TO lt_printitm.
*
*
*    APPEND VALUE #(
*      client     = sy-mandt
*      field      = 'STEEL_UNIT_PRICE'
*      fieldname  = 'STEEL_UNIT_PRICE'
*      printallow = abap_true
*      printseq   = 19
*    ) TO lt_printitm.
*    APPEND VALUE #(
*      client     = sy-mandt
*      field      = 'STEEL_TOTAL_PRICE'
*      fieldname  = 'STEEL_TOTAL_PRICE'
*      printallow = abap_true
*      printseq   = 20
*    ) TO lt_printitm.
*    APPEND VALUE #(
*      client     = sy-mandt
*      field      = 'TOTAL_PRICE'
*      fieldname  = 'TOTAL_PRICE'
*      printallow = abap_true
*      printseq   = 21
*    ) TO lt_printitm.
*    APPEND VALUE #(
*      client     = sy-mandt
*      field      = 'NON_STEEL_UNIT_PRICE'
*      fieldname  = 'NON_STEEL_UNIT_PRICE'
*      printallow = abap_true
*      printseq   = 22
*    ) TO lt_printitm.
*    APPEND VALUE #(
*      client     = sy-mandt
*      field      = 'NON_STEEL_TOTAL_PRICE'
*      fieldname  = 'NON_STEEL_TOTAL_PRICE'
*      printallow = abap_true
*      printseq   = 23
*    ) TO lt_printitm.

    LOOP AT lt_printitm ASSIGNING FIELD-SYMBOL(<lfs_printitm>).

      MODIFY ENTITIES OF zi_comm_hed IN LOCAL MODE
      ENTITY zi_comm_hed
      CREATE BY \_item
      FROM VALUE #( ( id      = gfs_header-id
                      commid  = gfs_header-commid
                      %target = VALUE #( (     %cid      = gfs_header-commid && <lfs_printitm>-field

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

    DATA : lt_item TYPE TABLE OF zdt_item_data.
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


    DATA : ls_col_table TYPE zdt_tab_prop.

    DATA: lt_max_values  TYPE TABLE OF string,
          lt_max_lengths TYPE TABLE OF i.

    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
             ENTITY zi_comm_hed
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT DATA(header).

    READ ENTITY zi_comm_hed
      BY  \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(item_failed).

    DATA(ls_header) = header[ 1 ].

    DATA(lt_item01) = item[].
    DELETE lt_item01 WHERE printallow IS INITIAL.
    SORT lt_item01 ASCENDING BY printseq.

    SELECT a~billingdocument,a~billingdocumentitem,a~netamount,
           b~billingquantityunit,b~billingquantity,b~conditionratevalue,
           b~transactioncurrency,b~consumptiontaxctrlcodetext1,b~amount,b~materialbycustomer,
           b~consumptiontaxctrlcode,b~purchaseorderbycustomer,b~customerpurchaseorderdate, b~material,
           b~billingdocumentitemtext,b~billingdocumentdate,b~underlyingpurchaseorderitem,
           b~purchaseorderbyshiptoparty

    FROM i_billingdocumentitem AS a
    LEFT OUTER JOIN zvfinalcomdata AS b ON b~billingdocument = a~billingdocument
                                        AND b~billingdocumentitem = a~billingdocumentitem

     WHERE a~billingdocument = @ls_header-commid
     INTO TABLE @DATA(lt_billitem).


    "Item ~ Header Row
    LOOP AT lt_item01 ASSIGNING FIELD-SYMBOL(<fs_print1>).
      IF <fs_print1> IS ASSIGNED.
        ls_item-billingdocument = ls_header-commid.
        ls_item-billingdocumentitem = '00000'.
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
*        ELSEIF sy-tabix = 15.
*          ls_item-col15 = <fs_print1>-fieldname.
*        ELSEIF sy-tabix = 16.
*          ls_item-col16 = <fs_print1>-fieldname.
*        ELSEIF sy-tabix = 17.
*          ls_item-col17 = <fs_print1>-fieldname.
*        ELSEIF sy-tabix = 18.
*          ls_item-col18 = <fs_print1>-fieldname.
*        ELSEIF sy-tabix = 19.
*          ls_item-col19 = <fs_print1>-fieldname.
        ENDIF.
      ENDIF.
    ENDLOOP.

    APPEND ls_item TO lt_item.
    DELETE zdt_item_data FROM @ls_item.
    CLEAR : ls_item.

    "logic here read inside loop and assign values
    DATA : lv_no_col TYPE i.
    DATA : unit_wt TYPE p DECIMALS 2.
    DATA : total_wt TYPE p DECIMALS 2.
    DATA : steel_unit_wt TYPE p DECIMALS 2.
    DATA : non_steel_unit_wt TYPE p DECIMALS 2.
    DATA : total_price TYPE p DECIMALS 2.
    DATA : steel_unit_price TYPE p DECIMALS 2.
    DATA : non_steel_unit_price TYPE p DECIMALS 2.
    DATA : steel_total_price TYPE p DECIMALS 2.
    DATA : non_steel_total_price TYPE p DECIMALS 2.
    " Item ~ Body Row
    DATA(lt_billitem1) = lt_billitem[].
    LOOP AT lt_billitem ASSIGNING FIELD-SYMBOL(<fs_item>).
      LOOP AT lt_billitem1 INTO DATA(ls_billitem1) WHERE billingdocument = ls_header-commid.
        total_price = total_price + ls_billitem1-amount.
      ENDLOOP.
      IF <fs_item> IS ASSIGNED.
        ls_item-billingdocument = ls_header-commid.
        ls_item-billingdocumentitem = <fs_item>-billingdocumentitem.

        LOOP AT lt_item01 ASSIGNING FIELD-SYMBOL(<fs_print>).
          IF <fs_print> IS ASSIGNED.
            lv_no_col = sy-tabix.
            IF sy-tabix = 1.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col1 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
              select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
              if sy-subrc = 0.
                ls_item-col1 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col1 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col1 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col1 = <fs_item>-customerpurchaseorderdate.
*              ELSEIF <fs_print>-field = 'MATERIAL'.
*                ls_item-col1 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                   FROM zi_matfld
                   WHERE product = @<fs_item>-material
                   INTO @ls_item-col1      .
*              ls_item-col1   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col1 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col1 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col1 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col1 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col1 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col1 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                 select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
              if sy-subrc = 0.
                ls_item-col1 = <fs_item>-transactioncurrency && | | &&  <fs_item>-amount.
              endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col1 = <fs_item>-underlyingpurchaseorderitem.

              ENDIF.

            ELSEIF  sy-tabix = 2.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col2 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col2 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col2 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col2 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col2 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                FROM zi_matfld
                WHERE product = @<fs_item>-material
                INTO @ls_item-col2      .
*              ls_item-col2   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.    .
                ls_item-col2 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col2 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col2 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col2 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col2 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col2 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col2 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col2 = <fs_item>-underlyingpurchaseorderitem.

              ENDIF.

            ELSEIF  sy-tabix = 3.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col3 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col3 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col3 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col3 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col3 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                 FROM zi_matfld
                 WHERE product = @<fs_item>-material
                 INTO @ls_item-col3      .
*              ls_item-col3   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col3 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col3 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col3 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col3 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col3 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col3 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col3 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col3 = <fs_item>-underlyingpurchaseorderitem.

              ENDIF.

            ELSEIF  sy-tabix = 4.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col4 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col4 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
               endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col4 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col4 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col4 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                 FROM zi_matfld
                 WHERE product = @<fs_item>-material
                 INTO @ls_item-col4      .
*              ls_item-col4   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col4 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col4 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col4 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col4 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col4 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col4 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
              if sy-subrc = 0.
                ls_item-col4 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col4 = <fs_item>-underlyingpurchaseorderitem.


              ENDIF.


            ELSEIF  sy-tabix = 5.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col5 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col5 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col5 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col5 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col5 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
           FROM zi_matfld
           WHERE product = @<fs_item>-material
           INTO @ls_item-col5      .
*              ls_item-col5   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col5 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col5 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col5 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col5 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col5 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col5 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
              if sy-subrc = 0.
                ls_item-col5 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col5 = <fs_item>-underlyingpurchaseorderitem.

              ENDIF.

            ELSEIF  sy-tabix = 6.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col6 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col6 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col6 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col6 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col6 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
              FROM zi_matfld
              WHERE product = @<fs_item>-material
              INTO @ls_item-col6      .
*              ls_item-col6   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col6 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col6 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col6 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col6 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col6 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col6 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col6 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col6 = <fs_item>-underlyingpurchaseorderitem.


              ENDIF.

            ELSEIF  sy-tabix = 7.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col7 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col7 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col7 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col7 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col7 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
           FROM zi_matfld
           WHERE product = @<fs_item>-material
           INTO @ls_item-col7      .
*              ls_item-col7   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col7 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col7 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col7 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col7 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col7 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col7 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col7 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col7 = <fs_item>-underlyingpurchaseorderitem.

              ENDIF.


            ELSEIF  sy-tabix = 8.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col8 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col8 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col8 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col8 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col8 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
            FROM zi_matfld
            WHERE product = @<fs_item>-material
            INTO @ls_item-col8      .
*              ls_item-col8   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col8 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col8 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col8 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col8 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col8 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col8 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col8 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col8 = <fs_item>-underlyingpurchaseorderitem.
              ENDIF.


            ELSEIF  sy-tabix = 9.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col9 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col9 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col9 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col9 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col9 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
             FROM zi_matfld
             WHERE product = @<fs_item>-material
             INTO @ls_item-col9      .
*              ls_item-col9   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col9 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col9 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col9 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col9 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col9 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col9 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col9 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col9 = <fs_item>-underlyingpurchaseorderitem.


              ENDIF.


            ELSEIF  sy-tabix = 10.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col10 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col10 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col10 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col10 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col10 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
              FROM zi_matfld
              WHERE product = @<fs_item>-material
              INTO @ls_item-col10      .
*              ls_item-col10   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col10 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col10 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col10 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col10 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col10 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col10 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col10 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col10 = <fs_item>-underlyingpurchaseorderitem.

              ENDIF.


            ELSEIF  sy-tabix = 11.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col11 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col11 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col11 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col11 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col11 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
            FROM zi_matfld
            WHERE product = @<fs_item>-material
            INTO @ls_item-col11      .
*              ls_item-col11   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col11 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col11 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col11 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col11 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col11 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col11 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col11 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col11 = <fs_item>-underlyingpurchaseorderitem.


              ENDIF.



            ELSEIF  sy-tabix = 12.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col12 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
              if sy-subrc = 0.
                ls_item-col12 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col12 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col12 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col12 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
              FROM zi_matfld
              WHERE product = @<fs_item>-material
              INTO @ls_item-col12      .
*              ls_item-col12   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col12 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col12 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col12 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col12 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col12 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col12 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col12 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col12 = <fs_item>-underlyingpurchaseorderitem.

              ENDIF.


            ELSEIF  sy-tabix = 13.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col13 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col13 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col13 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col13 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col13 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
            FROM zi_matfld
            WHERE product = @<fs_item>-material
            INTO @ls_item-col13      .
*              ls_item-col13   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col13 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col13 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col13 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col13 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col13 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col13 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col13 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col13 = <fs_item>-underlyingpurchaseorderitem.

              ENDIF.


            ELSEIF  sy-tabix = 14.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col14 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col14 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col14 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col14 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col14 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
            FROM zi_matfld
            WHERE product = @<fs_item>-material
            INTO @ls_item-col14      .
*              ls_item-col14   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col14 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col14 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col14 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col14 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col14 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col14 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col14 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col14 = <fs_item>-underlyingpurchaseorderitem.

              ENDIF.
            ELSEIF sy-tabix = 15.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col15 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col15 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col15 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col15 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col15 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
           FROM zi_matfld
           WHERE product = @<fs_item>-material
           INTO @ls_item-col15      .
*              ls_item-col15   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col15 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col15 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col15 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col15 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col15 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col15 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col15 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col15 = <fs_item>-underlyingpurchaseorderitem.


              ENDIF.
            ELSEIF sy-tabix = 16.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col16 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col16 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col16 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col16 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col16 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
           FROM zi_matfld
           WHERE product = @<fs_item>-material
           INTO @ls_item-col16      .
*              ls_item-col16   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col16 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col16 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col16 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col16 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col16 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col16 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col16 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col16 = <fs_item>-underlyingpurchaseorderitem.

              ENDIF.
            ELSEIF sy-tabix = 17.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col17 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col17 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col17 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col17 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col17 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
             FROM zi_matfld
             WHERE product = @<fs_item>-material
             INTO @ls_item-col17      .
*              ls_item-col17   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col17 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col17 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col17 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col17 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col17 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col17 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col17 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col17 = <fs_item>-underlyingpurchaseorderitem.


              ENDIF.
            ELSEIF sy-tabix = 18.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col18 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col18 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col18 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col18 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col18 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
             FROM zi_matfld
             WHERE product = @<fs_item>-material
             INTO @ls_item-col18      .
*              ls_item-col18   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col18 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col18 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col18 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col18 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col18 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col18 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col18 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col18 = <fs_item>-underlyingpurchaseorderitem.
              ENDIF.
            ELSEIF sy-tabix = 19.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col19 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                  select single conditionratevalue from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-conditionratevalue.
                if sy-subrc = 0.
                ls_item-col19 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
                endif.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col19 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col19 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col19 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
            FROM zi_matfld
            WHERE product = @<fs_item>-material
            INTO @ls_item-col19      .
*              ls_item-col19   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col19 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col19 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col19 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col19 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col19 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col19 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                      select single conditionAMOUNT from I_BillingDocItemPrcgElmntBasic where BillingDocument = @ls_item-billingdocument
              and BillingDocumentItem = @ls_item-billingdocumentitem and ( conditiontype = 'ZPR0' or conditiontype = 'ZPR1' ) INTO @<fs_item>-amount.
                 if sy-subrc = 0.
                ls_item-col19 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
                endif.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col19 = <fs_item>-underlyingpurchaseorderitem.


              ENDIF.

            ENDIF.
          ENDIF.
        ENDLOOP.
        APPEND ls_item TO lt_item.
        DELETE zdt_item_data FROM @ls_item.
        CLEAR : ls_item.
      ENDIF.
    ENDLOOP.

    MODIFY zdt_item_data FROM TABLE @lt_item.


    " Fill the response table
    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
         ENTITY  zi_comm_hed
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
      ENDIF.
    ENDLOOP.

    DATA : ls_tab_prop TYPE zdt_tab_prop.

    zcl_tab_prop=>calc_len( EXPORTING p_str = ls_col_table no_of_col = lv_no_col CHANGING p_tab_prop = ls_tab_prop ).
    IF sy-subrc = 0.
      ls_tab_prop-billingdocument = ls_col_table-billingdocument.
      MODIFY zdt_tab_prop FROM @ls_tab_prop.
    ENDIF.

  ENDMETHOD.

  METHOD commprint.

    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
             ENTITY zi_comm_hed
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT DATA(header)
             " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

        <fs_print>-cprint = 'X'.
        <fs_print>-flag   = 'B'.

        MODIFY ENTITIES OF zi_comm_hed IN LOCAL MODE
                ENTITY zi_comm_hed
                UPDATE
                FIELDS ( cprint flag )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 cprint =  <fs_print>-cprint
                                 flag   =  <fs_print>-flag
                                 %control-flag   = if_abap_behv=>mk-on
                                  %control-cprint   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
         ENTITY  zi_comm_hed
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD commsplitval.

    DATA : unit_wt TYPE p DECIMALS 2.
    DATA : total_wt TYPE p DECIMALS 2.
    DATA : steel_unit_wt TYPE p DECIMALS 2.
    DATA : non_steel_unit_wt TYPE p DECIMALS 2.
    DATA : total_price TYPE p DECIMALS 2.
    DATA : steel_unit_price TYPE p DECIMALS 2.
    DATA : non_steel_unit_price TYPE p DECIMALS 2.
    DATA : steel_total_price TYPE p DECIMALS 2.
    DATA : non_steel_total_price TYPE p DECIMALS 2.
    DATA : lt_item TYPE TABLE OF zdt_item_data.
    DATA : ls_item LIKE LINE OF lt_item.
    DATA : item TYPE TABLE OF zdt_printfield.
    DATA : ls_col_table TYPE zdt_tab_prop.
    DATA : lv_no_col TYPE i.
    data : unit_price type p DECIMALS 2.

    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
                ENTITY zi_comm_hed
                ALL FIELDS
                WITH CORRESPONDING #( keys )
                RESULT DATA(header)
                FAILED FINAL(header_failed).


    SELECT * FROM zdt_printfield
    INTO TABLE @item.

    APPEND VALUE #(                              "Added by Infocus on 26th Dec 2025
         client     = sy-mandt
         field      = 'UNIT_WT'
         fieldname  = 'UNIT_WT'
         printallow = abap_true
         printseq   = 15
       ) TO item.

    APPEND VALUE #(
      client     = sy-mandt
      field      = 'TOTAL_WT'
      fieldname  = 'TOTAL_WT'
      printallow = abap_true
      printseq   = 16
    ) TO item.

    APPEND VALUE #(
      client     = sy-mandt
      field      = 'STEEL_UNIT_WT'
      fieldname  = 'STEEL_UNIT_WT'
      printallow = abap_true
      printseq   = 17
    ) TO item.

    APPEND VALUE #(
  client     = sy-mandt
  field      = 'NON_STEEL_UNIT_WT'
  fieldname  = 'NON_STEEL_UNIT_WT'
  printallow = abap_true
  printseq   = 18
) TO item.


    APPEND VALUE #(
      client     = sy-mandt
      field      = 'STEEL_UNIT_PRICE'
      fieldname  = 'STEEL_UNIT_PRICE'
      printallow = abap_true
      printseq   = 19
    ) TO item.
    APPEND VALUE #(
      client     = sy-mandt
      field      = 'STEEL_TOTAL_PRICE'
      fieldname  = 'STEEL_TOTAL_PRICE'
      printallow = abap_true
      printseq   = 20
    ) TO item.

    APPEND VALUE #(
      client     = sy-mandt
      field      = 'TOTAL_PRICE'
      fieldname  = 'TOTAL_PRICE'
      printallow = abap_true
      printseq   = 21
    ) TO item.

    APPEND VALUE #(
      client     = sy-mandt
      field      = 'NON_STEEL_UNIT_PRICE'
      fieldname  = 'NON_STEEL_UNIT_PRICE'
      printallow = abap_true
      printseq   = 22
    ) TO item.



    APPEND VALUE #(
      client     = sy-mandt
      field      = 'NON_STEEL_TOTAL_PRICE'
      fieldname  = 'NON_STEEL_TOTAL_PRICE'
      printallow = abap_true
      printseq   = 23
    ) TO item.


    APPEND VALUE #(
      client     = sy-mandt
      field      = 'CURRENCY'
      fieldname  = 'CURRENCY'
      printallow = abap_true
      printseq   = 24
    ) TO item.

    APPEND VALUE #(
  client     = sy-mandt
  field      = 'UOM'
  fieldname  = 'UOM'
  printallow = abap_true
  printseq   = 25
) TO item.

    APPEND VALUE #(
client     = sy-mandt
field      = 'UNIT_PRICE'
fieldname  = 'UNIT_PRICE'
printallow = abap_true
printseq   = 26
) TO item.


    LOOP AT item ASSIGNING FIELD-SYMBOL(<ls_seq>) .
      IF <ls_seq> IS ASSIGNED.
        IF <ls_seq>-fieldname = 'ITEM CODE'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 1.
        ELSEIF <ls_seq>-fieldname = 'ITEM DESCRIPTION'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 2.
        ELSEIF <ls_seq>-fieldname = 'MATERIAL DESCRIPTION'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 3.
        ELSEIF <ls_seq>-fieldname = 'ORDER NO'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 4.
        ELSEIF <ls_seq>-fieldname = 'ORDER DT'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 5.
        ELSEIF <ls_seq>-fieldname = 'HSN CODE'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 6.
        ELSEIF <ls_seq>-fieldname = 'QTY'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 7.
        ELSEIF <ls_seq>-fieldname = 'CURRENCY'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 8.
        ELSEIF <ls_seq>-fieldname = 'UOM'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 9.
        ELSEIF <ls_seq>-fieldname = 'UNIT_PRICE'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 10.
        ELSEIF <ls_seq>-fieldname = 'UNIT_WT'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 11.
        ELSEIF <ls_seq>-fieldname = 'TOTAL_WT'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 12.
        ELSEIF <ls_seq>-fieldname = 'STEEL_UNIT_WT'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 13.
        ELSEIF <ls_seq>-fieldname = 'NON_STEEL_UNIT_WT'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 14.
        ELSEIF <ls_seq>-fieldname = 'STEEL_UNIT_PRICE'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 15.
        ELSEIF <ls_seq>-fieldname = 'NON_STEEL_UNIT_PRICE'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 16.
        ELSEIF <ls_seq>-fieldname = 'STEEL_TOTAL_PRICE'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 17.
        ELSEIF <ls_seq>-fieldname = 'NON_STEEL_TOTAL_PRICE'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 18.
        ELSEIF <ls_seq>-fieldname = 'TOTAL_PRICE'.
          <ls_seq>-printallow = 'X'.
          <ls_seq>-printseq = 19.
        ELSE.
          <ls_seq>-printallow = ''.
        ENDIF.
      ENDIF.


    ENDLOOP.

*read Entity zi_comm_hed
*by \_item all FIELDS WITH CORRESPONDING #( keys )
*RESULT data(item)
*FAILED data(lt_fld).



    DATA(ls_header) = header[ 1 ].

    DATA(lt_item01) = item[].
    DELETE lt_item01 WHERE printallow IS INITIAL.
    SORT lt_item01 ASCENDING BY printseq.

    SELECT a~billingdocument,a~billingdocumentitem,a~ReferenceSDDocument,a~referencesddocumentitem,
           b~billingquantityunit,b~billingquantity,b~conditionratevalue,
           b~transactioncurrency,b~consumptiontaxctrlcodetext1,b~amount,b~materialbycustomer,
           b~consumptiontaxctrlcode,b~purchaseorderbycustomer,b~customerpurchaseorderdate, b~material,
           b~billingdocumentitemtext,b~billingdocumentdate,b~underlyingpurchaseorderitem,
           b~purchaseorderbyshiptoparty

    FROM i_billingdocumentitem AS a
    LEFT OUTER JOIN zvfinalcomdata AS b ON b~billingdocument = a~billingdocument
                                        AND b~billingdocumentitem = a~billingdocumentitem

     WHERE a~billingdocument = @ls_header-commid
     INTO TABLE @DATA(lt_billitem).

    DATA(lt_billitem1) = lt_billitem[].
    LOOP AT lt_billitem ASSIGNING FIELD-SYMBOL(<fs_item>).
      LOOP AT lt_billitem1 INTO DATA(ls_billitem1) WHERE billingdocument = ls_header-commid.
        total_price = total_price + ls_billitem1-amount.
      ENDLOOP.
      IF <fs_item> IS ASSIGNED.
        ls_item-billingdocument = ls_header-commid.
        ls_item-billingdocumentitem = <fs_item>-billingdocumentitem.

        LOOP AT lt_item01 ASSIGNING FIELD-SYMBOL(<fs_print>).
          IF <fs_print> IS ASSIGNED.
            lv_no_col = sy-tabix.
            IF sy-tabix = 1.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col1 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col1 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col1 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col1 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col1 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                       FROM zi_matfld
                       WHERE product = @<fs_item>-material
                       INTO @ls_item-col1      .
*              ls_item-col1   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026

              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col1 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col1 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col1 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col1 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col1 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col1 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col1 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col1 = <fs_item>-underlyingpurchaseorderitem.

                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col1 = unit_wt.
                SHIFT ls_item-col1 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col1 = total_wt.
                SHIFT ls_item-col1 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col1 = steel_unit_wt.
                SHIFT ls_item-col1 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col1 = non_steel_unit_wt.
                SHIFT ls_item-col1 LEFT DELETING LEADING space.
                ELSEIF <fs_print>-field = 'UNIT PRICE'.
              select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col1 = unit_price.
*                ls_item-col1 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col1 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.

                IF unit_wt IS NOT INITIAL.
                   select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                   " * '1.02'.

                  ls_item-col1 = steel_unit_price.
                  SHIFT ls_item-col1 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
          select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col1 = non_steel_unit_price.
                SHIFT ls_item-col1 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col1 = steel_total_price.
                SHIFT ls_item-col1 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col1 = non_steel_total_price.
                SHIFT ls_item-col1 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.

                ls_item-col1 = total_price.
                SHIFT ls_item-col1 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col1 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col1 = <fs_item>-billingquantityunit.

              ENDIF.
            ELSEIF  sy-tabix = 2.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col2 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col2 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col2 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col2 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col2 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @ls_item-col2     .
*              ls_item-col2   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col2 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col2 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col2 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col2 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col2 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col2 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col2 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col2 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col2 = unit_wt.
                SHIFT ls_item-col2 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col2 = total_wt.
                SHIFT ls_item-col2 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col2 = steel_unit_wt.
                SHIFT ls_item-col2 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col2 = non_steel_unit_wt.
                SHIFT ls_item-col2 LEFT DELETING LEADING space.
                       ELSEIF <fs_print>-field = 'UNIT PRICE'.
                   select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col2 = unit_price.
*                ls_item-col2 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col2 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                   " * '1.02'.

                  ls_item-col2 = steel_unit_price.
                  SHIFT ls_item-col2 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.

     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col2 = non_steel_unit_price.
                SHIFT ls_item-col2 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col2 = steel_total_price.
                SHIFT ls_item-col2 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col2 = non_steel_total_price.
                SHIFT ls_item-col2 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col2 = total_price.
                SHIFT ls_item-col2 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col2 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col2 = <fs_item>-billingquantityunit.

              ENDIF.
              """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Endded by Infocus on 26th Dec 2025

            ELSEIF  sy-tabix = 3.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col3 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col3 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col3 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col3 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col3 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @ls_item-col3      .
*              ls_item-col3   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026

              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col3 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col3 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col3 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col3 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col3 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col3 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col3 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col3 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col3 = unit_wt.
                SHIFT ls_item-col3 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col3 = total_wt.
                SHIFT ls_item-col3 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col3 = steel_unit_wt.
                SHIFT ls_item-col3 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col3 = non_steel_unit_wt.
                SHIFT ls_item-col3 LEFT DELETING LEADING space.
         ELSEIF <fs_print>-field = 'UNIT PRICE'.
                select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col3 = unit_price.
*                ls_item-col3 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col3 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
                   select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                    "* '1.02'.

                  ls_item-col3 = steel_unit_price.
                  SHIFT ls_item-col3 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
              select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col3 = non_steel_unit_price.
                SHIFT ls_item-col3 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col3 = steel_total_price.
                SHIFT ls_item-col3 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col3 = non_steel_total_price.
                SHIFT ls_item-col3 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col3 = total_price.
                SHIFT ls_item-col3 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col3 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col3 = <fs_item>-billingquantityunit.

              ENDIF.
              """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Endded by Infocus on 26th Dec 2025
            ELSEIF  sy-tabix = 4.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col4 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col4 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col4 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col4 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col4 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                    FROM zi_matfld
                    WHERE product = @<fs_item>-material
                    INTO @ls_item-col4      .
*              ls_item-col4   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
                ls_item-col4 = <fs_item>-billingdocumentitemtext.
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col4 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col4 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col4 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col4 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col4 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col4 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col4 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col4 = <fs_item>-underlyingpurchaseorderitem.

                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col4 = unit_wt.
                SHIFT ls_item-col4 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col4 = total_wt.
                SHIFT ls_item-col4 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col4 = steel_unit_wt.
                SHIFT ls_item-col4 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col4 = non_steel_unit_wt.
                SHIFT ls_item-col4 LEFT DELETING LEADING space.
 ELSEIF <fs_print>-field = 'UNIT PRICE'.
                 select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col4 = unit_price.
*                ls_item-col4 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col4 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                   " * '1.02'.

                  ls_item-col4 = steel_unit_price.
                  SHIFT ls_item-col4 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col4 = non_steel_unit_price.
                SHIFT ls_item-col4 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col4 = steel_total_price.
                SHIFT ls_item-col4 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col4 = non_steel_total_price.
                SHIFT ls_item-col4 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col4 = total_price.
                SHIFT ls_item-col4 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col4 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col4 = <fs_item>-billingquantityunit.

              ENDIF.

              """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Endded by Infocus on 26th Dec 2025
            ELSEIF  sy-tabix = 5.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col5 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col5 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col5 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col5 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col5 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @ls_item-col5      .
*              ls_item-col5   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
                ls_item-col5 = <fs_item>-billingdocumentitemtext.
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col5 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col5 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col5 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col5 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col5 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col5 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col5 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col5 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col5 = unit_wt.
                SHIFT ls_item-col5 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col5 = total_wt.
                SHIFT ls_item-col5 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col5 = steel_unit_wt.
                SHIFT ls_item-col5 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col5 = non_steel_unit_wt.
                SHIFT ls_item-col5 LEFT DELETING LEADING space.
       ELSEIF <fs_print>-field = 'UNIT PRICE'.
         select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col5 = unit_price.
*                ls_item-col5 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col5 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
       select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                   " * '1.02'.

                  ls_item-col5 = steel_unit_price.
                  SHIFT ls_item-col5 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
       select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col5 = non_steel_unit_price.
                SHIFT ls_item-col5 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col5 = steel_total_price.
                SHIFT ls_item-col5 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col5 = non_steel_total_price.
                SHIFT ls_item-col5 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col5 = total_price.
                SHIFT ls_item-col5 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col5 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col5 = <fs_item>-billingquantityunit.

              ENDIF.

              """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Endded by Infocus on 26th Dec 2025
            ELSEIF  sy-tabix = 6.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col6 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col6 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col6 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col6 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col6 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @ls_item-col6      .
*              ls_item-col6   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026

              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col6 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col6 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col6 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col6 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col6 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col6 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col6 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col6 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col6 = unit_wt.
                SHIFT ls_item-col6 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col6 = total_wt.
                SHIFT ls_item-col6 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col6 = steel_unit_wt.
                SHIFT ls_item-col6 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col6 = non_steel_unit_wt.
                SHIFT ls_item-col6 LEFT DELETING LEADING space.
  ELSEIF <fs_print>-field = 'UNIT PRICE'.
             select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col6 = unit_price.
*                ls_item-col6 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col6 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                    "* '1.02'.

                  ls_item-col6 = steel_unit_price.
                  SHIFT ls_item-col6 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
      select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col6 = non_steel_unit_price.
                SHIFT ls_item-col6 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col6 = steel_total_price.
                SHIFT ls_item-col6 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col6 = non_steel_total_price.
                SHIFT ls_item-col6 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.

                ls_item-col6 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col6 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col6 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col6 = <fs_item>-billingquantityunit.

              ENDIF.

              """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Endded by Infocus on 26th Dec 2025
            ELSEIF  sy-tabix = 7.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col7 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col7 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col7 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col7 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col7 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @ls_item-col7      .
*              ls_item-col7   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026

              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col7 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col7 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col7 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col7 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col7 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col7 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col7 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col7 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col7 = unit_wt.
                SHIFT ls_item-col7 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col7 = total_wt.
                SHIFT ls_item-col7 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col7 = steel_unit_wt.
                SHIFT ls_item-col7 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col7 = non_steel_unit_wt.
                SHIFT ls_item-col7 LEFT DELETING LEADING space.
     ELSEIF <fs_print>-field = 'UNIT PRICE'.
                  select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col7 = unit_price.
*                ls_item-col7 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col7 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                   " * '1.02'.

                  ls_item-col7 = steel_unit_price.
                  SHIFT ls_item-col7 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
       select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col7 = non_steel_unit_price.
                SHIFT ls_item-col7 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col7 = steel_total_price.
                SHIFT ls_item-col7 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col7 = non_steel_total_price.
                SHIFT ls_item-col7 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col7 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col7 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col7 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col7 = <fs_item>-billingquantityunit.

              ENDIF.

              """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Endded by Infocus on 26th Dec 2025
            ELSEIF  sy-tabix = 8.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col8 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col8 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col8 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col8 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col8 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                 FROM zi_matfld
                 WHERE product = @<fs_item>-material
                 INTO @ls_item-col8      .
*              ls_item-col8   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col8 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col8 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col8 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col8 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col8 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col8 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col8 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col8 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col8 = unit_wt.
                SHIFT ls_item-col8 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col8 = total_wt.
                SHIFT ls_item-col8 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col8 = steel_unit_wt.
                SHIFT ls_item-col8 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col8 = non_steel_unit_wt.
                SHIFT ls_item-col8 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'UNIT PRICE'.
                   select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col8 = unit_price.
*                ls_item-col8 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col8 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
      select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                   " * '1.02'.

                  ls_item-col8 = steel_unit_price.
                  SHIFT ls_item-col8 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col8 = non_steel_unit_price.
                SHIFT ls_item-col8 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col8 = steel_total_price.
                SHIFT ls_item-col8 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col8 = non_steel_total_price.
                SHIFT ls_item-col8 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col8 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col8 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col8 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col8 = <fs_item>-billingquantityunit.

              ENDIF.

              """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Endded by Infocus on 26th Dec 2025
            ELSEIF  sy-tabix = 9.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col9 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col9 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col9 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col9 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col9 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                    FROM zi_matfld
                    WHERE product = @<fs_item>-material
                    INTO @ls_item-col9      .
*              ls_item-col9   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col9 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col9 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col9 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col9 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col9 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col9 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col9 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col9 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col9 = unit_wt.
                SHIFT ls_item-col9 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col9 = total_wt.
                SHIFT ls_item-col9 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col9 = steel_unit_wt.
                SHIFT ls_item-col9 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col9 = non_steel_unit_wt.
                SHIFT ls_item-col9 LEFT DELETING LEADING space.
     ELSEIF <fs_print>-field = 'UNIT PRICE'.
               select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col9 = unit_price.
*                ls_item-col9 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col9 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                    "* '1.02'.

                  ls_item-col9 = steel_unit_price.
                  SHIFT ls_item-col9 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col9 = non_steel_unit_price.
                SHIFT ls_item-col9 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col9 = steel_total_price.
                SHIFT ls_item-col9 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col9 = non_steel_total_price.
                SHIFT ls_item-col9 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col9 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col9 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col9 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col9 = <fs_item>-billingquantityunit.

              ENDIF.

              """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Endded by Infocus on 26th Dec 2025
            ELSEIF  sy-tabix = 10.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col10 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col10 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col10 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col10 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col10 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @ls_item-col10      .
*              ls_item-col10   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026

              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col10 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col10 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col10 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col10 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col10 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col10 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col10 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col10 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col10 = unit_wt.
                SHIFT ls_item-col10 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col10 = total_wt.
                SHIFT ls_item-col10 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col10 = steel_unit_wt.
                SHIFT ls_item-col10 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col10 = non_steel_unit_wt.
                SHIFT ls_item-col10 LEFT DELETING LEADING space.
    ELSEIF <fs_print>-field = 'UNIT_PRICE'.
                  select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col10 = unit_price.
*                ls_item-col10 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col10 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                   " * '1.02'.

                  ls_item-col10 = steel_unit_price.
                  SHIFT ls_item-col10 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col10 = non_steel_unit_price.
                SHIFT ls_item-col10 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col10 = steel_total_price.
                SHIFT ls_item-col10 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col10 = non_steel_total_price.
                SHIFT ls_item-col10 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col10 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col10 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col10 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col10 = <fs_item>-billingquantityunit.

              ENDIF.

              """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Endded by Infocus on 26th Dec 2025
            ELSEIF  sy-tabix = 11.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col11 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col11 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col11 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col11 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col11 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                        FROM zi_matfld
                        WHERE product = @<fs_item>-material
                        INTO @ls_item-col11      .
*              ls_item-col11   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col11 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col11 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col11 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col11 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col11 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col11 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col11 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col11 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col11 = unit_wt.
                SHIFT ls_item-col11 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col11 = total_wt.
                SHIFT ls_item-col11 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col11 = steel_unit_wt.
                SHIFT ls_item-col11 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col11 = non_steel_unit_wt.
                SHIFT ls_item-col11 LEFT DELETING LEADING space.
     ELSEIF <fs_print>-field = 'UNIT PRICE'.
                  select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col11 = unit_price.
*                ls_item-col11 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col11 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
         select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                  "  * '1.02'.

                  ls_item-col11 = steel_unit_price.
                  SHIFT ls_item-col11 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                 unit_price - steel_unit_price.

                ls_item-col11 = non_steel_unit_price.
                SHIFT ls_item-col11 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col11 = steel_total_price.
                SHIFT ls_item-col11 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col11 = non_steel_total_price.
                SHIFT ls_item-col11 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col11 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col11 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col11 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col11 = <fs_item>-billingquantityunit.

              ENDIF.

              """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Endded by Infocus on 26th Dec 2025

            ELSEIF  sy-tabix = 12.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col12 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col12 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col12 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col12 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col12 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                      FROM zi_matfld
                      WHERE product = @<fs_item>-material
                      INTO @ls_item-col12      .
*              ls_item-col12   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col12 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col12 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col12 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col12 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col12 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col12 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col12 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col12 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col12 = unit_wt.
                SHIFT ls_item-col12 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col12 = total_wt.
                SHIFT ls_item-col12 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col12 = steel_unit_wt.
                SHIFT ls_item-col12 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col12 = non_steel_unit_wt.
                SHIFT ls_item-col12 LEFT DELETING LEADING space.
    ELSEIF <fs_print>-field = 'UNIT PRICE'.
                 select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col12 = unit_price.
*                ls_item-col12 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col12 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                   " * '1.02'.

                  ls_item-col12 = steel_unit_price.
                  SHIFT ls_item-col12 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col12 = non_steel_unit_price.
                SHIFT ls_item-col12 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col12 = steel_total_price.
                SHIFT ls_item-col12 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col12 = non_steel_total_price.
                SHIFT ls_item-col12 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col12 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col12 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col12 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col12 = <fs_item>-billingquantityunit.

              ENDIF.

              """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Endded by Infocus on 26th Dec 2025
            ELSEIF  sy-tabix = 13.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col13 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col13 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col13 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col13 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col13 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @ls_item-col13      .
*              ls_item-col13  = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col13 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col13 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col13 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col13 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col13 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col13 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col13 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col13 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col13 = unit_wt.
                SHIFT ls_item-col13 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col13 = total_wt.
                SHIFT ls_item-col13 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col13 = steel_unit_wt.
                SHIFT ls_item-col13 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col13 = non_steel_unit_wt.
                SHIFT ls_item-col13 LEFT DELETING LEADING space.
          ELSEIF <fs_print>-field = 'UNIT PRICE'.
                   select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col13 = unit_price.
*                ls_item-col13 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col13 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
          select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                   " * '1.02'.

                  ls_item-col13 = steel_unit_price.
                  SHIFT ls_item-col13 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col13 = non_steel_unit_price.
                SHIFT ls_item-col13 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col13 = steel_total_price.
                SHIFT ls_item-col13 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col13 = non_steel_total_price.
                SHIFT ls_item-col13 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col13 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col13 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col13 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col13 = <fs_item>-billingquantityunit.

              ENDIF.

              """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Endded by Infocus on 26th Dec 2025
            ELSEIF  sy-tabix = 14.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col14 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col14 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col14 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col14 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col14 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                FROM zi_matfld
                WHERE product = @<fs_item>-material
                INTO @ls_item-col14      .
*              ls_item-col14   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col14 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col14 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col14 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col14 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col14 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col14 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col14 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col14 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col14 = unit_wt.
                SHIFT ls_item-col14 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col14 = total_wt.
                SHIFT ls_item-col14 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col14 = steel_unit_wt.
                SHIFT ls_item-col14 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col14 = non_steel_unit_wt.
                SHIFT ls_item-col14 LEFT DELETING LEADING space.
    ELSEIF <fs_print>-field = 'UNIT PRICE'.
                select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col14 = unit_price.
*                ls_item-col14 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col14 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
      select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                 "   * '1.02'.

                  ls_item-col14 = steel_unit_price.
                  SHIFT ls_item-col14 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                 unit_price - steel_unit_price.

                ls_item-col14 = non_steel_unit_price.
                SHIFT ls_item-col14 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col14 = steel_total_price.
                SHIFT ls_item-col14 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col14 = non_steel_total_price.
                SHIFT ls_item-col14 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col14 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col14 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col14 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col14 = <fs_item>-billingquantityunit.

              ENDIF.
            ELSEIF sy-tabix = 15.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col15 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col15 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col15 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col15 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col15 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                 FROM zi_matfld
                 WHERE product = @<fs_item>-material
                 INTO @ls_item-col15      .
*              ls_item-col15   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col15 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col15 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col15 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col15 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col15 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col15 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col15 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col15 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col15 = unit_wt.
                SHIFT ls_item-col15 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col15 = total_wt.
                SHIFT ls_item-col15 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col15 = steel_unit_wt.
                SHIFT ls_item-col15 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col15 = non_steel_unit_wt.
                SHIFT ls_item-col15 LEFT DELETING LEADING space.
        ELSEIF <fs_print>-field = 'UNIT PRICE'.
             select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col15 = unit_price.
*                ls_item-col15 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col15 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                    "* '1.02'.

                  ls_item-col15 = steel_unit_price.
                  SHIFT ls_item-col15 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col15 = non_steel_unit_price.
                SHIFT ls_item-col15 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col15 = steel_total_price.
                SHIFT ls_item-col15 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col15 = non_steel_total_price.
                SHIFT ls_item-col15 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col15 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col15 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col15 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col15 = <fs_item>-billingquantityunit.

              ENDIF.
            ELSEIF sy-tabix = 16.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col16 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col16 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col16 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col16 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col16 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @ls_item-col16      .
*              ls_item-col16   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col16 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col16 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col16 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col16 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col16 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col16 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col16 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col16 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col16 = unit_wt.
                SHIFT ls_item-col16 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col16 = total_wt.
                SHIFT ls_item-col16 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col16 = steel_unit_wt.
                SHIFT ls_item-col16 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col16 = non_steel_unit_wt.
                SHIFT ls_item-col16 LEFT DELETING LEADING space.
   ELSEIF <fs_print>-field = 'UNIT PRICE'.
                  select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col16 = unit_price.
*                ls_item-col16 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col16 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                   " * '1.02'.

                  ls_item-col16 = steel_unit_price.
                  SHIFT ls_item-col16 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col16 = non_steel_unit_price.
                SHIFT ls_item-col16 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col16 = steel_total_price.
                SHIFT ls_item-col16 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col16 = non_steel_total_price.
                SHIFT ls_item-col16 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col16 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col16 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col16 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col16 = <fs_item>-billingquantityunit.

              ENDIF.
            ELSEIF sy-tabix = 17.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col17 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col17 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col17 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col17 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col17 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                    FROM zi_matfld
                    WHERE product = @<fs_item>-material
                    INTO @ls_item-col17      .
*              ls_item-col17   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col17 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col17 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col17 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col17 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col17 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col17 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col17 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col17 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col17 = unit_wt.
                SHIFT ls_item-col17 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col17 = total_wt.
                SHIFT ls_item-col17 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col17 = steel_unit_wt.
                SHIFT ls_item-col17 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col17 = non_steel_unit_wt.
                SHIFT ls_item-col17 LEFT DELETING LEADING space.
        ELSEIF <fs_print>-field = 'UNIT PRICE'.
              select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col17 = unit_price.
*                ls_item-col17 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col17 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
      select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                   " * '1.02'.

                  ls_item-col17 = steel_unit_price.
                  SHIFT ls_item-col17 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
       select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col17 = non_steel_unit_price.
                SHIFT ls_item-col17 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col17 = steel_total_price.
                SHIFT ls_item-col17 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col17 = non_steel_total_price.
                SHIFT ls_item-col17 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col17 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col17 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col17 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col17 = <fs_item>-billingquantityunit.

              ENDIF.
            ELSEIF sy-tabix = 18.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col18 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col18 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col18 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col18 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col18 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @ls_item-col18      .
*              ls_item-col18   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col18 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col18 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col18 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col18 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col18 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col18 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col18 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col18 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col18 = unit_wt.
                SHIFT ls_item-col18 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col18 = total_wt.
                SHIFT ls_item-col18 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col18 = steel_unit_wt.
                SHIFT ls_item-col18 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col18 = non_steel_unit_wt.
                SHIFT ls_item-col18 LEFT DELETING LEADING space.
          ELSEIF <fs_print>-field = 'UNIT PRICE'.
                   select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col18 = unit_price.
*                ls_item-col18 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col18 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                   " * '1.02'.

                  ls_item-col18 = steel_unit_price.
                  SHIFT ls_item-col18 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
      select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col18 = non_steel_unit_price.
                SHIFT ls_item-col18 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col18 = steel_total_price.
                SHIFT ls_item-col18 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col18 = non_steel_total_price.
                SHIFT ls_item-col18 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col18 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col18 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col18 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col18 = <fs_item>-billingquantityunit.

              ENDIF.
            ELSEIF sy-tabix = 19.
              IF <fs_print>-field = 'UNIT'.
                ls_item-col19 = <fs_item>-billingquantityunit.
              ELSEIF <fs_print>-field = 'RATE'.
                ls_item-col19 = <fs_item>-transactioncurrency && | | && <fs_item>-conditionratevalue.
              ELSEIF <fs_print>-field = 'QTY'.
                ls_item-col19 = <fs_item>-billingquantity.
              ELSEIF <fs_print>-field = 'ORDERNO'.
                ls_item-col19 = <fs_item>-purchaseorderbycustomer.
              ELSEIF <fs_print>-field = 'ORDERDT'.
                ls_item-col19 = <fs_item>-customerpurchaseorderdate.
              ELSEIF <fs_print>-field = 'MATERIAL'.
                SELECT SINGLE matlngtxt                       "Added by Infocus on 10th Feb 2026
                FROM zi_matfld
                WHERE product = @<fs_item>-material
                INTO @ls_item-col19      .
*              ls_item-col19   = <fs_item>-billingdocumentitemtext. "Commented by Infocus on 10th Feb 2026
              ELSEIF <fs_print>-field = 'ITEMNAME'.
                ls_item-col19 = <fs_item>-consumptiontaxctrlcodetext1.
              ELSEIF <fs_print>-field = 'ITEMCODE'.
                ls_item-col19 = <fs_item>-material.
              ELSEIF <fs_print>-field = 'INDEXNO'.
                ls_item-col19 = <fs_item>-purchaseorderbyshiptoparty.
              ELSEIF <fs_print>-field = 'HSNCODE'.
                ls_item-col19 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'FOREIGN NAME'.
                ls_item-col19 = <fs_item>-materialbycustomer.
              ELSEIF <fs_print>-field = 'CUSTHSNCODE'.
                ls_item-col19 = <fs_item>-consumptiontaxctrlcode.
              ELSEIF <fs_print>-field = 'AMOUNT'.
                ls_item-col19 = <fs_item>-transactioncurrency && | | && <fs_item>-amount.
              ELSEIF <fs_print>-field = 'LINENO'.
                ls_item-col19 = <fs_item>-underlyingpurchaseorderitem.
                """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""Added by Infocus on 26th Dec 2025
              ELSEIF <fs_print>-field = 'UNIT_WT'.

                SELECT SINGLE netweight
                  FROM i_product
                  WHERE product = @<fs_item>-material
                  INTO @unit_wt.

                ls_item-col19 = unit_wt.
                SHIFT ls_item-col19 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_WT'.

                total_wt = unit_wt * <fs_item>-billingquantity.
                ls_item-col19 = total_wt.
                SHIFT ls_item-col19 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_UNIT_WT'.

                SELECT SINGLE steel_unit_wt
                  FROM zi_matfld
                  WHERE product = @<fs_item>-material
                  INTO @steel_unit_wt.

                ls_item-col19 = steel_unit_wt.
                SHIFT ls_item-col19 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_WT'.

                non_steel_unit_wt = unit_wt - steel_unit_wt.
                ls_item-col19 = non_steel_unit_wt.
                SHIFT ls_item-col19 LEFT DELETING LEADING space.
        ELSEIF <fs_print>-field = 'UNIT PRICE'.
              select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
              ls_item-col19 = unit_price.
*                ls_item-col19 = <fs_item>-conditionratevalue.
                SHIFT ls_item-col19 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                IF unit_wt IS NOT INITIAL.
                  steel_unit_price =
                    ( unit_price / unit_wt )
                    * steel_unit_wt.
                   " * '1.02'.

                  ls_item-col19 = steel_unit_price.
                  SHIFT ls_item-col19 LEFT DELETING LEADING space.
                ENDIF.

              ELSEIF <fs_print>-field = 'NON_STEEL_UNIT_PRICE'.
     select single Unitfob from zdt_finlpack_itm where delivery =   @<fs_item>-ReferenceSDDocument and posnr = @<fs_item>-ReferenceSDDocumentitem
              into @unit_price.
                non_steel_unit_price =
                  unit_price - steel_unit_price.

                ls_item-col19 = non_steel_unit_price.
                SHIFT ls_item-col19 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'STEEL_TOTAL_PRICE'.

                steel_total_price =
                  steel_unit_price * <fs_item>-billingquantity.

                ls_item-col19 = steel_total_price.
                SHIFT ls_item-col19 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'NON_STEEL_TOTAL_PRICE'.

                non_steel_total_price =
                  non_steel_unit_price * <fs_item>-billingquantity.

                ls_item-col19 = non_steel_total_price.
                SHIFT ls_item-col19 LEFT DELETING LEADING space.

              ELSEIF <fs_print>-field = 'TOTAL_PRICE'.
                ls_item-col19 = steel_total_price + non_steel_total_price.
                SHIFT ls_item-col19 LEFT DELETING LEADING space.
              ELSEIF <fs_print>-field = 'CURRENCY'.
                ls_item-col19 =   <fs_item>-transactioncurrency.
              ELSEIF <fs_print>-field = 'UOM'.
                ls_item-col19 = <fs_item>-billingquantityunit.

              ENDIF.
              """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" Endded by Infocus on 26th Dec 2025
            ENDIF.
          ENDIF.
        ENDLOOP.
        APPEND ls_item TO lt_item.
        DELETE zdt_item_data FROM @ls_item.
        CLEAR : ls_item.
      ENDIF.
    ENDLOOP.


    MODIFY zdt_item_data FROM TABLE @lt_item.

    DELETE FROM zdt_item_data
      WHERE billingdocument     = @ls_header-commid
        AND billingdocumentitem = '000000'.


    LOOP AT header INTO DATA(ls_hd).
      IF ls_hd IS NOT INITIAL.

        ls_hd-csprint = 'X'.
        ls_hd-flag   = 'S'.

        MODIFY ENTITIES OF zi_comm_hed IN LOCAL MODE
                ENTITY zi_comm_hed
                UPDATE
                FIELDS ( csprint flag )
                WITH VALUE #( ( %tky          = ls_hd-%tky
                                 csprint =  ls_hd-csprint
                                 flag   =  ls_hd-flag
                                 %control-flag   = if_abap_behv=>mk-on
                                  %control-csprint   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
         ENTITY  zi_comm_hed
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_head IN header_1
                      ( %tky   = ls_head-%tky
                        %param = ls_head ) ).

  ENDMETHOD.

  METHOD finalinvoicefob.

    DATA : lt_item TYPE TABLE OF zdt_item_data.
    DATA : ls_item TYPE zdt_item_data.
    data : ls_fob_unit type p DECIMALS 2.
    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
              ENTITY zi_comm_hed
              ALL FIELDS
              WITH CORRESPONDING #( keys )
              RESULT DATA(header)
              " TODO: variable is assigned but never used (ABAP cleaner)
              FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

        <fs_print>-fobprint = 'X'.
        <fs_print>-flag   = 'F'.

        MODIFY ENTITIES OF zi_comm_hed IN LOCAL MODE
                ENTITY zi_comm_hed
                UPDATE
                FIELDS ( fobprint flag )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 fobprint =  <fs_print>-fobprint
                                 flag   =  <fs_print>-flag
                                 %control-flag   = if_abap_behv=>mk-on
                                  %control-fobprint   = if_abap_behv=>mk-on
                                ) ).

       update zdt_comm_hed
       set flag = 'F'
       where id = @<fs_print>-Id
       and commid = @<fs_print>-Commid.

      ENDIF.
    ENDLOOP.

    SELECT * FROM zdt_item_data  WHERE  billingdocument = @<fs_print>-commid AND billingdocumentitem = '000000' INTO TABLE @DATA(lt_item_fob).
    SELECT a~billingdocument,a~billingdocumentitem,a~ReferenceSDDocument,a~referencesddocumentitem,
          b~billingquantityunit,b~billingquantity,b~conditionratevalue,
          b~transactioncurrency,b~consumptiontaxctrlcodetext1,b~amount,b~materialbycustomer,
          b~consumptiontaxctrlcode,b~purchaseorderbycustomer,b~customerpurchaseorderdate, b~material,
          b~billingdocumentitemtext,b~billingdocumentdate,b~underlyingpurchaseorderitem,
          b~purchaseorderbyshiptoparty

   FROM i_billingdocumentitem AS a
   LEFT OUTER JOIN zvfinalcomdata AS b ON b~billingdocument = a~billingdocument
                                       AND b~billingdocumentitem = a~billingdocumentitem

    WHERE a~billingdocument = @<fs_print>-commid
    INTO TABLE @DATA(lt_billitem).


    LOOP AT lt_billitem ASSIGNING FIELD-SYMBOL(<ls_billitem>).
    loop at lt_item_fob ASSIGNING FIELD-SYMBOL(<ls_item_fob>) where billingdocument = <ls_billitem>-billingdocument.

      IF <ls_item_fob>-col1 = 'RATE'.

        SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col1 = ls_fob_unit.
        CONDENSE ls_item-col1.
        UPDATE zdt_item_data
        SET col1 = @ls_item-col1
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.

      ELSEIF <ls_item_fob>-col1 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col1 = <ls_billitem>-billingquantity * ls_fob_unit.
  CONDENSE ls_item-col1.
        UPDATE zdt_item_data
        SET col1 = @ls_item-col1
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

      if <ls_item_fob>-col1 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col1      .
                      UPDATE zdt_item_data
        SET col1 = @ls_item-col1
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col1 = 'MATERIAL'.

      <LS_ITEM_FOB>-col1 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col1 = @ls_item-col1
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.


      IF <ls_item_fob>-col2 = 'RATE'.
         SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col2 = ls_fob_unit.
        CONDENSE ls_item-col2.

        UPDATE zdt_item_data
        SET col2 = @ls_item-col2
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.

      ELSEIF <ls_item_fob>-col2 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col2 = <ls_billitem>-billingquantity * ls_fob_unit.
  CONDENSE ls_item-col2.
        UPDATE zdt_item_data
        SET col2 = @ls_item-col2
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

            if <ls_item_fob>-col2 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col2      .
                      UPDATE zdt_item_data
        SET col2 = @ls_item-col2
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col2 = 'MATERIAL'.

      <LS_ITEM_FOB>-col2 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col2 = @ls_item-col2
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

      IF <ls_item_fob>-col3 = 'RATE'.
            SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col3 = ls_fob_unit.

        CONDENSE ls_item-col3.

               UPDATE zdt_item_data
        SET col3 = @ls_item-col3
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col3 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col3 = <ls_billitem>-billingquantity * ls_fob_unit.
 CONDENSE ls_item-col3.
        UPDATE zdt_item_data
        SET col3 = @ls_item-col3
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

                  if <ls_item_fob>-col3 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col3      .
                      UPDATE zdt_item_data
        SET col3 = @ls_item-col3
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col3 = 'MATERIAL'.

      <LS_ITEM_FOB>-col3 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col3 = @ls_item-col3
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

      IF <ls_item_fob>-col4 = 'RATE'.
               SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col4 = ls_fob_unit.

        CONDENSE ls_item-col4.
        UPDATE zdt_item_data
        SET col4 = @ls_item-col4
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col4 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col4 = <ls_billitem>-billingquantity * ls_fob_unit.
    CONDENSE ls_item-col4.
        UPDATE zdt_item_data
        SET col4 = @ls_item-col4
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

                  if <ls_item_fob>-col4 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col4      .
                      UPDATE zdt_item_data
        SET col4 = @ls_item-col4
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col4 = 'MATERIAL'.

      <LS_ITEM_FOB>-col4 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col4 = @ls_item-col4
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.


      IF <ls_item_fob>-col5 = 'RATE'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col5 = ls_fob_unit.
        CONDENSE ls_item-col5.
                UPDATE zdt_item_data
        SET col5 = @ls_item-col5
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col5 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col5 = <ls_billitem>-billingquantity * ls_fob_unit.
CONDENSE ls_item-col5.
        UPDATE zdt_item_data
        SET col5 = @ls_item-col5
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

                  if <ls_item_fob>-col5 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col5      .
                      UPDATE zdt_item_data
        SET col5 = @ls_item-col5
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col5 = 'MATERIAL'.

      <LS_ITEM_FOB>-col5 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col5 = @ls_item-col5
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

      IF <ls_item_fob>-col6 = 'RATE'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col6 = ls_fob_unit.

        CONDENSE ls_item-col6.

          UPDATE zdt_item_data
        SET col6 = @ls_item-col6
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col6 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col6 = <ls_billitem>-billingquantity * ls_fob_unit.

     CONDENSE ls_item-col6.

        UPDATE zdt_item_data
        SET col6 = @ls_item-col6
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

            if <ls_item_fob>-col6 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col6      .
                      UPDATE zdt_item_data
        SET col6 = @ls_item-col6
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col6 = 'MATERIAL'.

      <LS_ITEM_FOB>-col6 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col6 = @ls_item-col6
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

      IF <ls_item_fob>-col7 = 'RATE'.
         SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col7 = ls_fob_unit.
        CONDENSE ls_item-col7.
                UPDATE zdt_item_data
        SET col7 = @ls_item-col7
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col7 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col7 = <ls_billitem>-billingquantity * ls_fob_unit.
 CONDENSE ls_item-col7.
        UPDATE zdt_item_data
        SET col7 = @ls_item-col7
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

            if <ls_item_fob>-col7 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col7      .
                      UPDATE zdt_item_data
        SET col7 = @ls_item-col7
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col7 = 'MATERIAL'.

      <LS_ITEM_FOB>-col7 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col7 = @ls_item-col7
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.


      IF <ls_item_fob>-col8 = 'RATE'.
        SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col8 = ls_fob_unit.
        CONDENSE ls_item-col8.
                UPDATE zdt_item_data
        SET col8 = @ls_item-col8
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col8 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col8 = <ls_billitem>-billingquantity * ls_fob_unit.
 CONDENSE ls_item-col8.
        UPDATE zdt_item_data
        SET col8 = @ls_item-col8
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

            if <ls_item_fob>-col8 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col8      .
                      UPDATE zdt_item_data
        SET col8 = @ls_item-col8
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col8 = 'MATERIAL'.

      <LS_ITEM_FOB>-col8 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col8 = @ls_item-col8
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

      IF <ls_item_fob>-col9 = 'RATE'.
               SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col9 = ls_fob_unit.
        CONDENSE ls_item-col9.
                UPDATE zdt_item_data
        SET col9 = @ls_item-col9
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col9 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col9 = <ls_billitem>-billingquantity * ls_fob_unit.
 CONDENSE ls_item-col9.
        UPDATE zdt_item_data
        SET col9 = @ls_item-col9
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.


                  if <ls_item_fob>-col9 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col9      .
                      UPDATE zdt_item_data
        SET col9 = @ls_item-col9
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col9 = 'MATERIAL'.

      <LS_ITEM_FOB>-col9 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col9 = @ls_item-col9
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.


      IF <ls_item_fob>-col10 = 'RATE'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col10 = ls_fob_unit.
        CONDENSE ls_item-col10.
                UPDATE zdt_item_data
        SET col10 = @ls_item-col10
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col10 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col10 = <ls_billitem>-billingquantity * ls_fob_unit.
 CONDENSE ls_item-col10.
        UPDATE zdt_item_data
        SET col10 = @ls_item-col10
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.


               if <ls_item_fob>-col10 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col10      .
                      UPDATE zdt_item_data
        SET col10 = @ls_item-col10
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col10 = 'MATERIAL'.

      <LS_ITEM_FOB>-col10 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col10 = @ls_item-col10
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

      IF <ls_item_fob>-col11 = 'RATE'.
             SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col11 = ls_fob_unit.
        CONDENSE ls_item-col11.
                UPDATE zdt_item_data
        SET col11 = @ls_item-col11
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col11 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col11 = <ls_billitem>-billingquantity * ls_fob_unit.
 CONDENSE ls_item-col11.
        UPDATE zdt_item_data
        SET col11 = @ls_item-col11
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.


               if <ls_item_fob>-col11 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col11      .
                      UPDATE zdt_item_data
        SET col11 = @ls_item-col11
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col11 = 'MATERIAL'.

      <LS_ITEM_FOB>-col11 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col11 = @ls_item-col11
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

      IF <ls_item_fob>-col12 = 'RATE'.
               SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col12 = ls_fob_unit.
        CONDENSE ls_item-col12.
                UPDATE zdt_item_data
        SET col12 = @ls_item-col12
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col12 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col12 = <ls_billitem>-billingquantity * ls_fob_unit.
 CONDENSE ls_item-col12.
        UPDATE zdt_item_data
        SET col12 = @ls_item-col12
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.


                  if <ls_item_fob>-col12 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col12      .
                      UPDATE zdt_item_data
        SET col12 = @ls_item-col12
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col12 = 'MATERIAL'.

      <LS_ITEM_FOB>-col12 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col12 = @ls_item-col12
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

      IF <ls_item_fob>-col13 = 'RATE'.
             SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col13 = ls_fob_unit.
        CONDENSE ls_item-col13.
                UPDATE zdt_item_data
        SET col13 = @ls_item-col13
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col13 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col13 = <ls_billitem>-billingquantity * ls_fob_unit.
 CONDENSE ls_item-col13.
        UPDATE zdt_item_data
        SET col13 = @ls_item-col13
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

                  if <ls_item_fob>-col13 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col13      .
                      UPDATE zdt_item_data
        SET col13 = @ls_item-col13
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col13 = 'MATERIAL'.

      <LS_ITEM_FOB>-col13 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col13 = @ls_item-col13
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

      IF <ls_item_fob>-col14 = 'RATE'.
           SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col14 = ls_fob_unit.
        CONDENSE ls_item-col14.
                UPDATE zdt_item_data
        SET col14 = @ls_item-col14
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col14 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col14 = <ls_billitem>-billingquantity * ls_fob_unit.
 CONDENSE ls_item-col14.
        UPDATE zdt_item_data
        SET col14 = @ls_item-col14
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

                  if <ls_item_fob>-col14 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col14      .
                      UPDATE zdt_item_data
        SET col14 = @ls_item-col14
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col14 = 'MATERIAL'.

      <LS_ITEM_FOB>-col14 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col14 = @ls_item-col14
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.


      IF <ls_item_fob>-col15 = 'RATE'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col15 = ls_fob_unit.
        CONDENSE ls_item-col15.
                UPDATE zdt_item_data
        SET col15 = @ls_item-col15
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col15 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col15 = <ls_billitem>-billingquantity * ls_fob_unit.
 CONDENSE ls_item-col15.
        UPDATE zdt_item_data
        SET col15 = @ls_item-col15
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

                  if <ls_item_fob>-col15 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col15      .
                      UPDATE zdt_item_data
        SET col15 = @ls_item-col15
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col15 = 'MATERIAL'.

      <LS_ITEM_FOB>-col15 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col15 = @ls_item-col15
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.


      IF <ls_item_fob>-col16 = 'RATE'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col16 = ls_fob_unit.
        CONDENSE ls_item-col16.
                UPDATE zdt_item_data
        SET col16 = @ls_item-col16
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col16 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col16 = <ls_billitem>-billingquantity * ls_fob_unit.
 CONDENSE ls_item-col16.
        UPDATE zdt_item_data
        SET col16 = @ls_item-col16
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.


                 if <ls_item_fob>-col16 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col16      .
                      UPDATE zdt_item_data
        SET col16 = @ls_item-col16
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col16 = 'MATERIAL'.

      <LS_ITEM_FOB>-col16 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col16 = @ls_item-col16
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

      IF <ls_item_fob>-col17 = 'RATE'.
               SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col17 = ls_fob_unit.
        CONDENSE ls_item-col17.
                UPDATE zdt_item_data
        SET col17 = @ls_item-col17
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ELSEIF <ls_item_fob>-col17 = 'AMOUNT'.
              SELECT SINGLE unitfob FROM zdt_finlpack_itm WHERE comm_inv = @<fs_print>-commid  and delivery = @<ls_billitem>-ReferenceSDDocument
        and posnr = @<ls_billitem>-ReferenceSDDocumentItem   INTO @ls_fob_unit.
        ls_item-col17 = <ls_billitem>-billingquantity * ls_fob_unit.
 CONDENSE ls_item-col17.
        UPDATE zdt_item_data
        SET col17 = @ls_item-col17
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.

                  if <ls_item_fob>-col17 = 'ITEM NAME'.
                    SELECT SINGLE matlngtxt
                   FROM zi_matfld
                   WHERE product = @<ls_billitem>-Material
                   INTO @ls_item-col17      .
                      UPDATE zdt_item_data
        SET col17 = @ls_item-col17
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
     elseif <ls_item_fob>-col17 = 'MATERIAL'.

      <LS_ITEM_FOB>-col17 =   <ls_billitem>-consumptiontaxctrlcodetext1.
         UPDATE zdt_item_data
        SET col17 = @ls_item-col17
        WHERE billingdocument = @<ls_billitem>-billingdocument
        AND billingdocumentitem = @<ls_billitem>-billingdocumentitem.
      ENDIF.
      endloop.

    ENDLOOP.


    " Fill the response table
    READ ENTITIES OF zi_comm_hed IN LOCAL MODE
         ENTITY  zi_comm_hed
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).


  ENDMETHOD.

ENDCLASS.
*======================================================================*
*  Print Section
*======================================================================*
CLASS lsc_zi_comm_hed DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_comm_hed IMPLEMENTATION.

  METHOD save_modified.

    IF update-zi_comm_hed IS NOT INITIAL.

      DATA: lv_printq TYPE char32.

      SELECT SINGLE * FROM zdt_print_queue WHERE cbuser = @sy-uname INTO @DATA(ls_printq).
      IF sy-subrc = 0.
        lv_printq = ls_printq-printque.
      ELSE.
        lv_printq = 'ZDEFAULT'.
      ENDIF.

      DATA(lt_head) = update-zi_comm_hed.
      READ TABLE lt_head INDEX 1 INTO DATA(wa_head).

      IF wa_head-flag = 'A'.

        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSD_COMM_PRINT'
                                                                  iv_root_node = 'ZVCOMMERCIALPRNT' ) ." 'ZSERV_D_PRINT' ).

            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'SHIPPING' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
                "" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
                "" multiple times and hence user was unable to generate print
**                IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
**                  lo_store->set_schema(
**                    iv_form_name = 'SHIPPING'
**                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
**                  ).
**                ELSE.
**                ENDIF.
                "" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys)     = lo_fdp_util->get_keys( ).
*        lt_keys[ name = 'ID' ]-value = lt_head[ 1 ]-id.
            lt_keys[ name = 'BILLINGDOCUMENT' ]-value = lt_head[ 1 ]-commid.
*          DATA(lv_sh) = VALUE #( lt_head[ 1 ]-Id OPTIONAL ).
            TRY.
                DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception).
            ENDTRY.
            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'SHIPPING'
              iv_template_name = 'SHIPPING'
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
                iv_pq_name      = lv_printq "'SHIP_NOTIFICATION'
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
            lv_text = |SHIPPING NOTIFICATION PRINT | && lt_head[ 1 ]-commid.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq "'SHIP_NOTIFICATION'
              iv_print_data       = lv_pdf
              iv_name_of_main_doc = lv_text
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        ENDTRY.
      ENDIF.

      IF wa_head-flag = 'B'.


        TRY.
            "Initialize Template Store Client
            DATA(lo_store1) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util1) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSERV_D_FINALCOMM' ) ." 'ZSERV_D_PRINT' ).


            TRY.
                lo_store1->get_schema_by_name( iv_form_name = 'FINALCOMM' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error1).
                "" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
                "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error1->mv_http_status_code = 404 OR lo_tmpl_error1->mv_http_status_code = 403 .
*                  lo_store1->set_schema(
*                    iv_form_name = 'FINALCOMM'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util1->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
                "" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys1)     = lo_fdp_util1->get_keys( ).
*        lt_keys[ name = 'ID' ]-value = lt_head[ 1 ]-id.
            lt_keys1[ name = 'BILLINGDOCUMENT' ]-value = lt_head[ 1 ]-commid.
*          DATA(lv_sh) = VALUE #( lt_head[ 1 ]-Id OPTIONAL ).
            TRY.
                DATA(lv_xml1) = lo_fdp_util1->read_to_xml( lt_keys1 ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception1).
            ENDTRY.
            DATA(ls_template1) = lo_store1->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'FINALCOMM'
              iv_template_name = 'FINALCOMM'
            ).
*            cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml1
*                                                  iv_xdp_layout   = ls_template1-xdp_template
*                                                  iv_locale       = 'en_US'
*                                                  is_options      = VALUE #(
*                                                              trace_level = 4 )
*                                        IMPORTING ev_pdf          = DATA(lv_pdf02)
*                                                  ev_trace_string = DATA(lv_trace02)
*                                                   ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      =   lv_printq                 "'FINALCOMM_INV'
                iv_xml_data     = lv_xml1
                iv_xdp_layout   = ls_template1-xdp_template
                is_options      = VALUE #(
                  trace_level = 4 "Use 0 in production environment
            )
              IMPORTING
                ev_trace_string = DATA(lv_trace1)
                ev_pdl          = DATA(lv_pdf1)
            ).

            DATA: lv_text1 TYPE char120.
            DATA: lv_fcom  TYPE char120.

            lv_fcom = lt_head[ 1 ]-commid.

            lv_text1 = |FINAL COMMERCIAL INV PRINT | && lv_fcom.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq "'FINALCOMM_INV'
              iv_print_data       = lv_pdf1
              iv_name_of_main_doc = lv_text1
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        ENDTRY.

      ENDIF.
      IF wa_head-flag = 'S'.



        TRY.
            "Initialize Template Store Client
            lo_store1 = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            lo_fdp_util1 = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSERV_D_FINALCOMM' ) ." 'ZSERV_D_PRINT' ).


            TRY.
                lo_store1->get_schema_by_name( iv_form_name = 'SPLIT_PRINT' ).
              CATCH zcx_fp_tmpl_store_error1 INTO lo_tmpl_error1.
            ENDTRY.



            lt_keys1     = lo_fdp_util1->get_keys( ).
            lt_keys1[ name = 'BILLINGDOCUMENT' ]-value = lt_head[ 1 ]-commid.
            TRY.
                lv_xml1 = lo_fdp_util1->read_to_xml( lt_keys1 ).
              CATCH cx_fp_fdp_error INTO lo_exception1.
            ENDTRY.
            ls_template1 = lo_store1->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'SPLIT_PRINT'
              iv_template_name = 'SPLIT_SO'
            ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      = lv_printq
                iv_xml_data     = lv_xml1
                iv_xdp_layout   = ls_template1-xdp_template
                is_options      = VALUE #(
                  trace_level = 4
            )
              IMPORTING
                ev_trace_string = lv_trace1
                ev_pdl          = lv_pdf1
            ).


            lv_fcom = lt_head[ 1 ]-commid.

            lv_text1 = |FINAL COMMERCIAL INV SPLIT PRINT | && lv_fcom.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq "'FINALCOMM_INV'
              iv_print_data       = lv_pdf1
              iv_name_of_main_doc = lv_text1
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        ENDTRY.

      ENDIF.
      IF wa_head-flag = 'F'.


        TRY.
            "Initialize Template Store Client
            lo_store1 = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            lo_fdp_util1 = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSERV_D_FINALCOMM' ) ." 'ZSERV_D_PRINT' ).


            TRY.
                lo_store1->get_schema_by_name( iv_form_name = 'FINAL_INVOICE_FOB' ).
              CATCH zcx_fp_tmpl_store_error1 INTO lo_tmpl_error1.
                "" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
                "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error1->mv_http_status_code = 404 OR lo_tmpl_error1->mv_http_status_code = 403 .
*                  lo_store1->set_schema(
*                    iv_form_name = 'FINALCOMM'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util1->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
                "" End Of Comment KJ 06.06.2025
            ENDTRY.

            lt_keys1     = lo_fdp_util1->get_keys( ).
*        lt_keys[ name = 'ID' ]-value = lt_head[ 1 ]-id.
            lt_keys1[ name = 'BILLINGDOCUMENT' ]-value = lt_head[ 1 ]-commid.
*          DATA(lv_sh) = VALUE #( lt_head[ 1 ]-Id OPTIONAL ).
            TRY.
                lv_xml1 = lo_fdp_util1->read_to_xml( lt_keys1 ).
              CATCH cx_fp_fdp_error INTO lo_exception1.
            ENDTRY.
            ls_template1 = lo_store1->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'FINAL_INVOICE_FOB'
              iv_template_name = 'FOB_PRINT'
            ).
*            cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml1
*                                                  iv_xdp_layout   = ls_template1-xdp_template
*                                                  iv_locale       = 'en_US'
*                                                  is_options      = VALUE #(
*                                                              trace_level = 4 )
*                                        IMPORTING ev_pdf          = DATA(lv_pdf02)
*                                                  ev_trace_string = DATA(lv_trace02)
*                                                   ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      =   lv_printq                 "'FINALCOMM_INV'
                iv_xml_data     = lv_xml1
                iv_xdp_layout   = ls_template1-xdp_template
                is_options      = VALUE #(
                  trace_level = 4 "Use 0 in production environment
            )
              IMPORTING
                ev_trace_string = lv_trace1
                ev_pdl          = lv_pdf1
            ).



            lv_fcom = lt_head[ 1 ]-commid.

            lv_text1 = |FINAL Invoice-FOB | && lv_fcom.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq "'FINALCOMM_INV'
              iv_print_data       = lv_pdf1
              iv_name_of_main_doc = lv_text1
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
