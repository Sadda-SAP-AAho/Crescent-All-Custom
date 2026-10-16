
CLASS lhc_zi_nostro_hed DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_nostro_hed RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_nostro_hed RESULT result.

    METHODS updatedatahdr FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_nostro_hed~updatedatahdr.

    METHODS updatedata FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_nostro_hed~updatedata.
    METHODS payterm FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_nostro_hed~payterm.

**    METHODS accupdate FOR MODIFY
**      IMPORTING keys FOR ACTION zi_nostro_hed~accupdate RESULT result.

**    METHODS checkdel FOR VALIDATE ON SAVE
**      IMPORTING keys FOR zi_nostro_hed~checkdel.

ENDCLASS.

CLASS lhc_zi_nostro_hed IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
         ENTITY zi_nostro_hed
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header).


    result = VALUE #(
            FOR gs_item IN header
            ( %tky                            = gs_item-%tky
              %assoc-_item                    = if_abap_behv=>fc-o-disabled
            ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updatedatahdr.
    DATA: lv_invoice TYPE vbeln_va.

    READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
         ENTITY zi_nostro_hed
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    gfs_header-invoiceno = |{ gfs_header-invoiceno ALPHA = IN }| .

    IF gfs_header-customer IS NOT INITIAL.
      SELECT SINGLE * FROM i_customer
      WHERE customer = @gfs_header-customer
      INTO @DATA(ls_customer) .
      IF sy-subrc EQ 0.
        gfs_header-customername = ls_customer-customerfullname .
      ENDIF.
    ENDIF.

    IF gfs_header-invoiceno IS NOT INITIAL.
      SELECT SINGLE * FROM zi_nostro_f4
      WHERE accountingdocument = @gfs_header-invoiceno
      INTO @DATA(ls_invdate) .
      IF sy-subrc EQ 0.
        gfs_header-postingdate = ls_invdate-postingdate .
      ENDIF.
    ENDIF.

    MODIFY ENTITIES OF zi_nostro_hed IN LOCAL MODE
           ENTITY zi_nostro_hed
           UPDATE
**           FIELDS ( invoiceno customername postingdate )
           FIELDS ( customername postingdate )
           WITH VALUE #( ( id           =  gfs_header-id
                           %tky         = gfs_header-%tky

*                           invoiceno    = gfs_header-invoiceno
                           customername = gfs_header-customername
                           postingdate  = gfs_header-postingdate
                           ) ).

  ENDMETHOD.

  METHOD updatedata.

    DATA : gs_item TYPE zdt_nostro_itm.
    DATA:lr_postdate TYPE RANGE OF budat.

    READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
           ENTITY zi_nostro_hed
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    IF gfs_header-postingdate IS NOT INITIAL.
      lr_postdate = VALUE #( ( sign = 'I' option = 'EQ' low = gfs_header-postingdate ) ).
    ENDIF.

    gfs_header-invoiceno = |{ gfs_header-invoiceno ALPHA = IN }| .

    SELECT * FROM i_operationalacctgdocitem WHERE companycode        EQ @gfs_header-companycode AND
                                                  customer           EQ @gfs_header-customer    AND
                                                  accountingdocument EQ @gfs_header-invoiceno
***                                                  postingdate        IN @lr_postdate
    INTO TABLE @DATA(lt_docitm).
    LOOP AT lt_docitm ASSIGNING FIELD-SYMBOL(<lfs_docitm>).

      MODIFY ENTITIES OF zi_nostro_hed IN LOCAL MODE
      ENTITY zi_nostro_hed
      CREATE BY \_item
      FROM VALUE #( ( id      = gfs_header-id
                      %target = VALUE #( (     %cid                = gfs_header-companycode && gfs_header-customer &&
                                                                     gfs_header-invoiceno   && gfs_header-postingdate

                                               accountingdocument     = <lfs_docitm>-accountingdocument
                                               accountingdocumentitem = <lfs_docitm>-accountingdocumentitem
                                               referenceno            = <lfs_docitm>-originalreferencedocument
                                               accountingdocumenttype = <lfs_docitm>-accountingdocumenttype
                                               documentdate           = <lfs_docitm>-documentdate
                                               postingdate            = <lfs_docitm>-postingdate
                                               amountdc               = <lfs_docitm>-amountintransactioncurrency
                                               currencydc             = <lfs_docitm>-transactioncurrency
                                               remainamtdc            = <lfs_docitm>-amountintransactioncurrency
                                               amountcc               = <lfs_docitm>-amountincompanycodecurrency
                                               currencycc             = <lfs_docitm>-companycodecurrency
                                               payterm                = <lfs_docitm>-paymentterms
                                               duedate                = <lfs_docitm>-netduedate
                                               currencyinward         = <lfs_docitm>-transactioncurrency


                                               %control-accountingdocument     = if_abap_behv=>mk-on
                                               %control-accountingdocumentitem = if_abap_behv=>mk-on
                                               %control-referenceno            = if_abap_behv=>mk-on
                                               %control-accountingdocumenttype = if_abap_behv=>mk-on
                                               %control-documentdate           = if_abap_behv=>mk-on
                                               %control-postingdate            = if_abap_behv=>mk-on
                                               %control-amountdc               = if_abap_behv=>mk-on
                                               %control-currencydc             = if_abap_behv=>mk-on
                                               %control-remainamtdc            = if_abap_behv=>mk-on
                                               %control-amountcc               = if_abap_behv=>mk-on
                                               %control-currencycc             = if_abap_behv=>mk-on
                                               %control-payterm                = if_abap_behv=>mk-on
                                               %control-duedate                = if_abap_behv=>mk-on
                                               %control-currencyinward         = if_abap_behv=>mk-on
                                        ) ) ) )
                      MAPPED FINAL(ls_mapped)
                      FAILED FINAL(ls_failed)
                      REPORTED FINAL(ls_reported).

    ENDLOOP.

  ENDMETHOD.

  METHOD payterm.
***    DATA: lv_msg TYPE string.
***    READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
***             ENTITY zi_nostro_hed
***             ALL FIELDS
***             WITH CORRESPONDING #( keys )
***             RESULT FINAL(header).
***
***
***    READ ENTITY zi_nostro_hed
***         BY \_item
***         ALL FIELDS
***         WITH CORRESPONDING #( keys )
***         RESULT DATA(item).
***
***    READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
***         ENTITY zi_nostro_itm2
***         ALL FIELDS
***         WITH CORRESPONDING #( keys )
***         RESULT DATA(item2).
***
***    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
***
***
***    gfs_header-invoiceno = |{ gfs_header-invoiceno ALPHA = IN }| .
***    IF item2 IS NOT INITIAL.
***      LOOP AT item2 INTO DATA(ls_item2).
***        READ TABLE item INTO DATA(ls_item) WITH KEY accountingdocument = ls_item2-accountingdocument
***                                                    accountingdocumentitem = ls_item2-accountingdocumentitem .
***        IF sy-subrc EQ 0 AND ls_item2-accountingdocumenttype <> ls_item-accountingdocumenttype AND
***           ls_item-accountingdocumenttype <> 'UE' AND ls_item2-payterm IS INITIAL.
***          lv_msg = |Payment Term is mandatory in Inward Payment|.
***          APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_nostro_hed.
***
***          APPEND VALUE #( %tky        = gfs_header-%tky
***                          %state_area = 'Validate_Header'
***                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
***                                                               text     = lv_msg ) )
***                 TO reported-zi_nostro_hed.
***        ENDIF.
***      ENDLOOP.
***    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_nostro_itm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_nostro_itm RESULT result.

ENDCLASS.

CLASS lhc_zi_nostro_itm IMPLEMENTATION.
  METHOD get_instance_features.

    READ ENTITY zi_nostro_hed
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item).

    result = VALUE #(
            FOR gs_item IN item
            ( %tky                            = gs_item-%tky
             %delete                          = if_abap_behv=>fc-o-disabled
            ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_nostro_itm2 DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_nostro_itm2 RESULT result.

    METHODS updatedataitm2 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_nostro_itm2~updatedataitm2.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_nostro_itm2 RESULT result.

    METHODS accupdateitm FOR MODIFY
      IMPORTING keys FOR ACTION zi_nostro_itm2~accupdateitm RESULT result.
    METHODS update_rem_amt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_nostro_itm2~update_rem_amt.
    METHODS payterm FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_nostro_itm2~payterm.

ENDCLASS.

CLASS lhc_zi_nostro_itm2 IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD updatedataitm2.

  "------------------------------------------------------------
  " Read Header
  "------------------------------------------------------------
  READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
       ENTITY zi_nostro_hed
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(header).

  DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

  IF gfs_header IS INITIAL.
    RETURN.
  ENDIF.


  "------------------------------------------------------------
  " Convert Invoice No. to Internal Format
  "------------------------------------------------------------
  gfs_header-invoiceno = |{ gfs_header-invoiceno ALPHA = IN }|.


  "------------------------------------------------------------
  " Read Account Details
  " _item is the SOURCE of values
  "------------------------------------------------------------
  READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
       ENTITY zi_nostro_hed
       BY \_item
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(item).


  "------------------------------------------------------------
  " Read Inward Payment Items
  "------------------------------------------------------------
  READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
       ENTITY zi_nostro_hed
       BY \_item2
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(item2).


  "------------------------------------------------------------
  " Loop Inward Payment Items
  "------------------------------------------------------------
  LOOP AT item2 INTO DATA(ls_item2).

    "----------------------------------------------------------
    " Keep OLD values before changing them
    "----------------------------------------------------------
    DATA(lv_old_accountingdocument) = ls_item2-accountingdocument.

    DATA(lv_old_referenceno) = ls_item2-referenceno.

    DATA(lv_accountingdocumentitem) = ls_item2-accountingdocumentitem.


    "----------------------------------------------------------
    " Find corresponding Account Details record
    "----------------------------------------------------------
    READ TABLE item INTO DATA(ls_item)
      WITH KEY
        accountingdocument     = lv_old_accountingdocument
        accountingdocumentitem = lv_accountingdocumentitem
        referenceno            = lv_old_referenceno.


    "----------------------------------------------------------
    " Copy Account Details -> Inward Payment
    "----------------------------------------------------------
    IF sy-subrc = 0.

      ls_item2-amountdc = ls_item-amountdc.

      ls_item2-currencydc = ls_item-currencydc.

      ls_item2-remainamtdc = ls_item-remainamtdc.

      ls_item2-duedate = ls_item-duedate.

      ls_item2-currencyinward = ls_item-currencydc.

      "Copy Payment Term also
      ls_item2-payterm = ls_item-payterm.

    ENDIF.


    "----------------------------------------------------------
    " Update Accounting Document
    "----------------------------------------------------------
    ls_item2-accountingdocument =
      gfs_header-invoiceno.


    "----------------------------------------------------------
    " Update Reference Accounting Document
    "----------------------------------------------------------
    ls_item2-referenceno =
      gfs_header-refaccdocno.


    "----------------------------------------------------------
    " Get Bank Reference No.
    "----------------------------------------------------------
    CLEAR ls_item2-bankrefno.

    IF ls_item2-referenceno IS NOT INITIAL.

      DATA(lv_commid) =
        ls_item2-referenceno+0(10).

      SELECT SINGLE bankrefno
        FROM zdt_comm_hed
        WHERE commid = @lv_commid
        INTO @ls_item2-bankrefno.

    ENDIF.


    "----------------------------------------------------------
    " Update Inward Payment Item
    "----------------------------------------------------------
    MODIFY ENTITIES OF zi_nostro_hed IN LOCAL MODE
           ENTITY zi_nostro_itm2
           UPDATE
           FIELDS (
             accountingdocument
             referenceno
             amountdc
             currencydc
             remainamtdc
             payterm
             duedate
             currencyinward
             bankrefno
           )
           WITH VALUE #(
             (
               %tky               = ls_item2-%tky
               accountingdocument = ls_item2-accountingdocument
               referenceno        = ls_item2-referenceno
               amountdc           = ls_item2-amountdc
               currencydc         = ls_item2-currencydc
               remainamtdc        = ls_item2-remainamtdc
               payterm            = ls_item2-payterm
               duedate            = ls_item2-duedate
               currencyinward     = ls_item2-currencyinward
               bankrefno          = ls_item2-bankrefno
             )
           )
           MAPPED   FINAL(ls_mapped)
           FAILED   FINAL(ls_failed)
           REPORTED FINAL(ls_reported).

  ENDLOOP.

ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD accupdateitm.

    DATA: lt_je  TYPE TABLE FOR ACTION IMPORT i_journalentrytp~change,
          lv_cid TYPE abp_behv_cid.
    DATA: lv_refno3 TYPE xref3.
    DATA: lv_msg TYPE string.
*----------------------------------------------------------------------------*
    READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
           ENTITY zi_nostro_hed
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(header_failed).

    READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
            ENTITY zi_nostro_itm2
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_item)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(lt_item_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
*----------------------------------------------------------------------------*

    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<lfs_item>) ."WHERE checkbox = abap_true.


      SELECT SINGLE * FROM i_operationalacctgdocitem
                           WHERE companycode             EQ @gfs_header-companycode AND
                                 customer                EQ @gfs_header-customer    AND
                                  accountingdocument     EQ @gfs_header-invoiceno   AND
                                  accountingdocumentitem EQ @<lfs_item>-accountingdocumentitem   AND
                                  paymentterms           EQ @<lfs_item>-payterm
*                                  clearingjournalentry   EQ ''
      INTO @DATA(ls_docitm).

      IF ls_docitm-clearingjournalentry IS NOT INITIAL.
        lv_msg = |Account Doc Already Clear-| && ls_docitm-clearingjournalentry.
        APPEND VALUE #(  %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-information
                                                              text     = lv_msg ) )
               TO reported-zi_nostro_hed.
        RETURN.
      ENDIF.
      CHECK sy-subrc EQ 0 .


      APPEND INITIAL LINE TO lt_je ASSIGNING FIELD-SYMBOL(<je>).

* APAR Item Control
      DATA lt_aparitem LIKE <je>-%param-_aparitems.
      DATA ls_aparitem LIKE LINE OF lt_aparitem.
      DATA ls_aparitem_control LIKE ls_aparitem-%control.

      ls_aparitem_control-glaccountlineitem = if_abap_behv=>mk-on.
      ls_aparitem_control-reference3idbybusinesspartner = if_abap_behv=>mk-on.

      lv_refno3 =  |{ <lfs_item>-inwarddate DATE = USER }|.

      IF <lfs_item>-inwardrecordstatus = 'YES'.
        lv_refno3 = lv_refno3 && 'F'.
      ELSE.
        lv_refno3 = lv_refno3 && 'P'.
      ENDIF.

      DATA : lv_days LIKE ls_aparitem-netpaymentdays.

      <je>-accountingdocument = gfs_header-invoiceno .
      <je>-fiscalyear         = gfs_header-fiscalyear.
      <je>-companycode        = gfs_header-companycode.
      <je>-companycode        = gfs_header-companycode.
      <je>-%param = VALUE #( _aparitems = VALUE #( (
                               glaccountlineitem = ls_docitm-accountingdocumentitem
                              reference3idbybusinesspartner = lv_refno3
                             %control = ls_aparitem_control ) )
                           ).

      MODIFY ENTITIES OF i_journalentrytp
                     ENTITY journalentry
                  EXECUTE change FROM lt_je
                  FAILED DATA(ls_failed_deep)
                  REPORTED DATA(ls_reported_deep)
                  MAPPED DATA(ls_mapped_deep).

      IF ls_failed_deep IS NOT INITIAL.
      ELSE.
      ENDIF.

      READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
             ENTITY zi_nostro_itm2
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(item_upd).

      result = VALUE #( FOR ls_itm_upd IN item_upd
                            ( %tky   = ls_itm_upd-%tky
                              %param = ls_itm_upd ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD update_rem_amt.

    DATA: lv_inwardamt TYPE dmbtr.

    READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
         ENTITY zi_nostro_hed
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header).


    READ ENTITY zi_nostro_hed
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item).

    READ ENTITY zi_nostro_hed
         BY \_item2
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item2).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).


    gfs_header-invoiceno = |{ gfs_header-invoiceno ALPHA = IN }| .

    LOOP AT item2 INTO DATA(ls_item2)
                            GROUP BY ( k1 = ls_item2-accountingdocument
                                       k2 = ls_item2-accountingdocumentitem ) INTO DATA(ls_grp).
      CLEAR:lv_inwardamt.
      LOOP AT GROUP ls_grp INTO ls_item2 .
        lv_inwardamt = lv_inwardamt + ls_item2-inwardamount.
      ENDLOOP.

      ls_item2-accountingdocument = gfs_header-invoiceno .

      DATA(gfs_item) = VALUE #( item[ accountingdocument     = ls_item2-accountingdocument
                                      accountingdocumentitem = ls_item2-accountingdocumentitem
                                      payterm                = ls_item2-payterm                 ] OPTIONAL ).
      IF gfs_item IS NOT INITIAL.
        ls_item2-remainamtdc = gfs_item-amountdc - lv_inwardamt .
        gfs_item-remainamtdc = gfs_item-amountdc - lv_inwardamt .
      ENDIF.

      MODIFY ENTITIES OF zi_nostro_hed IN LOCAL MODE
             ENTITY zi_nostro_itm2
             UPDATE
               FIELDS ( remainamtdc )
             WITH VALUE #( (

                             %tky                     = ls_item2-%tky
                               remainamtdc            = ls_item2-remainamtdc
                             ) )
                        MAPPED FINAL(ls_mapped)
                        FAILED FINAL(ls_failed)
                        REPORTED FINAL(ls_reported).

      MODIFY ENTITIES OF zi_nostro_hed IN LOCAL MODE
             ENTITY zi_nostro_itm
             UPDATE
               FIELDS ( remainamtdc )
             WITH VALUE #( (

                             %tky                     = gfs_item-%tky
                               remainamtdc            = gfs_item-remainamtdc
                             ) )
                        MAPPED FINAL(ls_mapped2)
                        FAILED FINAL(ls_failed2)
                        REPORTED FINAL(ls_reported2).

    ENDLOOP.


  ENDMETHOD.


*  METHOD val_inwarditm2.

*    DATA: lv_msg TYPE string.
*
*    READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
*            ENTITY zi_nostro_hed
*            ALL FIELDS
*            WITH CORRESPONDING #( keys )
*            RESULT FINAL(lt_header)
*            " TODO: variable is assigned but never used (ABAP cleaner)
*            FAILED FINAL(lt_header_failed).
*
*    READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
*         ENTITY zi_nostro_itm2
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(lt_item)
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         FAILED FINAL(lt_item_failed).
*    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
*
**====// Item line validation //====*
*    LOOP AT lt_item INTO DATA(ls_item).
*      CLEAR: lv_msg.
*      IF ls_item-inwardrefno IS NOT INITIAL OR ls_item-inwarddate IS NOT INITIAL OR ls_item-inwardamount IS NOT INITIAL .
*
*        IF ls_item-inwardrefno IS INITIAL OR ls_item-inwarddate IS INITIAL OR ls_item-inwardamount IS INITIAL .
*
*          lv_msg = |Please Maintain value in Inward Reference No,Date and Amount.|.
*          APPEND VALUE #( %tky = gs_head-%tky ) TO failed-zi_nostro_hed.
*
*          APPEND VALUE #( %tky        = gs_head-%tky
*                          %state_area = 'Validate_Item'
*                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                               text     = lv_msg ) )
*                 TO reported-zi_nostro_hed.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.
*
*
*  ENDMETHOD.

  METHOD payterm.
    DATA: lv_msg TYPE string.
    READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
             ENTITY zi_nostro_hed
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).


    READ ENTITY zi_nostro_hed
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item).

    READ ENTITIES OF zi_nostro_hed IN LOCAL MODE
         ENTITY zi_nostro_itm2
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(item2).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).


    gfs_header-invoiceno = |{ gfs_header-invoiceno ALPHA = IN }| .
    IF item2 IS NOT INITIAL.
      LOOP AT item2 INTO DATA(ls_item2).
        READ TABLE item INTO DATA(ls_item) WITH KEY accountingdocument = ls_item2-accountingdocument
                                                    accountingdocumentitem = ls_item2-accountingdocumentitem .
        IF sy-subrc EQ 0 AND ls_item2-accountingdocumenttype <> ls_item-accountingdocumenttype AND
           ls_item-accountingdocumenttype <> 'UE' AND ls_item2-payterm IS INITIAL.
          lv_msg = |Payment Term is mandatory in Inward Payment|.
          APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_nostro_hed.

          APPEND VALUE #( %tky        = gfs_header-%tky
                          %state_area = 'Validate_Header'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
                 TO reported-zi_nostro_hed.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
