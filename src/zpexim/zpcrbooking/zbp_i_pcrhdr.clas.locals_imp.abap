CLASS lhc_zi_pcrhdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_pcrhdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_pcrhdr RESULT result.
    METHODS headerdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_pcrhdr~headerdetails.
    METHODS checkdetails FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_pcrhdr~checkdetails.
    METHODS checkdoc FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_pcrhdr~checkdoc.
    METHODS acc_post FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_pcrhdr~acc_post.
*    METHODS header FOR DETERMINE ON SAVE
*      IMPORTING keys FOR zi_pcrhdr~header.

    METHODS upd FOR MODIFY
      IMPORTING keys FOR ACTION zi_pcrhdr~upd RESULT result.

ENDCLASS.

CLASS lhc_zi_pcrhdr IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
            ENTITY zi_pcrhdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(header_failed).

    FINAL(ls_head) = VALUE #( header[ 1 ] OPTIONAL ).

    SELECT SINGLE * FROM zdt_pcr_hdr WHERE id = @ls_head-id INTO @DATA(ls_heddata).

    result = VALUE #( FOR gs_head IN header
                        ( %tky               = gs_head-%tky

                         %field-exchangerate1     = COND #( WHEN ( gs_head-waers <> 'INR' AND
                                                                   gs_head-accpost = '' )
                                                       THEN if_abap_behv=>fc-f-mandatory
                                                       ELSE if_abap_behv=>fc-f-read_only  )

                         %field-accdocdate        = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )

                         %field-accpostdate        = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory )

                         %field-cloanbankaccid     = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )

                         %field-cloanglacc         = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )
                         %field-cloanhousebank     = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )

                         %field-dbankaccid         = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )
                         %field-dglbankacc         = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )
                         %field-dhousebank          = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )

                         %assoc-_item             = COND #( WHEN ls_heddata-accpost <> ''
                                                       THEN if_abap_behv=>fc-o-enabled
                                                       ELSE if_abap_behv=>fc-o-disabled  )

                         %assoc-_item1            = COND #( WHEN ls_heddata-accpost <> ''
                                                       THEN if_abap_behv=>fc-o-enabled
                                                       ELSE if_abap_behv=>fc-o-disabled  )

                         %assoc-_item2            = COND #( WHEN ls_heddata-accpost <> ''
                                                       THEN if_abap_behv=>fc-o-enabled
                                                       ELSE if_abap_behv=>fc-o-disabled  )
                         %field-accpost          = COND #( WHEN ( ls_heddata-accpostref = '' AND
                                                                ls_heddata-id <> '' )
                                                       THEN if_abap_behv=>fc-f-mandatory
                                                       ELSE if_abap_behv=>fc-f-read_only  )

                        %delete                  = COND #( WHEN sy-uname = 'CB9980000000'  "++ 14.02.25@SM
                                                            THEN if_abap_behv=>fc-o-enabled
                                                           WHEN gs_head-accpost = 'X'
                                                           THEN if_abap_behv=>fc-o-disabled
                                                           ELSE if_abap_behv=>fc-o-enabled  )

                       %field-name              = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )
                       %field-bookingdt              = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )
                       %field-bankname              = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )
                       %field-waers              = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )

                       %field-loantype          = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )
                       %field-basedoctype       = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )
                       %field-bookamt           = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )
                       %field-duedt              = COND #( WHEN gs_head-accpost = 'X'
                                                       THEN if_abap_behv=>fc-f-read_only
                                                       ELSE if_abap_behv=>fc-f-mandatory  )

                        ) ).
    CLEAR ls_heddata.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD headerdetails.

    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
      ENTITY zi_pcrhdr
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      FAILED DATA(lt_header_failed).

    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<lfs_header>).

      IF <lfs_header>-waers = 'INR'.
        <lfs_header>-exchangerate1 = '1.0000'.
      ENDIF.

      MODIFY ENTITIES OF zi_pcrhdr IN LOCAL MODE
            ENTITY zi_pcrhdr
            UPDATE
                FIELDS ( exchangerate1 )
                WITH VALUE #(
                               ( %tky   = <lfs_header>-%tky
                                 exchangerate1    = <lfs_header>-exchangerate1
                                  %control-exchangerate1 = if_abap_behv=>mk-on
                               ) ).

    ENDLOOP.

    DATA: ls_sum TYPE dmbtr.
    DATA: lv_amt TYPE dmbtr.
    CLEAR :ls_sum,lv_amt.

    READ ENTITY zi_pcrhdr
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(it1).

    LOOP AT it1 INTO DATA(ls_it1).
      lv_amt = lv_amt + ls_it1-adjamt + ls_it1-otheramt.
    ENDLOOP.

    ls_sum = lv_amt.

    <lfs_header>-balanceamt = <lfs_header>-bookamt - ls_sum. "ls_item-appl_amt_lc.

    MODIFY ENTITIES OF zi_pcrhdr IN LOCAL MODE
            ENTITY zi_pcrhdr
            UPDATE
                FIELDS ( balanceamt  )
                WITH VALUE #( ( %tky   = <lfs_header>-%tky
                                 balanceamt = <lfs_header>-balanceamt
                                 %control-balanceamt  = if_abap_behv=>mk-on
                               ) ).
  ENDMETHOD.

  METHOD checkdetails.
    DATA: lv_msg TYPE string .
*--------------------------------------------------------------------------------*
    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
               ENTITY zi_pcrhdr
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header1).

    DATA(gfs_header1) = VALUE #( header1[ 1 ]  OPTIONAL ).
*--------------------------------------------------------------------------------*

    IF gfs_header1-balanceamt < 0.
      lv_msg = |Loan Balance Amount Can't Be Negative|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_pcrhdr.
    ENDIF.

    IF gfs_header1-bankname IS INITIAL.
      lv_msg = |Bank Name Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_pcrhdr.
    ENDIF.
    IF gfs_header1-waers IS INITIAL.
      lv_msg = |Currency Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_pcrhdr.
    ENDIF.

    IF gfs_header1-name IS INITIAL.
      lv_msg = |Loan Name Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_pcrhdr.
    ENDIF.

    IF gfs_header1-bookingdt IS INITIAL.
      lv_msg = |Booking Date Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_pcrhdr.
    ENDIF.

    IF gfs_header1-bookamt IS INITIAL.
      lv_msg = |Loan Booking Amount Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_pcrhdr.
    ENDIF.
    IF gfs_header1-exchangerate1 IS INITIAL.
      IF gfs_header1-currency <> 'INR'.
        lv_msg = |Exchange Rate Is Mandatory|.
        APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

        APPEND VALUE #( %tky        = gfs_header1-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_pcrhdr.
      ENDIF.
    ENDIF.
    IF gfs_header1-duedt IS INITIAL.
      lv_msg = |Loan Due Date Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_pcrhdr.
    ENDIF.

    IF ( gfs_header1-loantype = 'PRE-SHIPMENT' OR gfs_header1-loantype = 'POST-SHIPMENT' )
    AND  gfs_header1-basedoctype IS INITIAL.
      lv_msg = |Base Document Type Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_pcrhdr.
    ENDIF.

    IF gfs_header1-benchmarktype IS INITIAL.
      lv_msg = |Benchmark Rate Type Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_pcrhdr.
    ENDIF.

    IF gfs_header1-loantype IS INITIAL.
      lv_msg = |Loan Type Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_pcrhdr.
    ENDIF.

    IF gfs_header1-benchmarktype IS  NOT INITIAL.
      IF ( gfs_header1-benchintrate IS INITIAL AND gfs_header1-intratesp IS INITIAL ).

        lv_msg = |Either Of Benchmark Rate or Int Rate Spread Is Mandatory|.
        APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

        APPEND VALUE #( %tky        = gfs_header1-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_pcrhdr.
      ENDIF.
    ENDIF.


    IF ( gfs_header1-benchmarktype = 'SOFR' OR gfs_header1-benchmarktype = 'EURO' ).
      IF gfs_header1-interestdays IS INITIAL .
        lv_msg = |Interest Days Is Mandatory|.
        APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

        APPEND VALUE #( %tky        = gfs_header1-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_pcrhdr.
      ENDIF.
    ENDIF.

    "---- Account Post Validation ----"

    IF  gfs_header1-cloanglacc IS INITIAL AND gfs_header1-dglbankacc IS INITIAL .
      lv_msg = |Loan Credit & Debit GL and  is Mandatory|.
      APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

      APPEND VALUE #( %tky        = gfs_header1-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_pcrhdr.
    ENDIF.


  ENDMETHOD.

  METHOD checkdoc.

    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
                 ENTITY zi_pcrhdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header1).

    DATA(gfs_header1) = VALUE #( header1[ 1 ]  OPTIONAL ).

    IF gfs_header1-loanacno IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_pcr_hdr
      WHERE loanacno = @gfs_header1-loanacno
      INTO @DATA(ls_del1).
      IF ls_del1 IS NOT INITIAL.

        DATA(lv_msg) = |Loan Account No Already Exists|.
        APPEND VALUE #( %tky = gfs_header1-%tky ) TO failed-zi_pcrhdr.

        APPEND VALUE #( %tky        = gfs_header1-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_pcrhdr.
      ENDIF.
    ENDIF.
  ENDMETHOD.

*//----------- Account Post  ------------------------------//*
  METHOD acc_post.

    DATA : lv_text      TYPE string,
           lv_acpostref TYPE c LENGTH 26,
           lv_date      TYPE datn,
           lv_time      TYPE timn,
           lv_msg       TYPE string.

    DATA: lt_msg TYPE STANDARD TABLE OF char100.


    DATA: lt_temp_key TYPE zgje_transaction_handler=>tt_temp_key,
          ls_temp_key LIKE LINE OF lt_temp_key.
    TYPES: BEGIN OF glitems,
             housebank        TYPE char10,
             housebankaccount TYPE char20,
             chargehed        TYPE char256,
             waers            TYPE waers,
             amt              TYPE dmbtr,
             glaccount        TYPE char10,
             taxc             TYPE char10,
             status           TYPE char4,
             costcenter       TYPE char20,
             lv_num           TYPE numc3,
             lv_numtax        TYPE numc3,
             status1          TYPE char4,
             exchangerate     TYPE p DECIMALS 5 LENGTH 16,
           END OF glitems,

           BEGIN OF ty_glitemstax,
             glaccountlineitem      TYPE char6,
             taxcode                TYPE mwskz,
             conditiontype          TYPE kschl,
             taxitemacctgdocitemref TYPE posnr,
             taxrate                TYPE p LENGTH 7 DECIMALS 3,
             journalentryitemamount TYPE dmbtr,
             currency               TYPE waers,
             taxbaseamount          TYPE dmbtr,
           END OF ty_glitemstax.

    DATA: gt_glitems TYPE STANDARD TABLE OF glitems,
          gs_glitems TYPE glitems,

          gt_gltax   TYPE STANDARD TABLE OF ty_glitemstax,
          gs_gltax   TYPE ty_glitemstax.

    DATA: lv_num     TYPE numc3,
          lv_taxamt  TYPE dmbtr,
          lv_waivoff TYPE dmbtr.

*//--------------------------------------------------------------------------//
    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
      ENTITY zi_pcrhdr
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      FAILED DATA(lt_header_failed).

    DATA(gfs_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    CHECK gfs_header-accpost IS NOT INITIAL AND
          gfs_header-cloanglacc IS NOT INITIAL AND
          gfs_header-dglbankacc IS NOT INITIAL AND
          gfs_header-bookamt IS NOT INITIAL .

    CHECK gfs_header-accpostref IS INITIAL .
*//--------------------------------------------------------------------------//

    DATA(ls_entry) = gfs_header.

    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lv_cid     TYPE abp_behv_cid.

    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

    FREE: gt_glitems,gt_gltax.

    CLEAR gs_glitems.
    gfs_header-cloanglacc = |{ gfs_header-cloanglacc ALPHA = IN }|.

    gs_glitems = VALUE #(  glaccount         = gfs_header-cloanglacc
                            amt              = ( gfs_header-bookamt * -1 )
                            waers            = gfs_header-waers
                            housebank        = gfs_header-cloanhousebank
                            housebankaccount = gfs_header-cloanbankaccid
                            exchangerate     = COND #( WHEN gfs_header-waers <> 'INR' THEN gfs_header-exchangerate1 )
                            ).


    APPEND gs_glitems TO gt_glitems.
    gfs_header-dglbankacc = |{ gfs_header-dglbankacc ALPHA = IN }|.

    gs_glitems = VALUE #(   glaccount        = gfs_header-dglbankacc
                            amt              = gfs_header-bookamt
                            waers            = gfs_header-waers
                            housebank        = gfs_header-dhousebank
                            housebankaccount = gfs_header-dbankaccid
                            exchangerate     = COND #( WHEN gfs_header-waers <> 'INR' THEN gfs_header-exchangerate1 )
                         ).


    APPEND gs_glitems TO gt_glitems.
    DATA(lt_glitems) = gt_glitems[].


*//-- Set Sl no---
    lv_num = 1.
    LOOP AT lt_glitems ASSIGNING FIELD-SYMBOL(<fs_glitems>).
      <fs_glitems>-lv_num = lv_num.
      IF <fs_glitems>-taxc IS NOT INITIAL .
        <fs_glitems>-lv_numtax = lv_num.
      ENDIF.
      lv_num += 1.

    ENDLOOP.

*//------------------Get Date Time from Time Stamp -----------//
    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
    lv_acpostref = gfs_header-loanacno && lv_time.


*//-- Set Final Journal Entry line ---
    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
    <je_deep>-%cid = lv_cid.
    <je_deep>-%param = VALUE #(
                        companycode                  = '1000'
                        documentreferenceid          = ls_entry-loanacno
                        businesstransactiontype      = 'RFBU'
                        accountingdocumenttype       = 'SA'
                        createdbyuser                = sy-uname
                        documentdate                 = ls_entry-accdocdate
                        postingdate                  = ls_entry-accpostdate
                        accountingdocumentheadertext = lv_acpostref


                        _glitems                     = VALUE #( FOR ls_item1 IN lt_glitems
                                                                 ( glaccountlineitem      = ls_item1-lv_num
                                                                   glaccount              = ls_item1-glaccount
                                                                   profitcenter           = '1000'
                                                                   assignmentreference    = gfs_header-loanacno
                                                                   housebank              = ls_item1-housebank
                                                                   housebankaccount       = ls_item1-housebankaccount

                                                                  _currencyamount   = VALUE #( ( currencyrole           = '00'
                                                                                                 journalentryitemamount = ls_item1-amt
                                                                                                 currency               = ls_item1-waers
                                                                                                 exchangerate           = ls_item1-exchangerate  ) )
                                                                   ) )
                                   ).

*//--------------------------------------------------------------------------//

    DATA: lt_je_val TYPE TABLE FOR FUNCTION IMPORT i_journalentrytp~validate.

    lt_je_val = CORRESPONDING #( lt_je_deep ).

    READ ENTITIES OF i_journalentrytp
            ENTITY journalentry
            EXECUTE validate
            FROM lt_je_val
      RESULT DATA(lt_check_result)
      FAILED DATA(ls_failed_deep01)
      REPORTED DATA(ls_reported_deep01).

    IF ls_failed_deep01 IS NOT INITIAL.

      LOOP AT ls_reported_deep01-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep01>).
        lv_msg = <ls_reported_deep01>-%msg->if_message~get_text( ).

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Error_Message'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
       TO reported-zi_pcrhdr.
        CLEAR lv_msg.
      ENDLOOP.

      TRY.
          DATA(lv_item) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
          " handle exception
      ENDTRY.
      gfs_header-accpost    = ''.
      gfs_header-accpostref = ''.
    ELSE.

      MODIFY ENTITIES OF i_journalentrytp
            PRIVILEGED
            ENTITY journalentry
            EXECUTE post FROM lt_je_deep
      FAILED DATA(ls_failed_deep)
      REPORTED DATA(ls_reported_deep)
      MAPPED DATA(ls_mapped_deep).

      IF ls_failed_deep IS NOT INITIAL.
        LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
          lv_msg = <ls_reported_deep01>-%msg->if_message~get_text( ).

          APPEND VALUE #( %tky        = gfs_header-%tky
                          %state_area = 'Error_Message'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
         TO reported-zi_pcrhdr.
          CLEAR lv_msg.
        ENDLOOP.
      ELSE. "---Success

        gfs_header-accpost    = 'X'.
        gfs_header-accpostref = lv_acpostref.

        MODIFY ENTITIES OF zi_pcrhdr IN LOCAL MODE
               ENTITY zi_pcrhdr
               UPDATE
               FIELDS ( accpostref )
               WITH VALUE #( FOR key IN keys
                             ( %tky           = gfs_header-%tky
                               accpostref     = gfs_header-accpostref
                             ) )
                FAILED DATA(failed1)
                REPORTED DATA(reported1).
      ENDIF.
    ENDIF.


  ENDMETHOD.

  METHOD upd.

    DATA: ls_sum TYPE dmbtr,
          lv_amt TYPE dmbtr.
    CLEAR : ls_sum,lv_amt.

    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
          ENTITY zi_pcrhdr
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_header)
          FAILED DATA(lt_header_failed).

    DATA(gfs_header) = VALUE #( lt_header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_pcrhdr
           BY \_item
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(it1).

     LOOP AT it1 INTO DATA(ls_it1).
      lv_amt = lv_amt + ls_it1-adjamt + ls_it1-otheramt.
    ENDLOOP.

    ls_sum = lv_amt.

    gfs_header-balanceamt = gfs_header-bookamt - ls_sum."ls_item-appl_amt_lc.

    MODIFY ENTITIES OF zi_pcrhdr IN LOCAL MODE
            ENTITY zi_pcrhdr
            UPDATE FIELDS ( balanceamt  )
            WITH VALUE #( ( %tky                  = gfs_header-%tky
                             balanceamt           = gfs_header-balanceamt
                             %control-balanceamt  = if_abap_behv=>mk-on
                        ) ).

   READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
            ENTITY zi_pcrhdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header_upd).

    result = VALUE #( FOR ls_header IN header_upd
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_pcritm DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_pcritm RESULT result.
    METHODS adjustdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_pcritm~adjustdetails.
    METHODS checkadj FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_pcritm~checkadj.
    METHODS adjustamt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_pcritm~adjustamt.
    METHODS adjusthedamt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_pcritm~adjusthedamt.
    METHODS upd_create FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_pcritm~upd_create.
*    METHODS deldata FOR DETERMINE ON SAVE
*      IMPORTING keys FOR zi_pcritm~deldata.


ENDCLASS.

CLASS lhc_zi_pcritm IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
            ENTITY zi_pcrhdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(header_failed).


    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_pcrhdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item).

    " LOOP AT item INTO DATA(gfs_item).

    result = VALUE #( FOR gfs_item IN item
   ( %tky                            = gfs_item-%tky

     %field-lcnumber                = COND #( WHEN ( gfs_item-adjustdoctype = 'INVOICE'
                                                     OR gfs_item-adjustdoctype = 'OTHERS' )
                                               THEN if_abap_behv=>fc-f-read_only
                                               ELSE if_abap_behv=>fc-o-enabled )

     %field-lcamt                   = COND #( WHEN ( gfs_item-adjustdoctype = 'INVOICE'
                                                   OR gfs_item-adjustdoctype = 'OTHERS' OR
                                                   gfs_item-adjustdoctype = 'LC')
                                               THEN if_abap_behv=>fc-f-read_only
                                               ELSE if_abap_behv=>fc-o-enabled )


     %field-invopenamt             = COND #( WHEN ( gfs_item-adjustdoctype = 'LC' OR gfs_item-adjustdoctype = 'INVOICE'
                                                    OR gfs_item-adjustdoctype = 'OTHERS' )
                                               THEN if_abap_behv=>fc-f-read_only
                                               ELSE if_abap_behv=>fc-o-enabled )

     %field-invno                   =  COND #( WHEN ( gfs_item-adjustdoctype = 'LC'
                                                     OR gfs_item-adjustdoctype = 'OTHERS' )
                                               THEN if_abap_behv=>fc-f-read_only
                                               ELSE if_abap_behv=>fc-o-enabled )

    %field-otheramt             =    COND #( WHEN ( gfs_item-adjustdoctype = 'INVOICE'
                                                    OR gfs_item-adjustdoctype = 'LC' )
                                               THEN if_abap_behv=>fc-f-read_only
                                               ELSE if_abap_behv=>fc-o-enabled )

     %field-othertext            =  COND #( WHEN ( gfs_item-adjustdoctype = 'INVOICE'
                                                     OR gfs_item-adjustdoctype = 'LC' )
                                               THEN if_abap_behv=>fc-f-read_only
                                               ELSE if_abap_behv=>fc-o-enabled )






    ) ).
    "    ENDLOOP.
    IF header IS INITIAL.
      RETURN.
    ENDIF.
  ENDMETHOD.

  METHOD adjustdetails.

    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
               ENTITY zi_pcrhdr
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(header_failed).


    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
           ENTITY zi_pcritm
           ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item).
    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

    IF gfs_item-invno IS NOT INITIAL .
      SELECT SINGLE * FROM zcds_invamt
     WHERE companycode = @gfs_item-cocode AND
           originalreferencedocument = @gfs_item-invno
       AND fiscalyear = @gfs_item-fiscalyear
      INTO @DATA(ls_doc).


      gfs_item-waers      = ls_doc-transactioncurrency.
      gfs_item-invopenamt = ls_doc-amount.
*      gfs_item-adjamt     = ls_doc-amount.  "//sm
      gfs_item-invdt      = ls_doc-documentdate.
    ENDIF.
    IF gfs_item-lcnumber IS NOT INITIAL.
      SELECT SINGLE * FROM zi_lcexphead
      WHERE companycode = @gfs_item-cocode AND lc_appl = @gfs_item-lcnumber
      INTO @DATA(ls_doc1).

      gfs_item-lcurr  = ls_doc1-waers.
      gfs_item-lcamt  = ls_doc1-lc_tot_amt_fc.
      gfs_item-lcdate = ls_doc1-lc_req_date.
    ENDIF.


    MODIFY ENTITIES OF zi_pcrhdr IN LOCAL MODE
     ENTITY zi_pcritm
     UPDATE FIELDS ( lcdate lcurr waers lcamt invopenamt invdt adjamt othercurr )
     WITH VALUE #( id = gfs_item-id
                   ( %tky       = gfs_item-%tky
                     invdt      = gfs_item-invdt
                     lcdate     = gfs_item-lcdate
                     waers      = gfs_item-waers
                     lcurr      = gfs_item-lcurr
                     lcamt      = gfs_item-lcamt
                     invopenamt = gfs_item-invopenamt
                     adjamt     = gfs_item-adjamt
                     othercurr  = gfs_header-waers

                   ) ).

*//--------- Update Balance Amount
    DATA: ls_sum TYPE dmbtr,
          lv_amt TYPE dmbtr.

    CLEAR: ls_sum,lv_amt.

    READ ENTITY zi_pcrhdr
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(it1).

    LOOP AT it1 INTO DATA(ls_it1).
      lv_amt = lv_amt + ls_it1-adjamt + ls_it1-otheramt.
    ENDLOOP.

    ls_sum = lv_amt.

    gfs_header-balanceamt = gfs_header-bookamt - ls_sum.

    MODIFY ENTITIES OF zi_pcrhdr IN LOCAL MODE
            ENTITY zi_pcrhdr
            UPDATE
                FIELDS ( balanceamt  )
                WITH VALUE #( ( %tky   = gfs_header-%tky
                                 balanceamt = gfs_header-balanceamt
                                 %control-balanceamt  = if_abap_behv=>mk-on
                               ) ).
  ENDMETHOD.

*  METHOD deldata.
*  READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
*           ENTITY zi_pcrhdr
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT FINAL(header)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           FAILED FINAL(header_failed).
*
*
*    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
*
*    READ ENTITY zi_pcrhdr
*          BY \_item
*          ALL FIELDS
*          WITH CORRESPONDING #( keys )
*          RESULT FINAL(item).
*
*    data(item1) = item[].
*  ENDMETHOD.

  METHOD checkadj.
    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
                ENTITY zi_pcrhdr
                ALL FIELDS
                WITH CORRESPONDING #( keys )
                RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_pcrhdr " IN LOCAL MODE
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(item).

*------------------------------------------------------------------*
    LOOP AT item INTO DATA(gfs_item).
      IF gfs_item-waers IS NOT INITIAL.
        IF ( gfs_header-waers <> gfs_item-waers ) .
          DATA(lv_msg) = |Loan Currency & | && gfs_item-adjustdoctype && | Currency is mismatched| .
          APPEND VALUE #( %tky = gfs_item-%tky ) TO failed-zi_pcrhdr.

          APPEND VALUE #( %tky        = gfs_item-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
          TO reported-zi_pcrhdr.
        ENDIF.
      ENDIF.
      IF gfs_item-lcurr IS NOT INITIAL.
        IF ( gfs_header-waers <> gfs_item-lcurr ) .
          DATA(lv_msg1) = |Loan Currency & | && gfs_item-adjustdoctype && | Currency is mismatched| .
          APPEND VALUE #( %tky = gfs_item-%tky ) TO failed-zi_pcrhdr.

          APPEND VALUE #( %tky        = gfs_item-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg1 ) )
          TO reported-zi_pcrhdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD adjustamt.

***    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
***                 ENTITY zi_pcrhdr
***                 ALL FIELDS
***                 WITH CORRESPONDING #( keys )
***                 RESULT FINAL(header)
***                 " TODO: variable is assigned but never used (ABAP cleaner)
***                 FAILED FINAL(header_failed).
***
***
***    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
***
***    READ ENTITY zi_pcrhdr
***          BY \_item
***          ALL FIELDS
***          WITH CORRESPONDING #( keys )
***          RESULT FINAL(item).
***    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).
***
***
***    IF gfs_item-adjustdoctype = 'INVOICE'.
****      gfs_item-adjamt = gfs_item-invopenamt.
***    ELSEIF gfs_item-adjustdoctype = 'OTHERS'.
***      gfs_item-adjamt = gfs_item-otheramt.
***    ENDIF.
***
***    MODIFY ENTITIES OF zi_pcrhdr IN LOCAL MODE
***    ENTITY zi_pcritm
***    UPDATE FIELDS ( adjamt  )
***    WITH VALUE #( id = gfs_item-id
***                  ( %tky    = gfs_item-%tky
***                    adjamt  = gfs_item-adjamt
***
***                  ) ).

  ENDMETHOD.

  METHOD adjusthedamt.

    DATA: ls_sum TYPE dmbtr,
          lv_amt TYPE dmbtr.

    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
                 ENTITY zi_pcrhdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(header_failed).


    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).


    READ ENTITY zi_pcrhdr
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_itm).

    lv_amt = REDUCE dmbtr( INIT lv_itm TYPE dmbtr FOR ls_itm IN lt_itm
                              NEXT lv_itm = lv_itm + ls_itm-adjamt ) .

    gfs_header-balanceamt = gfs_header-bookamt - lv_amt .

    MODIFY ENTITIES OF zi_pcrhdr IN LOCAL MODE
            ENTITY zi_pcrhdr
            UPDATE
            FIELDS ( balanceamt  )
            WITH VALUE #( ( %tky                 = gfs_header-%tky
                            balanceamt           = gfs_header-balanceamt
                            %control-balanceamt  = if_abap_behv=>mk-on
                               ) ).
  ENDMETHOD.

  METHOD upd_create.

    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
               ENTITY zi_pcrhdr
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(header_failed).
    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_pcrhdr
            BY \_item
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_itm).

    LOOP AT lt_itm INTO DATA(gfs_item).

      IF gfs_item-invno IS NOT INITIAL .
        SELECT SINGLE * FROM zcds_invamt
       WHERE companycode = @gfs_item-cocode AND
             originalreferencedocument = @gfs_item-invno AND
             fiscalyear = @gfs_item-fiscalyear
        INTO @DATA(ls_doc).

        gfs_item-invopenamt = ls_doc-amount.
        gfs_item-invdt      = ls_doc-documentdate.
      ENDIF.

      MODIFY ENTITIES OF zi_pcrhdr IN LOCAL MODE
       ENTITY zi_pcritm
       UPDATE FIELDS ( invopenamt invdt )
       WITH VALUE #( id = gfs_item-id
                     ( %tky       = gfs_item-%tky
                       invdt      = gfs_item-invdt
                       lcdate     = gfs_item-lcdate
                     ) ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_pcritm1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_pcritm1 RESULT result.
    METHODS checksofr FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_pcritm1~checksofr.

ENDCLASS.

CLASS lhc_zi_pcritm1 IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD checksofr.
    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
              ENTITY zi_pcrhdr
              ALL FIELDS
              WITH CORRESPONDING #( keys )
              RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_pcrhdr " IN LOCAL MODE
         BY \_item1
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(item1).

    DATA(gfs_item1) = VALUE #( item1[ 1 ]  OPTIONAL ).

    IF ( gfs_header-benchmarktype = 'SOFR' OR gfs_header-benchmarktype ='EURO' )
    AND gfs_item1-sofr IS INITIAL .
      SELECT SINGLE * FROM zdt_pcr_sofritm
      WHERE id         = @gfs_item1-id
     INTO @DATA(ls_del).
      IF ls_del IS INITIAL.
        DATA(lv_msg) = |Please Maintain | && gfs_header-benchmarktype && | Interest Rate| .
        APPEND VALUE #( %tky = gfs_item1-%tky ) TO failed-zi_pcrhdr.

        APPEND VALUE #( %tky        = gfs_item1-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_pcrhdr.
      ENDIF.
    ENDIF.



  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_pcritm2 DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS sorddetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_pcritm2~sorddetails.
    METHODS checksord FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_pcritm2~checksord.

ENDCLASS.

CLASS lhc_zi_pcritm2 IMPLEMENTATION.

  METHOD sorddetails.

    DATA: lv_sono TYPE vbeln_va.
*---------------------------------------------------------------------------------*
    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
              ENTITY zi_pcrhdr
              ALL FIELDS
              WITH CORRESPONDING #( keys )
              RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_pcrhdr
          BY \_item2
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item2).

    DATA(gfs_item2) = VALUE #( item2[ 1 ]  OPTIONAL ).
*---------------------------------------------------------------------------------*
    lv_sono = |{ gfs_item2-sordno ALPHA = IN }|.
    gfs_item2-sordno = lv_sono .

    IF gfs_header-basedoctype = 'SALES ORDER'.

      SELECT SINGLE * FROM i_salesorder
       WHERE salesorder = @gfs_item2-sordno
       INTO @DATA(ls_so_det).
      IF sy-subrc = 0.
        gfs_item2-sorddt   = ls_so_det-salesorderdate.
        gfs_item2-payterm  = ls_so_det-customerpaymentterms.
        gfs_item2-cuscode  = ls_so_det-soldtoparty.
        gfs_item2-basicamt = ls_so_det-totalnetamount.
        gfs_item2-waers    = ls_so_det-transactioncurrency.
      ENDIF.

    ELSEIF gfs_header-basedoctype = 'SALES CONTRACT'.

      SELECT SINGLE * FROM i_salescontract
       WHERE salescontract = @gfs_item2-sordno
       INTO @DATA(ls_cont_det).
      IF sy-subrc = 0.
        gfs_item2-sorddt   = ls_cont_det-salescontractdate.
        gfs_item2-payterm  = ls_cont_det-customerpaymentterms.
        gfs_item2-cuscode  = ls_cont_det-soldtoparty.
        gfs_item2-basicamt = ls_cont_det-totalnetamount.
        gfs_item2-waers    = ls_cont_det-transactioncurrency.
      ENDIF.

    ENDIF.

    IF gfs_item2 IS NOT INITIAL.

      MODIFY ENTITIES OF zi_pcrhdr IN LOCAL MODE
           ENTITY zi_pcritm2
           UPDATE FIELDS ( basicamt cuscode payterm sorddt waers )
           WITH VALUE #( id = gfs_item2-id
                         ( %tky          = gfs_item2-%tky
                           payterm       = gfs_item2-payterm
                           sorddt        = gfs_item2-sorddt
                           waers         = gfs_item2-waers
                           basicamt      = gfs_item2-basicamt
                           cuscode       = gfs_item2-cuscode
                         ) ).
    ENDIF.

  ENDMETHOD.

  METHOD checksord.
    DATA: lv_msg TYPE string .
*------------------------------------------------------------------------------*
    READ ENTITIES OF zi_pcrhdr IN LOCAL MODE
                ENTITY zi_pcrhdr
                ALL FIELDS
                WITH CORRESPONDING #( keys )
                RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_pcrhdr " IN LOCAL MODE
         BY \_item2
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(item2).
*------------------------------------------------------------------------------*

    LOOP AT item2 INTO DATA(gfs_item2).

      DATA(lt_item2check) = item2.
      DELETE lt_item2check WHERE sordno <> gfs_item2-sordno .
      IF lines( lt_item2check ) > 1 .

        lv_msg = |SO-| && gfs_item2-sordno && ' Alreay use' .
        APPEND VALUE #( %tky = gfs_item2-%tky ) TO failed-zi_pcrhdr.

        APPEND VALUE #( %tky        = gfs_item2-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_pcrhdr.
      ENDIF.

      IF gfs_header-waers <> gfs_item2-waers.
        lv_msg = |Loan Currency & Salesorder Currency is mismatched| .
        APPEND VALUE #( %tky = gfs_item2-%tky ) TO failed-zi_pcrhdr.

        APPEND VALUE #( %tky        = gfs_item2-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_pcrhdr.
      ENDIF.
      "---------- Sales Order Amount Check ----"
      IF gfs_item2-sordno IS NOT INITIAL .
        IF gfs_item2-basicamt < gfs_item2-applicableamt .
          lv_msg = | Apply Amount more then SO-| && gfs_item2-sordno && | Basic Amount |.
          APPEND VALUE #( %tky = gfs_item2-%tky ) TO failed-zi_pcrhdr.

          APPEND VALUE #( %tky        = gfs_item2-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg
                                                                ) )
          TO reported-zi_pcrhdr.
        ENDIF.
      ENDIF.

*      IF gfs_item2-sordno is NOT INITIAL.
*      IF gfs_header-basedoctype = 'SALES ORDER'.
*        lv_msg = |Loan Currency & Salesorder Currency is mismatched| .
*        APPEND VALUE #( %tky = gfs_item2-%tky ) TO failed-zi_pcrhdr.
*
*        APPEND VALUE #( %tky        = gfs_item2-%tky
*                        %state_area = 'Validate_Head'
*                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                             text     = lv_msg ) )
*        TO reported-zi_pcrhdr.
*      ENDIF.
*    ENDIF.



    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
