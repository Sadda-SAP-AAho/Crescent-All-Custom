CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS calculatevalue FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~calculatevalue.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR item RESULT result.
    METHODS get_scrip FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~get_scrip.


ENDCLASS.

CLASS lhc_item IMPLEMENTATION.



  METHOD calculatevalue.

    DATA: lv_ttlamt   TYPE dmbtr.

    READ ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
        ENTITY zi_scriptsl_hdr
            ALL FIELDS WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header)
            FAILED FINAL(lt_header_failed).

    READ ENTITY zi_scriptsl_hdr
          BY \_item
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(lt_item)
               FAILED FINAL(lt_item_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    DATA(lt_item_tmp) = lt_item .

    LOOP AT lt_item_tmp ASSIGNING FIELD-SYMBOL(<lfs_item>).

      IF <lfs_item>-rate IS NOT INITIAL AND <lfs_item>-realizationamt IS NOT INITIAL AND
         <lfs_item>-rate BETWEEN 0 AND 100 .
        <lfs_item>-saleablevalue = ( ( <lfs_item>-rate / 100 )  * <lfs_item>-realizationamt  ).
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
       ENTITY item
       UPDATE FIELDS ( saleablevalue )
       WITH VALUE #( FOR ls_item IN lt_item_tmp
                      ( %tky          = ls_item-%tky
                        saleablevalue = ls_item-saleablevalue ) ).

    CLEAR lv_ttlamt.
    lv_ttlamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_item_tmp
                           NEXT lv_amt = lv_amt + ls_itm-realizationamt ).

    ls_header-sum_realizationamt =  lv_ttlamt.

    CLEAR lv_ttlamt.
    lv_ttlamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_item_tmp
                           NEXT lv_amt = lv_amt + ls_itm-saleablevalue ).

    ls_header-sum_saleablevalue =  lv_ttlamt.

    MODIFY ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
              ENTITY zi_scriptsl_hdr
              UPDATE FIELDS ( sum_realizationamt sum_saleablevalue )
              WITH VALUE #( ( %tky    = ls_header-%tky
                            sum_realizationamt = ls_header-sum_realizationamt
                            sum_saleablevalue  = ls_header-sum_saleablevalue
                        ) ).

  ENDMETHOD.

  METHOD get_instance_features.

  ENDMETHOD.

  METHOD get_scrip.

    READ ENTITIES OF zi_scriptsl_hdr
        ENTITY head
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
         FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_scriptsl_hdr
        ENTITY item
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_item)
         FAILED FINAL(lt_item_failed).

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT lt_item INTO DATA(ls_item).
      IF ls_item-scriptno IS NOT INITIAL .
        SELECT SINGLE *  FROM zcds_script_sales WHERE scriptno = @ls_item-scriptno INTO @DATA(ls_scrip).
        IF sy-subrc EQ 0.

          ls_item-scriptdate     = ls_scrip-scriptdate.
          ls_item-realizationamt = ls_scrip-sum_realizationamt .
          ls_item-currency       = ls_scrip-currency.

          MODIFY ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
             ENTITY item
             UPDATE FIELDS ( scriptdate realizationamt currency )
             WITH VALUE #( ( %tky      = ls_item-%tky

                             scriptdate       = ls_item-scriptdate
                             realizationamt   = ls_item-realizationamt
                             currency         = ls_item-currency
                         ) )
              MAPPED FINAL(ls_mapped)
              FAILED FINAL(ls_failed)
              REPORTED FINAL(ls_reported).
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR head RESULT result.

    METHODS scriptsales FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~scriptsales.
    METHODS scriptdetails FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~scriptdetails.
    METHODS postdoc FOR DETERMINE ON SAVE
      IMPORTING keys FOR head~postdoc.
    METHODS check FOR VALIDATE ON SAVE
      IMPORTING keys FOR head~check.
    METHODS customerdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~customerdetails.
    METHODS set_value FOR DETERMINE ON MODIFY
      IMPORTING keys FOR head~set_value.
    METHODS printscriptinv FOR MODIFY
      IMPORTING keys FOR ACTION zi_scriptsl_hdr~printscriptinv RESULT result.

ENDCLASS.

CLASS lhc_head IMPLEMENTATION.

   METHOD printscriptinv.
    READ ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
                ENTITY zi_scriptsl_hdr
                ALL FIELDS
                WITH CORRESPONDING #( keys )
                RESULT DATA(header)
                " TODO: variable is assigned but never used (ABAP cleaner)
                FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

      <fs_print>-printsi = 'X'.
      <fs_print>-flag    = 'A'.


        MODIFY ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
                ENTITY zi_scriptsl_hdr
                UPDATE
                FIELDS ( printsi flag )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 printsi =  <fs_print>-printsi
                                 flag    =  <fs_print>-flag
                                  %control-printsi   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
         ENTITY  zi_scriptsl_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
    ENTITY zi_scriptsl_hdr
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT FINAL(header)
    FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).

    result = VALUE #( FOR ls_header IN header
                                ( %tky = ls_header-%tky

                                  %field-saccode   = COND #( WHEN ls_header-post IS INITIAL
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-f-read_only )

                                  %field-post      = COND #( WHEN ls_header-scriptsalesno IS INITIAL
                                                            THEN if_abap_behv=>fc-f-read_only
                                                            ELSE if_abap_behv=>fc-f-unrestricted )

                                  %action-edit      = COND #( WHEN ls_header-post IS INITIAL
                                                         THEN if_abap_behv=>fc-o-enabled
                                                         ELSE if_abap_behv=>fc-o-disabled )

                                  %delete           = COND #( WHEN ls_header-post IS INITIAL
                                                         THEN if_abap_behv=>fc-o-enabled
                                                         ELSE if_abap_behv=>fc-o-disabled )

                                  %assoc-_item      = COND #( WHEN ls_header-post IS INITIAL
                                                         THEN if_abap_behv=>fc-o-enabled
                                                         ELSE if_abap_behv=>fc-o-disabled )
                                  ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD scriptsales.

    DATA: gs_item TYPE zdt_scriptsl_itm,
          lv_date TYPE datn,
          lv_time TYPE timn,
          lv_p    TYPE p.
*--------------------------------------------------------------------------------------------*
    READ ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
    ENTITY zi_scriptsl_hdr
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(header)
               FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).
    IF gfs_header IS NOT INITIAL.

      READ ENTITY zi_scriptsl_hdr
      BY \_item
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_item)
           FAILED FINAL(lt_item_failed).
*--------------------------------------------------------------------------------------------*

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      SELECT SINGLE * FROM zi_scriptsl_hdr
                      WHERE id = @gfs_header-id
                      INTO @FINAL(ls_head).
      IF sy-subrc <> 0 AND gfs_header-status IS INITIAL.

        gfs_header-local_created_by = sy-uname.
        gfs_header-local_created_on = lv_date.
        gfs_header-local_created_at = lv_time.
        gfs_header-local_last_changed_by = sy-uname.
        gfs_header-local_last_changed_on = lv_date.
        gfs_header-local_last_changed_at = lv_time.
        gfs_header-last_changed_at       = lv_date.
        gfs_header-status                = 'CREATED'.

        IF gfs_header-scriptsalesno IS INITIAL.
          TRY.

              CALL METHOD cl_numberrange_runtime=>number_get
                EXPORTING
                  nr_range_nr = '01'
                  object      = 'ZEX_SCRPSL'
                IMPORTING
                  number      = DATA(lv_number)
                  returncode  = DATA(lv_rcode).

              SHIFT lv_number LEFT DELETING LEADING '0'.
              gfs_header-scriptsalesno = lv_number .
            CATCH cx_number_ranges INTO DATA(lr_error).
          ENDTRY .

          MODIFY ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
            ENTITY zi_scriptsl_hdr
            UPDATE FIELDS ( scriptsalesno )
            WITH VALUE #( ( %tky                  = gfs_header-%tky

                            scriptsalesno         = gfs_header-scriptsalesno
                           ) ).

        ENDIF.
        MODIFY ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
            ENTITY zi_scriptsl_hdr
            UPDATE FIELDS ( scriptsalesno
                            status local_created_by local_created_at
                            local_created_on local_last_changed_by
                            local_last_changed_at local_last_changed_on last_changed_at )
            WITH VALUE #( ( %tky                  = gfs_header-%tky

                            scriptsalesno         = gfs_header-scriptsalesno
                            status                = gfs_header-status
                            local_created_by      = gfs_header-local_created_by
                            local_created_at      = gfs_header-local_created_at
                            local_created_on      = gfs_header-local_created_on
                            local_last_changed_by = gfs_header-local_last_changed_by
                            local_last_changed_at = gfs_header-local_last_changed_at
                            local_last_changed_on = gfs_header-local_last_changed_on
                            last_changed_at       = gfs_header-last_changed_at
                        ) ).
        CLEAR: gfs_header.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD scriptdetails.

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
           END OF ty_glitemstax,

           BEGIN OF ty_ariitems,
             glaccountlineitem TYPE char6,
             customer          TYPE char10,
             glaccount         TYPE char10,
             waers             TYPE waers,
             amt               TYPE dmbtr,
             lv_num            TYPE numc3,
           END OF ty_ariitems.

    DATA: gt_glitems  TYPE STANDARD TABLE OF glitems,
          gs_glitems  TYPE glitems,

          gt_gltax    TYPE STANDARD TABLE OF ty_glitemstax,
          gs_gltax    TYPE ty_glitemstax,

          gt_ariitems TYPE STANDARD TABLE OF ty_ariitems,
          gs_ariitems TYPE ty_ariitems.

    DATA: lv_num        TYPE numc3,
          lv_difference TYPE dmbtr.

*//--------------------------------------------------------------------------//

    READ ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
       ENTITY zi_scriptsl_hdr
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(lt_header)
       FAILED DATA(lt_header_failed).

    DATA(gfs_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    CHECK gfs_header-accpostref IS INITIAL.
    CHECK gfs_header-accdocno IS INITIAL.
    CHECK gfs_header-post IS NOT INITIAL.

*//--------------------------------------------------------------------------//

    DATA(ls_entry) = gfs_header.

    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lv_cid     TYPE abp_behv_cid.

    FREE: gt_glitems,gt_gltax, gt_ariitems.
    CLEAR: gs_glitems, gs_ariitems.

    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

    lv_difference = gfs_header-sum_realizationamt - gfs_header-sum_saleablevalue.
    IF lv_difference IS NOT INITIAL.

      gs_glitems = VALUE #(  glaccount         = '0036300020'
                              amt              = lv_difference
                              waers            = 'INR'
                              ).

      APPEND gs_glitems TO gt_glitems.
    ENDIF.

    gs_glitems = VALUE #(  glaccount         = '0012800710'
                            amt              = ( gfs_header-sum_realizationamt * -1 )
                            waers            = 'INR'
                            ).

    APPEND gs_glitems TO gt_glitems.
    DATA(lt_glitems) = gt_glitems[].

    gs_ariitems = VALUE #( customer = gfs_header-customer
                           amt      = gfs_header-sum_saleablevalue
                           waers    = 'INR'
                         ).
    APPEND gs_ariitems TO gt_ariitems.
    DATA(lt_ariitems) = gt_ariitems[].

*//-- Set Sl no---
* For ARI Items
    lv_num = 1.
    LOOP AT lt_ariitems ASSIGNING FIELD-SYMBOL(<fs_ariitems>).
      <fs_ariitems>-lv_num = lv_num.
      lv_num += 1.

    ENDLOOP.

    LOOP AT lt_glitems ASSIGNING FIELD-SYMBOL(<fs_glitems>).
      <fs_glitems>-lv_num = lv_num.
      IF <fs_glitems>-taxc IS NOT INITIAL .
        <fs_glitems>-lv_numtax = lv_num.
      ENDIF.
      lv_num += 1.

    ENDLOOP.

*
**//------------------Get Date Time from Time Stamp -----------//
    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

*    CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
*    lv_acpostref = ls_entry-scriptsalesno && lv_time.

    CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
    lv_acpostref = ls_entry-scriptsalesno && lv_time.
    data : lv_prctr TYPE prctr.
    if gfs_header-bupla = '1400'.
      lv_prctr = '1400'.
    else.
      lv_prctr = '1000'.
    endif.
*
*
*//-- Set Final Journal Entry line ---
    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
    <je_deep>-%cid = lv_cid.
    <je_deep>-%param = VALUE #(
                        companycode                  = '1000'
                        documentreferenceid          = ls_entry-scriptsalesno
                        businesstransactiontype      = 'RFBU'
                        accountingdocumenttype       = 'DV'
                        createdbyuser                = sy-uname
                        documentdate                 = ls_entry-scriptsalesdate
                        postingdate                  = ls_entry-scriptsalesdate
                        accountingdocumentheadertext = lv_acpostref

                        _glitems                     = VALUE #( FOR ls_item1 IN lt_glitems
                                                                 ( glaccountlineitem    = ls_item1-lv_num
                                                                   glaccount            = ls_item1-glaccount
*                                                                   profitcenter         = '1000'
                                                                   profitcenter         = lv_prctr "'1000'
                                                                   assignmentreference  = gfs_header-scriptsalesno

                                                                    _currencyamount      = VALUE #( ( currencyrole           = '00'
                                                                                                      journalentryitemamount = ls_item1-amt
                                                                                                      currency               = ls_item1-waers ) ) ) )

                        _aritems                    = VALUE #( FOR ls_ariitems IN lt_ariitems
                                                               ( glaccountlineitem      = ls_ariitems-lv_num
                                                                 customer               = ls_ariitems-customer
*                                                                 businessplace          = '1000'
                                                                 businessplace          = gfs_header-bupla "'1000'
                                                                 assignmentreference    = gfs_header-scriptsalesno


                                                                   _currencyamount       = VALUE #( ( currencyrole            = '00'
                                                                                                      journalentryitemamount = ls_ariitems-amt
                                                                                                       currency               = ls_ariitems-waers ) ) ) )
                               ) .
*
**//--------------------------------------------------------------------------//
*
    DATA: lt_je_val TYPE TABLE FOR FUNCTION IMPORT i_journalentrytp~validate.

    clear : lv_prctr.

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
        DATA(lv_result01) = <ls_reported_deep01>-%msg->if_message~get_text( ).

        APPEND VALUE #( %tky        = gfs_header-%tky
                        %state_area = 'Error_Message'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_result01 ) )
        TO reported-head .

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

        gfs_header-post       = 'X'.
        gfs_header-accpostref = lv_acpostref.
        gfs_header-status     = 'POSTED'.
        MODIFY ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
               ENTITY zi_scriptsl_hdr
               UPDATE
               FIELDS ( accpostref status )
               WITH VALUE #( FOR key IN keys
                             ( %tky           = gfs_header-%tky
                               accpostref     = gfs_header-accpostref
                               status         = gfs_header-status

                               %control-accpostref = if_abap_behv=>mk-on
                               %control-status     = if_abap_behv=>mk-on
                             ) )
                FAILED DATA(failed1)
                REPORTED DATA(reported1).
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD check.

    READ ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
          ENTITY head
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_header)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(lt_header_failed).

    READ ENTITY zi_scriptsl_hdr
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE *
    FROM zdt_scriptsl_hdr
      WHERE scriptsalesno = @ls_header-scriptsalesno  AND id <> @ls_header-id
    " TODO: variable is assigned but never used (ABAP cleaner)
      INTO @FINAL(ls_head).
    IF sy-subrc = 0.
      APPEND VALUE #( %tky              = ls_header-%tky
                      %state_area       = 'Validate_Head'
                      %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     = 'Script Sales Number Already Exist' )
                      %element-scriptsalesno = if_abap_behv=>mk-on )
             TO reported-head.

      APPEND VALUE #( %tky = ls_header-%tky )
             TO failed-head.
    ENDIF.

    IF ls_header-scriptno IS NOT INITIAL.
      SELECT SINGLE *
      FROM zdt_scriptsl_itm
      WHERE scriptno = @ls_header-scriptno
      INTO @FINAL(ls_scriptno).
      IF sy-subrc IS INITIAL.
        APPEND VALUE #( %tky          = ls_header-%tky
                    %state_area       = 'Validate_Head'
                    %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = 'Script Number Already Used in a Script Sales' )
                    %element-scriptsalesno = if_abap_behv=>mk-on )
           TO reported-head.

        APPEND VALUE #( %tky = ls_header-%tky )
               TO failed-head.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD customerdetails.

*  READ ENTITIES OF zi_scriptsl_hdr
*  ENTITY head
*  ALL FIELDS WITH CORRESPONDING
*
  ENDMETHOD.

  METHOD set_value.

    READ ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
          ENTITY head
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_header)
          FAILED FINAL(lt_header_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    ls_header-saccode = '56899'.

    SELECT SINGLE * FROM zf4_customer WHERE customer = @ls_header-customer INTO @DATA(ls_customer).
    IF sy-subrc EQ 0 .
      ls_header-customername = ls_customer-customerfullname .
    ENDIF.

    MODIFY ENTITIES OF zi_scriptsl_hdr IN LOCAL MODE
        ENTITY zi_scriptsl_hdr
         UPDATE
         FIELDS ( saccode customername )
                   WITH VALUE #( FOR key IN keys
                                 ( %tky      = ls_header-%tky
                                   saccode          = ls_header-saccode
                                   customername     = ls_header-customername

                                   %control-saccode      = if_abap_behv=>mk-on
                                   %control-customername = if_abap_behv=>mk-on
                                 ) )
                    FAILED DATA(failed1)
                    REPORTED DATA(reported1).
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_scriptsl_hdr DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_scriptsl_hdr IMPLEMENTATION.

  METHOD save_modified.

      IF update-head IS NOT INITIAL.

      DATA: lv_printq TYPE char32.

      SELECT SINGLE * FROM zdt_print_queue WHERE cbuser = @sy-uname INTO @DATA(ls_printq).
      IF sy-subrc = 0.
        lv_printq = ls_printq-printque.
      ELSE.
        lv_printq = 'ZDEFAULT'.
      ENDIF.

      DATA(lt_head) = update-head.
      READ TABLE lt_head INDEX 1 INTO DATA(wa_head).

      IF wa_head-flag = 'A'.

        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSD_SIPRINT' ) .

            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'SCRIPTINVOICE' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
"" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
 "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
*                  lo_store->set_schema(
*                    iv_form_name = 'SCRIPTINVOICE'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
"" End Of Comment KJ 06.06.2025

            ENDTRY.

            DATA(lt_keys)     = lo_fdp_util->get_keys( ).
            lt_keys[ name = 'SCRIPTSALESNO' ]-value = lt_head[ 1 ]-scriptsalesno.
            TRY.
                DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception).
            ENDTRY.
            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'SCRIPTINVOICE'
              iv_template_name = 'SCRIPTINVOICE'
            ).
*        cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml
*                                              iv_xdp_layout   = ls_template-xdp_template
*                                              iv_locale       = 'en_US'
*                                              is_options      = VALUE #(
*                                                          trace_level = 4 )
*                                    IMPORTING ev_pdf          = DATA(lv_pdf01)
*                                              ev_trace_string = DATA(lv_trace01)
*                                               ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      = lv_printq "'TAXINVDOM'
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
            lv_text = |SCRIPT INVOICE | && lt_head[ 1 ]-scriptsalesno.
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
