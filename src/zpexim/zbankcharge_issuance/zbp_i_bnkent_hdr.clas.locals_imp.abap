CLASS lsc_zi_bnkent_hdr DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_bnkent_hdr IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_bnkent_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bnkent_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_bnkent_hdr RESULT result.

*    METHODS updateval FOR DETERMINE ON SAVE
*      IMPORTING keys FOR zi_bnkent_hdr~updateval.

*    METHODS getamount FOR DETERMINE ON Modify
*      IMPORTING keys FOR zi_bnkent_hdr~getamount.
    METHODS checkdetails FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_bnkent_hdr~checkdetails.
    METHODS updatedetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_bnkent_hdr~updatedetails.

    METHODS post FOR MODIFY
      IMPORTING keys FOR ACTION zi_bnkent_hdr~post RESULT result.

    METHODS postdoc FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_bnkent_hdr~postdoc.

    METHODS updatedet FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_bnkent_hdr~updatedet.

*    METHODS updateamt FOR DETERMINE ON SAVE
*      IMPORTING keys FOR zi_bnkent_hdr~updateamt.

    METHODS hed_taxcal FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_bnkent_hdr~hed_taxcal.

    METHODS hed_bankref FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_bnkent_hdr~hed_bankref.

ENDCLASS.

CLASS lhc_zi_bnkent_hdr IMPLEMENTATION.

  METHOD get_instance_features.
    DATA: lv_post_active TYPE char1.

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
               ENTITY zi_bnkent_hdr
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    CLEAR:lv_post_active.

    result = VALUE #( FOR ls_header IN header
                     (
                          %tky             = gfs_header-%tky
                          %action-post     =  COND #( WHEN ls_header-tpost = 'X'
                                                     THEN if_abap_behv=>fc-o-disabled
                                                     ELSE if_abap_behv=>fc-o-enabled
                                                    )
                          %action-edit     =  COND #( WHEN ls_header-tpost = 'X'
                                                     THEN if_abap_behv=>fc-o-disabled
                                                     ELSE if_abap_behv=>fc-o-enabled
                                                    )
                      ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD checkdetails.
    DATA : lv_msg1 TYPE char100.

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
               ENTITY zi_bnkent_hdr
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_bnkent_hdr
          BY \_item
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(item).

    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

    IF gfs_header-taxcode IS INITIAL.
      lv_msg1 = |Please Maintain Tax code From F4 Help|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg1 ) )
      TO reported-zi_bnkent_hdr.
    ENDIF.

    IF gfs_header-taxcode IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_bnktaxcode WHERE taxcode = @gfs_header-taxcode INTO @DATA(lv_abap_true).
      IF sy-subrc <> 0 .
        lv_msg1 = |Please Check Header Tax code|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_bnkent_hdr.
      ENDIF.
    ENDIF.

    IF gfs_header-bnkadviceno IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_bnk_ent_hdr
      WHERE bnkadviceno = @gfs_header-bnkadviceno AND id <> @gfs_header-id
      INTO @DATA(ls_del2).
      IF ls_del2 IS NOT INITIAL.

        lv_msg1 = |Record Already Exists For The Same Bank Advice No|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_bnkent_hdr.
      ENDIF.
    ENDIF.
    IF gfs_header-bnkadviceno IS INITIAL.
      DATA(lv_msg2) = |Bank Advice Number Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg2 ) )
      TO reported-zi_bnkent_hdr.

    ENDIF.
    IF gfs_header-docdate IS INITIAL.
      DATA(lv_msg3) = |Document Date Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg3 ) )
      TO reported-zi_bnkent_hdr.

    ENDIF.
    IF gfs_header-postingdate IS INITIAL.
      DATA(lv_msg4) = |Posting Date Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg4 ) )
      TO reported-zi_bnkent_hdr.

    ENDIF.

*- SOC: Posting date as per User input: 23.04.25 :SM
    IF gfs_header-docdate IS NOT INITIAL AND gfs_header-postingdate IS NOT INITIAL.
      IF gfs_header-docdate > gfs_header-postingdate .
        lv_msg1 = |DocumnetDate greater then PostDate|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_bnkent_hdr.
      ENDIF.
    ENDIF.
*- SOC: Posting date as per User input: 23.04.25 :SM

    IF gfs_header-housebank IS INITIAL.
      DATA(lv_msg5) = |House Bank Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg5 ) )
      TO reported-zi_bnkent_hdr.

    ENDIF.
    IF gfs_header-accountid IS INITIAL.
      lv_msg5 = |Account Id Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg5 ) )
      TO reported-zi_bnkent_hdr.

    ENDIF.
    IF gfs_header-accountid IS INITIAL.
      DATA(lv_msg6) = |Account Id Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg6 ) )
      TO reported-zi_bnkent_hdr.
    ENDIF.
    IF gfs_header-currency IS INITIAL.
      DATA(lv_msg7) = |Currency Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg7 ) )
      TO reported-zi_bnkent_hdr.
    ENDIF.
    IF gfs_header-taxcode IS INITIAL.
      DATA(lv_msg8) = |Tax Code Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg8 ) )
      TO reported-zi_bnkent_hdr.
    ENDIF.
    IF gfs_header-postingdate IS INITIAL.
      DATA(lv_msg9) = |Posting Date Is Mandatory|.
      APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

      APPEND VALUE #( %tky        = gfs_header-%tky
                      %state_area = 'Validate_Header'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg9 ) )
      TO reported-zi_bnkent_hdr.
    ENDIF.


  ENDMETHOD.

  METHOD updatedetails.

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
                 ENTITY zi_bnkent_hdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
*- SOC: Posting date as per User input: 23.04.25 :SM
**    MODIFY ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
**                    ENTITY zi_bnkent_hdr
**                    UPDATE
**                    FIELDS ( postingdate )
**                    WITH VALUE #( FOR key IN keys
**                                  ( %tky       = gfs_header-%tky
**                                    postingdate = sy-datlo
***                                    invyear     = gfs_header-invyear
***                                    Accountid   = gfs_header-Accountid
**                                    %control-postingdate   = if_abap_behv=>mk-on
***                                    %control-invyear   = if_abap_behv=>mk-on
***                                    %control-Accountid   = if_abap_behv=>mk-on
**                                     ) ).
*- EOC: Posting date as per User input: 23.04.25 :SM
  ENDMETHOD.


  METHOD post.

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
      ENTITY zi_bnkent_hdr
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      FAILED DATA(lt_header_failed).

    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<fs_head>) .
      IF <fs_head> IS ASSIGNED.

        <fs_head>-tpostupd = 'X'.
        MODIFY ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
               ENTITY zi_bnkent_hdr
               UPDATE
               FIELDS ( tpostupd )
               WITH VALUE #( FOR key IN keys
                             ( %tky          = <fs_head>-%tky
                               tpostupd          = <fs_head>-tpostupd
                               %control-tpost = if_abap_behv=>mk-on
                             ) )
                FAILED DATA(failed1)
                REPORTED DATA(reported1).

        " Fill the response table
        READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
             ENTITY  zi_bnkent_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header_1).

        result = VALUE #( FOR ls_header IN header_1
                          ( %tky   = ls_header-%tky
                            %param = ls_header ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD postdoc.

    DATA : lv_text      TYPE string,
           lv_acpostref TYPE c LENGTH 26,
           lv_date      TYPE datn,
           lv_time      TYPE timn.

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

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
       ENTITY zi_bnkent_hdr
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(lt_header)
       FAILED DATA(lt_header_failed).

    DATA(gfs_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    READ ENTITY zi_bnkent_hdr
     BY \_item
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item1)
    FAILED DATA(lt_item_failed1).

    READ ENTITY zi_bnkent_hdr
      BY \_item1
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_item2)
     FAILED DATA(lt_item_failed2).

    READ ENTITY zi_bnkent_hdr
    BY \_item2
   ALL FIELDS
   WITH CORRESPONDING #( keys )
   RESULT DATA(lt_item3)
   FAILED DATA(lt_item_failed3).

*//--------------------------------------------------------------------------//

***    SELECT SINGLE * FROM zi_bnkent_hdr
***    INTO @DATA(ls_entry).
    DATA(ls_entry) = gfs_header.

    SELECT SINGLE companycode FROM i_companycode WHERE CompanyCode = '1000'
    INTO @DATA(lv_cocode).

    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lv_cid     TYPE abp_behv_cid.

    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

    FREE: gt_glitems,gt_gltax.

    CLEAR gs_glitems.

    gs_glitems = VALUE #(  glaccount         = gfs_header-bankglacc
                            amt              = ( gfs_header-tot_amt * -1 )
                            waers            = gfs_header-currency
                            housebank        = ls_entry-housebank
                            housebankaccount = ls_entry-accountid ).


    APPEND gs_glitems TO gt_glitems.

    DATA(lt_glitems) = gt_glitems[].

    gt_glitems = CORRESPONDING #( lt_item1 MAPPING chargehed  = chargehed1
                                                   amt        = amt1
                                                   glaccount  = glaccount1
                                                   taxc       = taxc1
                                                   status     = status1
                                                   costcenter = costcenter1
                                                   status1     = status1 ).
    APPEND LINES OF gt_glitems TO lt_glitems.
    FREE gt_glitems.

    gt_glitems = CORRESPONDING #( lt_item2 MAPPING chargehed  = chargehed2
                                                   amt        = amt2
                                                   glaccount  = glaccount2
                                                   taxc       = taxc2
                                                   status     = status2
                                                   costcenter = costcenter2
                                                   status1     = status2 ).

    APPEND LINES OF gt_glitems TO lt_glitems.
    FREE gt_glitems.

    gt_glitems = CORRESPONDING #( lt_item3 MAPPING chargehed  = chargehed3
                                                   amt        = amt3
                                                   glaccount  = glaccount3
                                                   taxc       = taxc3
                                                   status     = status3
                                                   costcenter = costcenter3
                                                   status1     = status3 ).

    APPEND LINES OF gt_glitems TO lt_glitems.
    FREE gt_glitems.

    DATA(lt_glitems_tmp) = lt_glitems.
    DELETE lt_glitems_tmp WHERE status1 IS INITIAL .

    LOOP AT lt_glitems_tmp INTO gs_glitems .
      gs_glitems-amt = gs_glitems-amt * -1 .
      gs_glitems-taxc = '' .
      APPEND gs_glitems TO gt_glitems.
      CLEAR gs_glitems .
    ENDLOOP.

    APPEND LINES OF gt_glitems TO lt_glitems.
    FREE: gt_glitems.

*//-- Set Sl no---
    lv_num = 1.
    LOOP AT lt_glitems ASSIGNING FIELD-SYMBOL(<fs_glitems>).
      <fs_glitems>-lv_num = lv_num.
      IF <fs_glitems>-taxc IS NOT INITIAL .
        <fs_glitems>-lv_numtax = lv_num.
      ENDIF.
      lv_num += 1.

    ENDLOOP.

*//-- Get Tax Line ---
    CHECK lt_glitems IS NOT INITIAL .

    DATA(lt_taxline) = lt_glitems .
    DELETE lt_taxline WHERE taxc IS INITIAL .


    LOOP AT lt_taxline INTO DATA(ls_glitem).
      IF ls_glitem-taxc IS NOT INITIAL.
        SELECT SINGLE * FROM zdt_bnktaxcode WHERE taxcode = @ls_glitem-taxc INTO @DATA(ls_bnktaxcode).
        IF sy-subrc EQ 0.
          IF ls_bnktaxcode-cgst IS NOT INITIAL.
            gs_gltax-glaccountlineitem      = lv_num .
            gs_gltax-taxcode                = ls_glitem-taxc .
            gs_gltax-conditiontype          = 'JICG' .
            gs_gltax-taxitemacctgdocitemref = ls_glitem-lv_numtax .
            gs_gltax-taxrate                = ls_bnktaxcode-cgst.
            gs_gltax-journalentryitemamount = ( ls_bnktaxcode-cgst * ls_glitem-amt ) / 100.
            gs_gltax-currency               = ls_glitem-waers.
            gs_gltax-taxbaseamount          = ls_glitem-amt.
            APPEND gs_gltax TO gt_gltax .
            CLEAR gs_gltax.
            lv_num += 1.
          ENDIF.

          IF ls_bnktaxcode-sgst IS NOT INITIAL.

            gs_gltax-glaccountlineitem      = lv_num .
            gs_gltax-taxcode                = ls_glitem-taxc .
            gs_gltax-conditiontype          = 'JISG' .
            gs_gltax-taxitemacctgdocitemref = ls_glitem-lv_numtax .
            gs_gltax-taxrate                = ls_bnktaxcode-sgst.
            gs_gltax-journalentryitemamount = ( ls_bnktaxcode-sgst * ls_glitem-amt ) / 100.
            gs_gltax-currency               = ls_glitem-waers.
            gs_gltax-taxbaseamount          = ls_glitem-amt.
            APPEND gs_gltax TO gt_gltax .
            CLEAR gs_gltax.
            lv_num += 1.
          ENDIF.

          IF ls_bnktaxcode-igst IS NOT INITIAL.

            gs_gltax-glaccountlineitem      = lv_num .
            gs_gltax-taxcode                = ls_glitem-taxc .
            gs_gltax-conditiontype          = 'JIIG' .
            gs_gltax-taxitemacctgdocitemref = ls_glitem-lv_numtax .
            gs_gltax-taxrate                = ls_bnktaxcode-igst.
            gs_gltax-journalentryitemamount = ( ls_bnktaxcode-igst * ls_glitem-amt ) / 100.
            gs_gltax-currency               = ls_glitem-waers.
            gs_gltax-taxbaseamount          = ls_glitem-amt.
            APPEND gs_gltax TO gt_gltax .
            CLEAR gs_gltax.
            lv_num += 1.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

*//-- Update Tax Amount in Debit  Line ---
    IF gt_gltax[] IS NOT INITIAL.
      CLEAR lv_taxamt.
      lv_taxamt = REDUCE dmbtr( INIT lv_tax TYPE dmbtr FOR ls_tax IN gt_gltax
                                NEXT lv_tax = lv_tax + ls_tax-journalentryitemamount ) .

***      lv_waivoff = REDUCE dmbtr( INIT lv_off TYPE dmbtr FOR ls_off IN lt_glitems_tmp
***                                NEXT lv_off = lv_off + ls_off-amt ) .

      IF lv_taxamt IS NOT INITIAL.
        READ TABLE lt_glitems ASSIGNING FIELD-SYMBOL(<fs_glitm>) INDEX 1 .
        <fs_glitm>-amt = <fs_glitm>-amt + ( lv_taxamt * -1 ) .
      ENDIF.
    ENDIF.

*//------------------Get Date Time from Time Stamp -----------//
    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
    lv_acpostref = 'Bank_Charges-' && lv_time.


*//-- Set Final Journal Entry line ---
    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
    <je_deep>-%cid = lv_cid.
    <je_deep>-%param = VALUE #(
                        companycode                  = lv_cocode
                        documentreferenceid          = ls_entry-bnkadviceno
                        businesstransactiontype      = 'RFBU'
                        accountingdocumenttype       = 'SA'
                        createdbyuser                = sy-uname
                        documentdate                 = ls_entry-docdate
                        postingdate                  = ls_entry-postingdate
                        accountingdocumentheadertext = lv_acpostref
                        taxdeterminationdate         = sy-datlo

                        _glitems                     = VALUE #( FOR ls_item1 IN lt_glitems
                                                                 ( housebank              = ls_item1-housebank
                                                                   housebankaccount       = ls_item1-housebankaccount
                                                                   glaccountlineitem      = ls_item1-lv_num
                                                                   glaccount              = ls_item1-glaccount
                                                                   businessplace          = ls_entry-busiplace
                                                                   taxcode                = ls_item1-taxc
                                                                   taxitemacctgdocitemref = ls_item1-lv_numtax
                                                                   costcenter             = ls_item1-costcenter
                                                                   assignmentreference    = gfs_header-invno


                                                                  _currencyamount   = VALUE #( ( currencyrole           = '00'
                                                                                                 journalentryitemamount = ls_item1-amt
                                                                                                 taxbaseamount          = ls_item1-amt
                                                                                                 currency               = ls_item1-waers ) )
                                                                   ) )

                        _taxitems                      = VALUE #(  FOR ls_taxline IN gt_gltax
                                                                  ( glaccountlineitem     = ls_taxline-glaccountlineitem
                                                                   taxcode                = ls_taxline-taxcode
                                                                   conditiontype          = ls_taxline-conditiontype
                                                                   taxitemacctgdocitemref = ls_taxline-taxitemacctgdocitemref
                                                                   taxrate                = ls_taxline-taxrate

                                                                  _currencyamount   = VALUE #( ( currencyrole           = '00'
                                                                                                 journalentryitemamount = ls_taxline-journalentryitemamount
                                                                                                 currency               = ls_taxline-currency
                                                                                                 taxbaseamount          = ls_taxline-taxbaseamount
                                                                                                 ) )
                                                                   ) )
                                   ).

*//--------------------------------------------------------------------------//

    DATA: lt_je_val TYPE TABLE FOR FUNCTION IMPORT i_journalentrytp~validate.
    DATA: lv_msg TYPE string.

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
*        DATA(lv_result01) = <ls_reported_deep01>-%msg->if_message~get_text( ).

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Error_Message'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_bnkent_hdr.
        CLEAR lv_msg.
      ENDLOOP.

      TRY.
          DATA(lv_item) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
          " handle exception
      ENDTRY.

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
          DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
          IF sy-tabix = 1.
            lv_text = lv_result.
          ELSE.
            lv_text = |{ lv_text } / { lv_result }| .
          ENDIF.
        ENDLOOP.
      ELSE. "---Success

        gfs_header-tpost      = 'X'.
        gfs_header-accpostref = lv_acpostref.
        MODIFY ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
               ENTITY zi_bnkent_hdr
               UPDATE
               FIELDS ( tpost accpostref )
               WITH VALUE #( FOR key IN keys
                             ( %tky           = gfs_header-%tky
                               tpost          = gfs_header-tpost
                               accpostref     = gfs_header-accpostref

                               %control-tpost      = if_abap_behv=>mk-on
                               %control-accpostref = if_abap_behv=>mk-on
                             ) )
                FAILED DATA(failed1)
                REPORTED DATA(reported1).
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD updatedet.


  ENDMETHOD.

*  METHOD updateamt.
*
*  ENDMETHOD.

  METHOD hed_taxcal.
    DATA: lv_itmrate  TYPE dmbtr,
          lv_itmrate1 TYPE dmbtr,
          lv_itmrate2 TYPE dmbtr,
          lv_sum      TYPE dmbtr.

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
          ENTITY zi_bnkent_hdr
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

***    IF gfs_header-tot_amt IS NOT INITIAL AND gfs_header-taxcode IS NOT INITIAL .


    SELECT SINGLE * FROM zdt_bnktaxcode WHERE taxcode = @gfs_header-taxcode INTO @DATA(ls_bnktaxcode).
    IF sy-subrc EQ 0 .
      CLEAR gfs_header-amountwithtax .
*------------------------------------------------------------------------------------------

      READ ENTITY zi_bnkent_hdr
               BY \_item
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT DATA(lt_item).

      READ ENTITY zi_bnkent_hdr
              BY \_item1
              ALL FIELDS
              WITH CORRESPONDING #( keys )
              RESULT DATA(lt_item1).


      READ ENTITY zi_bnkent_hdr
            BY \_item2
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT DATA(lt_item2).

      lv_itmrate = REDUCE dmbtr( INIT lv_val TYPE dmbtr FOR ls_itm IN lt_item
                                                         NEXT lv_val = lv_val + ls_itm-amt1 ) .
      lv_itmrate1 = REDUCE dmbtr( INIT lv_val1 TYPE dmbtr FOR ls_itm1 IN lt_item1
                                                         NEXT lv_val1 = lv_val1 + ls_itm1-amt2 ) .
      lv_itmrate2 = REDUCE dmbtr( INIT lv_val2 TYPE dmbtr FOR ls_itm2 IN lt_item2
                                                         NEXT lv_val2 = lv_val2 + ls_itm2-amt3 ) .

      lv_sum = lv_itmrate + lv_itmrate1 + lv_itmrate2.
*------------------------------------------------------------------------------------------

      IF ls_bnktaxcode-cgst IS NOT INITIAL OR ls_bnktaxcode-sgst IS NOT INITIAL.
        gfs_header-amountwithtax = ( lv_sum * ls_bnktaxcode-cgst ) * 2 / 100.

      ELSEIF ls_bnktaxcode-igst IS NOT INITIAL.
        gfs_header-amountwithtax = ( lv_sum * ls_bnktaxcode-cgst )  / 100.
      ENDIF.

      gfs_header-amountwithtax = gfs_header-amountwithtax + gfs_header-tot_amt .

      MODIFY ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
                ENTITY zi_bnkent_hdr
                UPDATE FIELDS ( amountwithtax )
                WITH VALUE #( ( %tky                   = gfs_header-%tky
                                amountwithtax          = gfs_header-amountwithtax
                                %control-amountwithtax = if_abap_behv=>mk-on
                            ) )
                FAILED DATA(failed_1)
                REPORTED DATA(reported_1)
                MAPPED DATA(mapped_1).
    ENDIF.
***    ENDIF.

  ENDMETHOD.

  METHOD hed_bankref.

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
        ENTITY zi_bnkent_hdr
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    IF gfs_header-invno IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_comm_hed WHERE commid = @gfs_header-invno INTO @DATA(ls_comhed).
      IF sy-subrc EQ 0.
        gfs_header-bankrefno = ls_comhed-bankrefno.
      ENDIF.

      MODIFY ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
                    ENTITY zi_bnkent_hdr
                    UPDATE FIELDS ( bankrefno )
                    WITH VALUE #( ( %tky               = gfs_header-%tky
                                    bankrefno          = gfs_header-bankrefno
                                    %control-bankrefno = if_abap_behv=>mk-on
                                ) )
                    FAILED DATA(failed_1)
                    REPORTED DATA(reported_1)
                    MAPPED DATA(mapped_1).
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_bnkent_bg_i DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bnkent_bg_i RESULT result.
    METHODS bgdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_bnkent_bg_i~bgdetails.
    METHODS checkbg FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_bnkent_bg_i~checkbg.
    METHODS bg_upateamt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_bnkent_bg_i~bg_upateamt.
    METHODS checkbg_upd FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_bnkent_bg_i~checkbg_upd.

ENDCLASS.

CLASS lhc_zi_bnkent_bg_i IMPLEMENTATION.

  METHOD get_instance_features.


  ENDMETHOD.

  METHOD bgdetails.


    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
            ENTITY zi_bnkent_hdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
            ENTITY zi_bnkent_bg_i
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(item2).

*    READ ENTITY zi_bnkent_hdr
*           BY \_item2
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT DATA(item2).

    DATA(gfs_item2) = VALUE #( item2[ 1 ]  OPTIONAL ).

    SELECT DISTINCT
           a~chargehead2 , a~rate2,
           b~glcode,b~bnkchargename
     FROM zdt_bnkrate_hdr AS c
     INNER JOIN zdt_bnkbg_itm AS a ON a~id = c~id
     LEFT OUTER JOIN zdt_bnkch_hdr AS b ON a~chargehead2 = b~bnkchargename
     WHERE c~bankname = @gfs_header-bank AND
           category = 'BG' AND
           active = 'X'
     INTO TABLE @DATA(lt_bg).

    DELETE ADJACENT DUPLICATES FROM lt_bg COMPARING bnkchargename .

    LOOP AT item2 INTO DATA(ls_item2) ."ASSIGNING FIELD-SYMBOL(<fs_item2>).

      LOOP AT lt_bg INTO DATA(ls_bg) WHERE chargehead2 = ls_item2-chargehed3.
        IF ls_item2-amt3 IS INITIAL.
          ls_item2-amt3         = ls_bg-rate2.
        ENDIF.
        IF ls_item2-glaccount3 IS INITIAL.
          ls_item2-glaccount3   = ls_bg-glcode.
        ENDIF.

        MODIFY ENTITIES OF zi_bnkent_hdr   IN LOCAL MODE
                          ENTITY zi_bnkent_bg_i
                          UPDATE
                          FIELDS ( glaccount3 taxc3 amt3 waers )
                          WITH VALUE #( FOR key IN keys
                                        ( %tky                = ls_item2-%tky
                                          amt3                = ls_item2-amt3
                                          taxc3               = gfs_header-taxcode
                                          waers               = gfs_header-currency
                                          glaccount3          = ls_item2-glaccount3

                                          %control-amt3       = if_abap_behv=>mk-on
                                          %control-taxc3      = if_abap_behv=>mk-on
                                          %control-waers      = if_abap_behv=>mk-on
                                          %control-glaccount3 = if_abap_behv=>mk-on
                                           ) ).

      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD checkbg.

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
            ENTITY zi_bnkent_hdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header).

    READ ENTITY zi_bnkent_hdr " IN LOCAL MODE
          BY \_item2
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(bnkbgitm).


    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    LOOP AT bnkbgitm INTO DATA(gfs_bnkbgitm) .

      DATA(lt_tmp) = bnkbgitm .
      DELETE lt_tmp WHERE chargehed3 <> gfs_bnkbgitm-chargehed3.
      IF lines( lt_tmp ) > 1.

**      IF gfs_bnkbgitm-chargehed3 IS NOT INITIAL.
**        SELECT SINGLE * FROM zdt_bnk_en_bg_i
**        WHERE id         = @gfs_bnkbgitm-id AND
**             chargehed3 = @gfs_bnkbgitm-chargehed3
**        INTO @DATA(ls_del).
**
**
**        IF ls_del IS NOT INITIAL.

        DATA(lv_msg1) = |Duplicate Entry For | &&  gfs_bnkbgitm-chargehed3 && | For BG|.
        APPEND VALUE #( %tky = gfs_bnkbgitm-%tky ) TO failed-zi_bnkent_hdr.

        APPEND VALUE #( %tky        = gfs_bnkbgitm-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_bnkent_hdr.
**        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD checkbg_upd.

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
            ENTITY zi_bnkent_hdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header).

    READ ENTITY zi_bnkent_hdr " IN LOCAL MODE
          BY \_item2
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(bnkbgitm).


    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    LOOP AT bnkbgitm INTO DATA(gfs_bnkbgitm) .

      IF gfs_bnkbgitm-costcenter3 IS INITIAL.
        DATA(lv_msg) = |Please Enter Cost Center|.
        APPEND VALUE #( %tky = gfs_bnkbgitm-%tky ) TO failed-zi_bnkent_hdr.

        APPEND VALUE #( %tky        = gfs_bnkbgitm-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_bnkent_hdr.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD bg_upateamt.

    DATA: lv_itmrate  TYPE dmbtr,
          lv_itmrate1 TYPE dmbtr,
          lv_itmrate2 TYPE dmbtr,
          lv_sum      TYPE dmbtr.

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
          ENTITY zi_bnkent_hdr
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_bnkent_hdr
             BY \_item
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT DATA(lt_item).

    READ ENTITY zi_bnkent_hdr
            BY \_item1
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT DATA(lt_item1).


    READ ENTITY zi_bnkent_hdr
          BY \_item2
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_item2).

    lv_itmrate  = REDUCE dmbtr( INIT lv_val TYPE dmbtr FOR ls_itm IN lt_item WHERE ( status1 = '' OR status1 = 'NO')
                                                       NEXT lv_val = lv_val + ls_itm-amt1 ) .
    lv_itmrate1 = REDUCE dmbtr( INIT lv_val1 TYPE dmbtr FOR ls_itm1 IN lt_item1 WHERE ( status2 = '' OR status2 = 'NO')
                                                       NEXT lv_val1 = lv_val1 + ls_itm1-amt2 ) .
    lv_itmrate2 = REDUCE dmbtr( INIT lv_val2 TYPE dmbtr FOR ls_itm2 IN lt_item2 WHERE ( status3 = '' OR status3 = 'NO')
                                                       NEXT lv_val2 = lv_val2 + ls_itm2-amt3 ) .

    gfs_header-tot_amt = lv_itmrate + lv_itmrate1 + lv_itmrate2.
    MODIFY ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
              ENTITY zi_bnkent_hdr
              UPDATE FIELDS ( tot_amt )
              WITH VALUE #( ( %tky      = gfs_header-%tky
                              tot_amt    = gfs_header-tot_amt
                              %control-tot_amt = if_abap_behv=>mk-on
                          ) )
              FAILED DATA(failed_1)
              REPORTED DATA(reported_1)
              MAPPED DATA(mapped_1).


  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_bnkent_exp_i DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bnkent_exp_i RESULT result.
    METHODS expdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_bnkent_exp_i~expdetails.
    METHODS checkinv FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_bnkent_exp_i~checkinv.
    METHODS exp_upateamt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_bnkent_exp_i~exp_upateamt.

ENDCLASS.

CLASS lhc_zi_bnkent_exp_i IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD expdetails.
    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
             ENTITY zi_bnkent_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
             ENTITY zi_bnkent_exp_i
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(item).

    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

*  loop at header
    SELECT a~chargehead , a~rate, b~glcode,b~bnkchargename
    FROM zdt_bnkrate_hdr AS c
    INNER JOIN zdt_bnkexp_itm AS a ON a~id = c~id
    LEFT OUTER JOIN zdt_bnkch_hdr AS b ON a~chargehead = b~bnkchargename
    WHERE c~bankname = @gfs_header-bank AND b~category = 'EXPORT' AND b~active = 'X'
    INTO TABLE @DATA(lt_exp).

    LOOP AT item INTO DATA(ls_item) .
      LOOP AT lt_exp INTO DATA(ls_exp) WHERE chargehead = ls_item-chargehed1.
        IF ls_item-amt1 IS INITIAL.
          ls_item-amt1         = ls_exp-rate.
        ENDIF.
        IF ls_item-glaccount1 IS INITIAL.
          ls_item-glaccount1   = ls_exp-glcode.
        ENDIF.

        MODIFY ENTITIES OF zi_bnkent_hdr   IN LOCAL MODE
                 ENTITY zi_bnkent_exp_i
                 UPDATE
                 FIELDS ( glaccount1 taxc1 amt1 waers )
                 WITH VALUE #( FOR key IN keys
                               ( %tky       = ls_item-%tky
                                 amt1       = ls_item-amt1
                                 taxc1      = gfs_header-taxcode
                                 waers      = gfs_header-currency
                                 glaccount1 = ls_item-glaccount1

                                 %control-amt1       = if_abap_behv=>mk-on
                                 %control-taxc1      = if_abap_behv=>mk-on
                                 %control-waers      = if_abap_behv=>mk-on
                                 %control-glaccount1 = if_abap_behv=>mk-on
                                  ) ).

      ENDLOOP.
*      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD checkinv.

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
               ENTITY zi_bnkent_hdr
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_bnkent_hdr
           BY \_item
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT DATA(item).

    DATA(gfs_item) = VALUE #( item[ 1 ]  OPTIONAL ).

    IF gfs_header-invno IS INITIAL.
      IF gfs_item-chargehed1 IS NOT INITIAL.
        DATA(lv_msg1) = |Invoice No Is Mandatory For Export Charges Entry|.
        APPEND VALUE #( %tky = gfs_header-%tky ) TO failed-zi_bnkent_hdr.

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Validate_Header'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_bnkent_hdr.
      ENDIF.
    ENDIF.
    IF gfs_item-chargehed1 IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_bnk_en_exp_i
      WHERE id         = @gfs_item-id AND
           chargehed1 = @gfs_item-chargehed1
      INTO @DATA(ls_del).
      IF ls_del IS NOT INITIAL.

        DATA(lv_msg2) = |Duplicate Entry For | &&  ls_del-chargehed1 && | For EXPORT|.
        APPEND VALUE #( %tky = gfs_item-%tky ) TO failed-zi_bnkent_hdr.

        APPEND VALUE #( %tky        = gfs_item-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg2 ) )
        TO reported-zi_bnkent_hdr.
      ENDIF.
      IF gfs_item-costcenter1 IS INITIAL.
        DATA(lv_msg) = |Please Enter Cost Center|.
        APPEND VALUE #( %tky = gfs_item-%tky ) TO failed-zi_bnkent_hdr.

        APPEND VALUE #( %tky        = gfs_item-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )
        TO reported-zi_bnkent_hdr.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD exp_upateamt.
*--------------------------------------------------------------------------------------------

    DATA: lv_itmrate  TYPE dmbtr,
          lv_itmrate1 TYPE dmbtr,
          lv_itmrate2 TYPE dmbtr,
          lv_sum      TYPE dmbtr.

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
          ENTITY zi_bnkent_hdr
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_bnkent_hdr
             BY \_item
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT DATA(lt_item).

    READ ENTITY zi_bnkent_hdr
            BY \_item1
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT DATA(lt_item1).


    READ ENTITY zi_bnkent_hdr
          BY \_item2
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_item2).

    lv_itmrate  = REDUCE dmbtr( INIT lv_val TYPE dmbtr FOR ls_itm IN lt_item WHERE ( status1 = '' OR status1 = 'NO')
                                                       NEXT lv_val = lv_val + ls_itm-amt1 ) .
    lv_itmrate1 = REDUCE dmbtr( INIT lv_val1 TYPE dmbtr FOR ls_itm1 IN lt_item1 WHERE ( status2 = '' OR status2 = 'NO')
                                                       NEXT lv_val1 = lv_val1 + ls_itm1-amt2 ) .
    lv_itmrate2 = REDUCE dmbtr( INIT lv_val2 TYPE dmbtr FOR ls_itm2 IN lt_item2 WHERE ( status3 = '' OR status3 = 'NO')
                                                       NEXT lv_val2 = lv_val2 + ls_itm2-amt3 ) .

    gfs_header-tot_amt = lv_itmrate + lv_itmrate1 + lv_itmrate2.
    MODIFY ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
              ENTITY zi_bnkent_hdr
              UPDATE FIELDS ( tot_amt )
              WITH VALUE #( ( %tky      = gfs_header-%tky
                              tot_amt    = gfs_header-tot_amt
                              %control-tot_amt = if_abap_behv=>mk-on
                          ) )
              FAILED DATA(failed_1)
              REPORTED DATA(reported_1)
              MAPPED DATA(mapped_1).

*--------------------------------------------------------------------------------------------

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_bnkent_imp_i DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_bnkent_imp_i RESULT result.
    METHODS impdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_bnkent_imp_i~impdetails.
    METHODS checkimp FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_bnkent_imp_i~checkimp.
    METHODS imp_upateamt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_bnkent_imp_i~imp_upateamt.

ENDCLASS.

CLASS lhc_zi_bnkent_imp_i IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD impdetails.

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
             ENTITY zi_bnkent_hdr
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
             ENTITY zi_bnkent_imp_i
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT FINAL(item1).

**    READ ENTITY zi_bnkent_hdr
**           BY \_item1
**           ALL FIELDS
**           WITH CORRESPONDING #( keys )
**           RESULT DATA(item1).

    DATA(gfs_item1) = VALUE #( item1[ 1 ]  OPTIONAL ).

    SELECT a~chargehead1 , a~rate1,
         b~glcode,b~bnkchargename
   FROM zdt_bnkrate_hdr AS c
   INNER JOIN zdt_bnkimp_itm AS a ON a~id = c~id
   LEFT OUTER JOIN zdt_bnkch_hdr AS b ON a~chargehead1 = b~bnkchargename
   WHERE c~bankname = @gfs_header-bank AND b~category = 'IMPORT' AND active = 'X'
   INTO TABLE @DATA(lt_imp).

    LOOP AT item1 INTO DATA(ls_item1).

      LOOP AT lt_imp INTO DATA(ls_imp) WHERE chargehead1 = ls_item1-chargehed2.

        IF ls_item1-amt2 IS INITIAL.
          ls_item1-amt2         = ls_imp-rate1.
        ENDIF.
        IF  ls_item1-glaccount2 IS INITIAL.
          ls_item1-glaccount2   = ls_imp-glcode.
        ENDIF.

        MODIFY ENTITIES OF zi_bnkent_hdr   IN LOCAL MODE
                          ENTITY zi_bnkent_imp_i
                          UPDATE
                          FIELDS ( glaccount2 taxc2 amt2 waers )
                          WITH VALUE #( FOR key IN keys
                                        ( %tky       = ls_item1-%tky
                                          amt2       = ls_item1-amt2
                                          taxc2      = gfs_header-taxcode
                                          waers      = gfs_header-currency
                                          glaccount2 = ls_item1-glaccount2

                                          %control-amt2       = if_abap_behv=>mk-on
                                          %control-taxc2      = if_abap_behv=>mk-on
                                          %control-waers      = if_abap_behv=>mk-on
                                          %control-glaccount2 = if_abap_behv=>mk-on
                                           ) ).
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.

  METHOD checkimp.
    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
            ENTITY zi_bnkent_hdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(header).

    READ ENTITY zi_bnkent_hdr " IN LOCAL MODE
          BY \_item1
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(bnkimpitm).


    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    DATA(gfs_bnkimpitm) = VALUE #( bnkimpitm[ 1 ]  OPTIONAL ).

    IF gfs_bnkimpitm-chargehed2 IS NOT INITIAL.

      SELECT SINGLE * FROM zdt_bnk_en_imp_i
      WHERE id         = @gfs_bnkimpitm-id AND
           chargehed2 = @gfs_bnkimpitm-chargehed2
      INTO @DATA(ls_del).


      IF ls_del IS NOT INITIAL.

        DATA(lv_msg1) = |Duplicate Entry For | &&  ls_del-chargehed2 && | For IMPORT|.
        APPEND VALUE #( %tky = gfs_bnkimpitm-%tky ) TO failed-zi_bnkent_hdr.

        APPEND VALUE #( %tky        = gfs_bnkimpitm-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg1 ) )
        TO reported-zi_bnkent_hdr.
      ENDIF.
    ENDIF.
    IF gfs_bnkimpitm-costcenter2 IS INITIAL.
      DATA(lv_msg) = |Please Enter Cost Center|.
      APPEND VALUE #( %tky = gfs_bnkimpitm-%tky ) TO failed-zi_bnkent_hdr.

      APPEND VALUE #( %tky        = gfs_bnkimpitm-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )
      TO reported-zi_bnkent_hdr.
    ENDIF.
  ENDMETHOD.

  METHOD imp_upateamt.
*--------------------------------------------------------------------------------------------
    DATA: lv_itmrate  TYPE dmbtr,
          lv_itmrate1 TYPE dmbtr,
          lv_itmrate2 TYPE dmbtr,
          lv_sum      TYPE dmbtr.

    READ ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
          ENTITY zi_bnkent_hdr
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(header).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    READ ENTITY zi_bnkent_hdr
             BY \_item
             ALL FIELDS
             WITH CORRESPONDING #( keys )
             RESULT DATA(lt_item).

    READ ENTITY zi_bnkent_hdr
            BY \_item1
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT DATA(lt_item1).


    READ ENTITY zi_bnkent_hdr
          BY \_item2
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_item2).

    lv_itmrate  = REDUCE dmbtr( INIT lv_val TYPE dmbtr FOR ls_itm IN lt_item WHERE ( status1 = '' OR status1 = 'NO')
                                                       NEXT lv_val = lv_val + ls_itm-amt1 ) .
    lv_itmrate1 = REDUCE dmbtr( INIT lv_val1 TYPE dmbtr FOR ls_itm1 IN lt_item1 WHERE ( status2 = '' OR status2 = 'NO')
                                                       NEXT lv_val1 = lv_val1 + ls_itm1-amt2 ) .
    lv_itmrate2 = REDUCE dmbtr( INIT lv_val2 TYPE dmbtr FOR ls_itm2 IN lt_item2 WHERE ( status3 = '' OR status3 = 'NO')
                                                       NEXT lv_val2 = lv_val2 + ls_itm2-amt3 ) .

    gfs_header-tot_amt = lv_itmrate + lv_itmrate1 + lv_itmrate2.
    MODIFY ENTITIES OF zi_bnkent_hdr IN LOCAL MODE
              ENTITY zi_bnkent_hdr
              UPDATE FIELDS ( tot_amt )
              WITH VALUE #( ( %tky             = gfs_header-%tky
                              tot_amt          = gfs_header-tot_amt
                              %control-tot_amt = if_abap_behv=>mk-on
                          ) )
              FAILED DATA(failed_1)
              REPORTED DATA(reported_1)
              MAPPED DATA(mapped_1).

*--------------------------------------------------------------------------------------------

  ENDMETHOD.

ENDCLASS.
