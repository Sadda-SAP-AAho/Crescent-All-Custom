CLASS lhc_zi_duedate_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_duedate_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_duedate_hdr RESULT result.

    METHODS calc FOR MODIFY
      IMPORTING keys FOR ACTION zi_duedate_hdr~calc RESULT result.

    METHODS post FOR MODIFY
      IMPORTING keys FOR ACTION zi_duedate_hdr~post RESULT result.

   METHODS Upd FOR MODIFY
      IMPORTING keys FOR ACTION zi_duedate_hdr~Upd RESULT result.

    METHODS docdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_duedate_hdr~docdetails.

    METHODS updatedata FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_duedate_hdr~updatedata.

    METHODS checkval FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_duedate_hdr~checkval.

    METHODS calcrevduedt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_duedate_hdr~calcrevduedt.

ENDCLASS.

CLASS lhc_zi_duedate_hdr IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_duedate_hdr IN LOCAL MODE
          ENTITY zi_duedate_hdr
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(header_failed).
    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>).

    SELECT SINGLE * FROM i_operationalacctgdocitem
    WHERE companycode = @<head>-ccode AND accountingdocument = @<head>-belnr
      AND fiscalyear  = @<head>-gjahr AND accountingdocumentitem = @<head>-buzei
    INTO @DATA(ls_doc).

    result = VALUE #(
       FOR gs_head IN header
       ( %tky                   = gs_head-%tky
         %action-post           = COND #( WHEN ls_doc-clearingjournalentry IS INITIAL
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled )
         %action-calc           = COND #( WHEN ls_doc-clearingjournalentry IS INITIAL
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled )
         %action-edit           = COND #( WHEN ls_doc-clearingjournalentry IS INITIAL
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled )
         %action-Upd            = COND #( WHEN ls_doc-clearingjournalentry IS INITIAL
                                          THEN if_abap_behv=>fc-o-enabled
                                          ELSE if_abap_behv=>fc-o-disabled )
         %field-billoflad       = COND #( WHEN ls_doc-accountingdocumenttype <> 'DR'
                                          THEN if_abap_behv=>fc-f-read_only
                                          ELSE if_abap_behv=>fc-o-disabled )
         %field-docsentban      = COND #( WHEN ls_doc-accountingdocumenttype <> 'DR'
                                          THEN if_abap_behv=>fc-f-read_only
                                          ELSE if_abap_behv=>fc-o-disabled )
         %field-docsentcus      = COND #( WHEN ls_doc-accountingdocumenttype <> 'DR'
                                          THEN if_abap_behv=>fc-f-read_only
                                          ELSE if_abap_behv=>fc-o-disabled )
       ) ).


  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD docdetails.
    READ ENTITIES OF zi_duedate_hdr IN LOCAL MODE
           ENTITY zi_duedate_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE * FROM i_operationalacctgdocitem
    WHERE companycode = @gfs_header-ccode AND accountingdocument = @gfs_header-belnr
      AND fiscalyear = @gfs_header-gjahr AND accountingdocumentitem = @gfs_header-buzei
      AND financialaccounttype = 'D'
     INTO @DATA(ls_doc).

    gfs_header-zterm = ls_doc-paymentterms.
    gfs_header-buzei = ls_doc-accountingdocumentitem.
    gfs_header-invdt = ls_doc-documentdate.
    gfs_header-basedt = ls_doc-duecalculationbasedate.
    gfs_header-basedtsys = ls_doc-duecalculationbasedate.
    gfs_header-duedtsys = ls_doc-netduedate.
    "gfs_header-customer = ls_doc-customer.
    gfs_header-amount = ls_doc-amountintransactioncurrency.
    gfs_header-currency = ls_doc-transactioncurrency.


    SELECT SINGLE * FROM zdt_pterm
    WHERE zterm = @gfs_header-zterm
    INTO @DATA(ls_pterm).

    gfs_header-pdesc = ls_pterm-pdesc.
    gfs_header-basis = ls_pterm-basis.
    gfs_header-noofday = ls_pterm-noofday.

    SELECT SINGLE basistxt FROM zi_basis_f4
    WHERE value_low = @ls_pterm-basis
    INTO @gfs_header-basistxt.

    gfs_header-duedt = ls_doc-netduedate. "gfs_header-basedt + ls_pterm-noofday.

    IF ls_pterm-basis = '3'.
      gfs_header-revduedt = gfs_header-basedt + ls_pterm-noofday.
    ENDIF.

    IF ls_doc-accountingdocumenttype = 'RV'.
       gfs_header-docref = ls_doc-OriginalReferenceDocument.
*      SELECT  * FROM i_billingdocumentitem
*      WHERE billingdocument = @ls_doc-OriginalReferenceDocument
*      INTO TABLE @DATA(lt_bill).
*      READ TABLE lt_bill INTO DATA(ls_bill) INDEX 1.
*      IF ls_bill-referencesddocument IS NOT INITIAL.
*        SELECT SINGLE billingdocument FROM i_billingdocumentitem
*        WHERE referencesddocument = @ls_bill-referencesddocument AND billingdocumenttype = 'F2'
*        INTO @DATA(lv_com).
*        IF lv_com IS NOT INITIAL.
          SELECT SINGLE * FROM zdt_comm_hed WHERE commid = @ls_doc-OriginalReferenceDocument INTO @DATA(ls_com).
          gfs_header-docsentban = ls_com-docpresentbnkdt.
          gfs_header-Docsentcus = ls_com-docsentcustdt.
          gfs_header-billoflad  = ls_com-ladingdt.
*        ENDIF.
*      ENDIF.
    ENDIF.


    MODIFY ENTITIES OF zi_duedate_hdr IN LOCAL MODE
               ENTITY zi_duedate_hdr
               UPDATE FIELDS ( buzei zterm invdt basedt customer amount currency pdesc basis basistxt noofday duedt revduedt basedtsys duedtsys Docsentban Docsentcus Billoflad Docref )
               WITH VALUE #( ( %tky          = gfs_header-%tky
                               buzei         = gfs_header-buzei
                               zterm         = gfs_header-zterm
                               invdt         = gfs_header-invdt
                               basedt        = gfs_header-basedt
                               customer      = gfs_header-customer
                               amount        = gfs_header-amount
                               currency      = gfs_header-currency
                               pdesc         = gfs_header-pdesc
                               basis         = gfs_header-basis
                               basistxt      = gfs_header-basistxt
                               noofday       = gfs_header-noofday
                               duedt         = gfs_header-duedt
                               revduedt      = gfs_header-revduedt
                               basedtsys     = gfs_header-basedtsys
                               duedtsys      = gfs_header-duedtsys
                               docsentban    = gfs_header-docsentban
                               docsentcus    = gfs_header-docsentcus
                               billoflad     = gfs_header-billoflad
                               Docref        = gfs_header-Docref
                           ) ).

  ENDMETHOD.

  METHOD updatedata.
  ENDMETHOD.

  METHOD checkval.
    READ ENTITIES OF zi_duedate_hdr IN LOCAL MODE
           ENTITY zi_duedate_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    SELECT SINGLE * FROM i_operationalacctgdocitem
    WHERE companycode = @gfs_header-ccode AND accountingdocument = @gfs_header-belnr
      AND fiscalyear = @gfs_header-gjahr  AND financialaccounttype = 'D'
    INTO @DATA(ls_duev).
    IF ls_duev IS INITIAL.
      DATA(lv_msg1) = |Document does not exist|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_duedate_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg1 ) )
      TO reported-zi_duedate_hdr.
    ENDIF.

    SELECT SINGLE * FROM zdt_duedate_hdr
    WHERE ccode = @gfs_header-ccode AND belnr = @gfs_header-belnr AND gjahr = @gfs_header-gjahr
    INTO @DATA(ls_duedate).

    IF ls_duedate IS NOT INITIAL.
      lv_msg1 = |Data already exist against the document|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_duedate_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg1 ) )
      TO reported-zi_duedate_hdr.
    ENDIF.

  ENDMETHOD.

  METHOD calcrevduedt.
    DATA : lv_day TYPE numc3.
    READ ENTITIES OF zi_duedate_hdr IN LOCAL MODE
           ENTITY zi_duedate_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    lv_day = + ( gfs_header-duedtsys - gfs_header-basedtsys ).
    IF gfs_header-basis = '1'.
      gfs_header-revduedt = gfs_header-docsentcus + gfs_header-noofday.
      gfs_header-basedt = gfs_header-docsentcus - lv_day + gfs_header-noofday.
    ELSEIF gfs_header-basis = '2'.
      gfs_header-revduedt = gfs_header-billoflad  + gfs_header-noofday.
      gfs_header-basedt = gfs_header-billoflad + lv_day + gfs_header-noofday.
    ELSEIF gfs_header-basis = '3'.
    ELSEIF gfs_header-basis = '4'.
      gfs_header-revduedt = gfs_header-docsentban + gfs_header-noofday.
      gfs_header-basedt = gfs_header-docsentban - lv_day + gfs_header-noofday.
    ENDIF.

    MODIFY ENTITIES OF zi_duedate_hdr IN LOCAL MODE
               ENTITY zi_duedate_hdr
               UPDATE FIELDS ( revduedt basedt )
               WITH VALUE #( ( %tky          = gfs_header-%tky
                               revduedt      = gfs_header-revduedt
                               basedt        = gfs_header-basedt
                           ) ).


  ENDMETHOD.

  METHOD calc.
    DATA : lv_day TYPE numc3.
    READ ENTITIES OF zi_duedate_hdr IN LOCAL MODE
           ENTITY zi_duedate_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    lv_day = + ( gfs_header-duedtsys - gfs_header-basedtsys ).
    IF gfs_header-basis = '1'.
      IF gfs_header-docsentcus IS NOT INITIAL.
        gfs_header-revduedt = gfs_header-docsentcus + gfs_header-noofday.
        gfs_header-basedt = gfs_header-docsentcus - lv_day + gfs_header-noofday.
      ENDIF.
    ELSEIF gfs_header-basis = '2'.
      IF gfs_header-billoflad IS NOT INITIAL.
        gfs_header-revduedt = gfs_header-billoflad  + gfs_header-noofday.
        gfs_header-basedt = gfs_header-billoflad - lv_day + gfs_header-noofday.
      ENDIF.
    ELSEIF gfs_header-basis = '3'.
    ELSEIF gfs_header-basis = '4'.
      IF gfs_header-docsentban IS NOT INITIAL.
        gfs_header-revduedt = gfs_header-docsentban + gfs_header-noofday.
        gfs_header-basedt = gfs_header-docsentban - lv_day + gfs_header-noofday.
      ENDIF.
    ENDIF.

    MODIFY ENTITIES OF zi_duedate_hdr IN LOCAL MODE
               ENTITY zi_duedate_hdr
               UPDATE FIELDS ( revduedt basedt )
               WITH VALUE #( ( %tky          = gfs_header-%tky
                               revduedt      = gfs_header-revduedt
                               basedt        = gfs_header-basedt
                           ) ).

    READ ENTITIES OF zi_duedate_hdr IN LOCAL MODE
           ENTITY zi_duedate_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd).


    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).
  ENDMETHOD.

  METHOD post.

    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    DATA: lt_je  TYPE TABLE FOR ACTION IMPORT i_journalentrytp~change,
          lv_cid TYPE abp_behv_cid,
          lv_day TYPE numc3.

    READ ENTITIES OF zi_duedate_hdr IN LOCAL MODE
           ENTITY zi_duedate_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    lv_day = + ( gfs_header-duedtsys - gfs_header-basedtsys ).
    IF gfs_header-basis = '1'.
      IF gfs_header-docsentcus IS NOT INITIAL.
        gfs_header-revduedt = gfs_header-docsentcus + gfs_header-noofday.
        gfs_header-basedt = gfs_header-docsentcus - lv_day + gfs_header-noofday.
      ENDIF.
    ELSEIF gfs_header-basis = '2'.
      IF gfs_header-billoflad IS NOT INITIAL.
        gfs_header-revduedt = gfs_header-billoflad  + gfs_header-noofday.
        gfs_header-basedt = gfs_header-billoflad - lv_day + gfs_header-noofday.
      ENDIF.
    ELSEIF gfs_header-basis = '3'.
    ELSEIF gfs_header-basis = '4'.
      IF gfs_header-docsentban IS NOT INITIAL.
        gfs_header-revduedt = gfs_header-docsentban + gfs_header-noofday.
        gfs_header-basedt = gfs_header-docsentban - lv_day + gfs_header-noofday.
      ENDIF.
    ENDIF.

    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.
    APPEND INITIAL LINE TO lt_je ASSIGNING FIELD-SYMBOL(<je>).

* APAR Item Control
    DATA lt_aparitem LIKE <je>-%param-_aparitems.
    DATA ls_aparitem LIKE LINE OF lt_aparitem.
    DATA ls_aparitem_control LIKE ls_aparitem-%control.
    ls_aparitem_control-glaccountlineitem = if_abap_behv=>mk-on.
    ls_aparitem_control-duecalculationbasedate = if_abap_behv=>mk-on.
    "     ls_aparitem_control-NetPaymentDays = if_abap_behv=>mk-on.

    DATA : lv_days LIKE ls_aparitem-netpaymentdays.

    lv_days = gfs_header-noofday.

    <je>-accountingdocument = gfs_header-belnr .
    <je>-fiscalyear = gfs_header-gjahr.
    <je>-companycode = gfs_header-ccode.
    <je>-%param = VALUE #( _aparitems = VALUE #( (
                           glaccountlineitem = gfs_header-buzei
                           duecalculationbasedate = gfs_header-basedt
                          " NetPaymentDays         = lv_days
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
      gfs_header-status = 'Posted'.
      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      gfs_header-lastposted = lv_date.


      MODIFY ENTITIES OF zi_duedate_hdr IN LOCAL MODE
                 ENTITY zi_duedate_hdr
                 UPDATE FIELDS ( revduedt basedt status lastposted )
                 WITH VALUE #( ( %tky          = gfs_header-%tky
                                 revduedt      = gfs_header-revduedt
                                 basedt        = gfs_header-basedt
                                 status        = gfs_header-status
                                 lastposted    = gfs_header-lastposted
                             ) ).
    ENDIF.

    READ ENTITIES OF zi_duedate_hdr IN LOCAL MODE
           ENTITY zi_duedate_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd1).

    result = VALUE #( FOR ls_header IN header_upd1
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).



  ENDMETHOD.

  METHOD Upd.

  READ ENTITIES OF zi_duedate_hdr IN LOCAL MODE
           ENTITY zi_duedate_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(header_failed).

  DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

  SELECT SINGLE * FROM i_operationalacctgdocitem
    WHERE companycode = @gfs_header-ccode AND accountingdocument = @gfs_header-belnr
      AND fiscalyear = @gfs_header-gjahr AND accountingdocumentitem = @gfs_header-buzei
      AND financialaccounttype = 'D'
     INTO @DATA(ls_doc).

  IF ls_doc-accountingdocumenttype = 'RV'.
*      SELECT  * FROM i_billingdocumentitem
*      WHERE billingdocument = @ls_doc-OriginalReferenceDocument
*      INTO TABLE @DATA(lt_bill).
*      READ TABLE lt_bill INTO DATA(ls_bill) INDEX 1.
*      IF ls_bill-referencesddocument IS NOT INITIAL.
*        SELECT SINGLE billingdocument FROM i_billingdocumentitem
*        WHERE referencesddocument = @ls_bill-referencesddocument AND billingdocumenttype = 'F2'
*        INTO @DATA(lv_com).
*        IF lv_com IS NOT INITIAL.
          SELECT SINGLE * FROM zdt_comm_hed WHERE commid = @ls_doc-OriginalReferenceDocument INTO @DATA(ls_com).
          gfs_header-docsentban = ls_com-docpresentbnkdt.
          gfs_header-Docsentcus = ls_com-docsentcustdt.
          gfs_header-billoflad  = ls_com-ladingdt.
*        ENDIF.
*      ENDIF.
    ENDIF.


  MODIFY ENTITIES OF zi_duedate_hdr IN LOCAL MODE
                 ENTITY zi_duedate_hdr
                 UPDATE FIELDS ( docsentban Docsentcus billoflad )
                 WITH VALUE #( ( %tky          = gfs_header-%tky
                                 docsentban    = gfs_header-docsentban
                                 Docsentcus    = gfs_header-Docsentcus
                                 billoflad     = gfs_header-billoflad
                             ) ).

  READ ENTITIES OF zi_duedate_hdr IN LOCAL MODE
           ENTITY zi_duedate_hdr
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_upd1).

    result = VALUE #( FOR ls_header IN header_upd1
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).

  ENDMETHOD.

ENDCLASS.
