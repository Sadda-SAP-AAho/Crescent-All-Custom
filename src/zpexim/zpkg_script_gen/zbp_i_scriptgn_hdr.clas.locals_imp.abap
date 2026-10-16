CLASS lhc_zi_scriptgn_itm DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS scrolldetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_scriptgn_itm~scrolldetails.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_scriptgn_itm RESULT result.
*    METHODS printscriptinv FOR MODIFY
*      IMPORTING keys FOR ACTION zi_scriptgn_hdr~printscriptinv RESULT result.

ENDCLASS.

CLASS lhc_zi_scriptgn_itm IMPLEMENTATION.

*  METHOD printscriptinv.
*    READ ENTITIES OF zi_scriptgn_hdr IN LOCAL MODE
*                ENTITY zi_scriptgn_hdr
*                ALL FIELDS
*                WITH CORRESPONDING #( keys )
*                RESULT DATA(header)
*                " TODO: variable is assigned but never used (ABAP cleaner)
*                FAILED FINAL(header_failed).
*
*
*    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
*      IF <fs_print> IS ASSIGNED.
*
*
*        MODIFY ENTITIES OF zi_scriptgn_hdr IN LOCAL MODE
*                ENTITY zi_scriptgn_hdr
*                UPDATE
*                FIELDS ( printsi )
*                WITH VALUE #( ( %tky          = <fs_print>-%tky
*                                 printsi = 'X'
*                                  %control-printsi   = if_abap_behv=>mk-on
*                                ) ).
*
*      ENDIF.
*    ENDLOOP.
*    " Fill the response table
*    READ ENTITIES OF zi_scriptgn_hdr IN LOCAL MODE
*         ENTITY  zi_scriptgn_hdr
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(header_1).
*
*    result = VALUE #( FOR ls_header IN header_1
*                      ( %tky   = ls_header-%tky
*                        %param = ls_header ) ).
*  ENDMETHOD.

  METHOD scrolldetails.

    DATA: lv_ttlamt TYPE dmbtr.
*----------------------------------------------------------------------------*
    READ ENTITIES OF zi_scriptgn_hdr IN LOCAL MODE
        ENTITY zi_scriptgn_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).
    IF gfs_header IS NOT INITIAL.


      READ ENTITY zi_scriptgn_hdr
      BY \_item
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(lt_item)
               " TODO: variable is assigned but never used (ABAP cleaner)
               FAILED FINAL(lt_item_failed).

      IF lt_item IS NOT INITIAL.
        CLEAR lv_ttlamt.
        lv_ttlamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_item
                               NEXT lv_amt = lv_amt + ls_itm-rodtep_dd_v ).
        gfs_header-sum_rodtep_dd_v =  lv_ttlamt.
        CLEAR lv_ttlamt.
        lv_ttlamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_item
                               NEXT lv_amt = lv_amt + ls_itm-realizationamt ).
        gfs_header-sum_realizationamt =  lv_ttlamt.

        gfs_header-sum_difference =  gfs_header-sum_rodtep_dd_v - gfs_header-sum_realizationamt.

        MODIFY ENTITIES OF zi_scriptgn_hdr IN LOCAL MODE
                ENTITY zi_scriptgn_hdr
                UPDATE FIELDS ( sum_rodtep_dd_v sum_realizationamt sum_difference )
                WITH VALUE #( ( %tky          = gfs_header-%tky

                                  sum_rodtep_dd_v    = gfs_header-sum_rodtep_dd_v
                                  sum_realizationamt = gfs_header-sum_realizationamt
                                  sum_difference     = gfs_header-sum_difference
                  ) ).
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD get_instance_features.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_scriptgn_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_scriptgn_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_scriptgn_hdr RESULT result.

    METHODS shippingbilldetails FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_scriptgn_hdr~shippingbilldetails.

    METHODS scrolldata FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_scriptgn_hdr~scrolldata.

    METHODS check FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_scriptgn_hdr~check.
    METHODS post FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_scriptgn_hdr~post.

ENDCLASS.

CLASS lhc_zi_scriptgn_hdr IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_scriptgn_hdr IN LOCAL MODE
            ENTITY zi_scriptgn_hdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(lt_header_failed).

*    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    result = VALUE #( FOR ls_header IN lt_header
                      ( %tky         = ls_header-%tky

*-- Go-Live commented 02.04.25---
**                        %action-edit      = COND #( WHEN ls_header-post IS INITIAL
**                                               THEN if_abap_behv=>fc-o-enabled
**                                               ELSE if_abap_behv=>fc-o-disabled )
**                        %delete           = COND #( WHEN ls_header-post IS INITIAL
**                                                       THEN if_abap_behv=>fc-o-enabled
**                                                       ELSE if_abap_behv=>fc-o-disabled )
**                        %assoc-_item      =  if_abap_behv=>fc-o-disabled
*-- Go-Live commented 02.04.25---
                                                ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD shippingbilldetails.

    DATA: gs_item TYPE zdt_scriptgn_itm,
          lv_date TYPE datn,
          lv_time TYPE timn,
          lv_item TYPE zi_packlist_itm-item,
          lv_p    TYPE p.
*----------------------------------------------------------------------------*
    READ ENTITIES OF zi_scriptgn_hdr IN LOCAL MODE
        ENTITY zi_scriptgn_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ] OPTIONAL ).
    IF gfs_header IS NOT INITIAL.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      SELECT SINGLE * FROM zi_scriptgn_hdr
                      WHERE id = @gfs_header-id
                      INTO @FINAL(ls_head).
      IF sy-subrc <> 0 AND gfs_header-status IS INITIAL.

        gfs_header-scriptno = gfs_header-scriptno.
        gfs_header-scriptdate = lv_date.
        gfs_header-local_created_by = sy-uname.
        gfs_header-local_created_at = lv_date.
        gfs_header-local_created_on = lv_time.
        gfs_header-local_last_changed_by = sy-uname.
        gfs_header-local_last_changed_at = lv_date.
        gfs_header-local_last_changed_on = lv_time.
        gfs_header-last_changed_at = lv_date.
        gfs_header-status = 'CREATED'.

        MODIFY ENTITIES OF zi_scriptgn_hdr IN LOCAL MODE
            ENTITY zi_scriptgn_hdr
            UPDATE FIELDS ( status local_created_by local_created_at
                            local_created_on local_last_changed_by
                            local_last_changed_at local_last_changed_on last_changed_at )
            WITH VALUE #( ( %tky                  = gfs_header-%tky
                            status                = gfs_header-status
                            local_created_by      = gfs_header-local_created_by
                            local_created_at      = gfs_header-local_created_at
                            local_created_on      = gfs_header-local_created_on
                            local_last_changed_by = gfs_header-local_last_changed_by
                            local_last_changed_at = gfs_header-local_last_changed_at
                            local_last_changed_on = gfs_header-local_last_changed_on
                           last_changed_at        = gfs_header-last_changed_at
                        ) ).
        CLEAR: gfs_header.
      ENDIF.
    ENDIF.


  ENDMETHOD.


  METHOD scrolldata.

    READ ENTITIES OF zi_scriptgn_hdr IN LOCAL MODE
               ENTITY zi_scriptgn_hdr
               ALL FIELDS
               WITH CORRESPONDING #( keys )
               RESULT FINAL(lt_header)
               FAILED FINAL(lt_header_failed).

    FINAL(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_header IS INITIAL.
      RETURN.
    ENDIF.

    IF ls_header IS NOT INITIAL.
      SELECT *
      FROM zcds_script_gen
      WHERE scrollno = @ls_header-scrollno
      INTO TABLE @DATA(lt_scroll).

      LOOP AT lt_scroll ASSIGNING FIELD-SYMBOL(<lfs_scroll>).
        FINAL(ls_scrollno) = VALUE #( lt_scroll[ scrollno = <lfs_scroll>-scrollno shipping_bill = <lfs_scroll>-shipping_bill ] OPTIONAL ).
        TRY.
            FINAL(lv_id) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
          CATCH cx_uuid_error.
        ENDTRY.

        MODIFY ENTITIES OF zi_scriptgn_hdr IN LOCAL MODE
        ENTITY zi_scriptgn_hdr
        CREATE BY \_item
        FROM VALUE #( ( id      = ls_header-id
                        %target = VALUE #( (    %cid               = lv_id
                                                item               = lv_id
                                                scriptno           = ls_header-scriptno
                                                scriptdate         = ls_header-scriptdate
                                                scrollno           = ls_scrollno-scrollno
                                                shipping_bill      = ls_scrollno-shipping_bill
                                                shipping_bill_date = ls_scrollno-shipping_bill_date
                                                port_code          = ls_scrollno-port_code
                                                port_codename      = ls_scrollno-port_codename
                                                currency           = ls_scrollno-currency
                                                fob_lc_v           = ls_scrollno-fob_lc_v
                                                rodtep_dd_v        = ls_scrollno-rodtep_dd_v
                                                realizationamt     = ls_scrollno-appliedamount
                                                difference         = ls_scrollno-rodtep_dd_v - ls_scrollno-appliedamount

                                                 %control-scriptno           = if_abap_behv=>mk-on
                                                 %control-scriptdate         = if_abap_behv=>mk-on
                                                 %control-scrollno           = if_abap_behv=>mk-on
                                                 %control-shipping_bill      = if_abap_behv=>mk-on
                                                 %control-shipping_bill_date = if_abap_behv=>mk-on
                                                 %control-port_code          = if_abap_behv=>mk-on
                                                 %control-port_codename      = if_abap_behv=>mk-on
                                                 %control-currency           = if_abap_behv=>mk-on
                                                 %control-fob_lc_v           = if_abap_behv=>mk-on
                                                 %control-rodtep_dd_v        = if_abap_behv=>mk-on
                                                 %control-realizationamt     = if_abap_behv=>mk-on
                                                 %control-difference         = if_abap_behv=>mk-on

                                          ) ) ) )
                        MAPPED FINAL(ls_mapped)
                        FAILED FINAL(ls_failed)
                        REPORTED FINAL(ls_reported).

      ENDLOOP.

    ENDIF.

  ENDMETHOD.

  METHOD check.

    DATA: lv_msg TYPE string .
    READ ENTITIES OF zi_scriptgn_hdr IN LOCAL MODE
         ENTITY zi_scriptgn_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITY zi_scriptgn_hdr
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

    SELECT SINGLE * FROM zdt_scriptgn_hdr
      WHERE scriptno = @ls_header-scriptno AND id <> @ls_header-id
    " TODO: variable is assigned but never used (ABAP cleaner)
      INTO @FINAL(ls_head).
    IF sy-subrc = 0.
      APPEND VALUE #( %tky              = ls_header-%tky
                      %state_area       = 'Validate_Head'
                      %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     = 'Duplicate Scrip Number' )
                      %element-scrollno = if_abap_behv=>mk-on )
             TO reported-zi_scriptgn_hdr.

      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-zi_scriptgn_hdr.
    ENDIF.

    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<lfs_item>).

      SELECT SINGLE b~* FROM zdt_scriptgn_itm AS a
                        INNER JOIN zdt_scriptgn_hdr AS b ON a~id = b~id
                      WHERE a~scrollno = @<lfs_item>-scrollno AND a~id <> @ls_header-id
                      INTO @DATA(ls_exit_scrip).
      IF sy-subrc EQ 0 .
*        lv_msg = 'Scroll-' && <lfs_item>-scrollno && ' Already in Scrip-' && ls_exit_scrip-scriptno .
*        APPEND VALUE #( %tky            = ls_header-%tky
*                      %state_area       = 'Validate_Head'
*                      %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                                 text     =  lv_msg )
*                      %element-scrollno = if_abap_behv=>mk-on )
*           TO reported-zi_scriptgn_hdr.
*
*        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-zi_scriptgn_hdr.
*        EXIT.
      ENDIF.
    ENDLOOP.

    DATA(lt_portcode) = lt_item[].
    DELETE ADJACENT DUPLICATES FROM lt_portcode COMPARING port_code .
    IF lines( lt_portcode ) > 1 .
      lv_msg = 'Multiple PortCode Not Allowed in Scrip'.
      APPEND VALUE #( %tky            = ls_header-%tky
                    %state_area       = 'Validate_Head'
                    %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     =  lv_msg ) )
         TO reported-zi_scriptgn_hdr.

      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-zi_scriptgn_hdr.
    ENDIF.

  ENDMETHOD.

  METHOD post.

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

    READ ENTITIES OF zi_scriptgn_hdr IN LOCAL MODE
       ENTITY zi_scriptgn_hdr
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(lt_header)
       FAILED DATA(lt_header_failed).

    DATA(gfs_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

*//--------------------------------------------------------------------------//

    DATA(ls_entry) = gfs_header.
*    SELECT SINGLE companycode FROM i_companycode
*    INTO @DATA(lv_cocode).

    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lv_cid     TYPE abp_behv_cid.

    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.

    FREE: gt_glitems,gt_gltax.

    CLEAR gs_glitems.

    gs_glitems = VALUE #(  glaccount         = '0012800710'
                            amt              =  gfs_header-sum_realizationamt
                            waers            = 'INR'
                            ).
    APPEND gs_glitems TO gt_glitems.

    gs_glitems = VALUE #(  glaccount         = '0012800700'
                            amt              = ( gfs_header-sum_rodtep_dd_v * -1 )
                            waers            = 'INR'
                            ).

    APPEND gs_glitems TO gt_glitems.

    gs_glitems = VALUE #(  glaccount         = '0036300020'
                            amt              = gfs_header-sum_difference
                            waers            = 'INR'
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
    lv_acpostref = gfs_header-scriptno && lv_time.


*//-- Set Final Journal Entry line ---
    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
    <je_deep>-%cid = lv_cid.
    <je_deep>-%param = VALUE #(
                        companycode                  = '1000'
                        documentreferenceid          = ls_entry-scriptno
                        businesstransactiontype      = 'RFBU'
                        accountingdocumenttype       = 'ZX'
                        createdbyuser                = sy-uname
                        documentdate                 = sy-datlo
                        postingdate                  = sy-datlo
                        accountingdocumentheadertext = lv_acpostref

                        _glitems                     = VALUE #( FOR ls_item1 IN lt_glitems
                                                                 ( glaccountlineitem      = ls_item1-lv_num
                                                                   glaccount              = ls_item1-glaccount
                                                                   profitcenter           = '1000'
                                                                   assignmentreference    = gfs_header-scriptno

                                                                  _currencyamount   = VALUE #( ( currencyrole           = '00'
                                                                                                 journalentryitemamount = ls_item1-amt
                                                                                                 currency               = ls_item1-waers ) )
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
       TO reported-zi_scriptgn_hdr.
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
          lv_msg = <ls_reported_deep01>-%msg->if_message~get_text( ).

          APPEND VALUE #( %tky        = gfs_header-%tky
                          %state_area = 'Error_Message'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )
         TO reported-zi_scriptgn_hdr.
          CLEAR lv_msg.
        ENDLOOP.
      ELSE. "---Success

        gfs_header-post       = 'X'.
        gfs_header-accpostref = lv_acpostref.
        MODIFY ENTITIES OF zi_scriptgn_hdr IN LOCAL MODE
               ENTITY zi_scriptgn_hdr
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

ENDCLASS.

CLASS lsc_zi_scriptgn_hdr DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_scriptgn_hdr IMPLEMENTATION.

  METHOD save_modified.
*
*      IF update-zi_scriptgn_hdr IS NOT INITIAL.
*
*      DATA: lv_printq TYPE char32.
*
*      SELECT SINGLE * FROM zdt_print_queue WHERE cbuser = @sy-uname INTO @DATA(ls_printq).
*      IF sy-subrc = 0.
*        lv_printq = ls_printq-printque.
*      ELSE.
*        lv_printq = 'ZDEFAULT'.
*      ENDIF.
*
*      DATA(lt_head) = update-zi_scriptgn_hdr.
*      READ TABLE lt_head INDEX 1 INTO DATA(wa_head).
*
*
*        TRY.
*            "Initialize Template Store Client
*            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
*              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
*              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
*            ).
*
*            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSD_SIPRINT' ) .
*
*            TRY.
*                lo_store->get_schema_by_name( iv_form_name = 'SCRIPTINVOICE' ).
*              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
*                IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
*                  lo_store->set_schema(
*                    iv_form_name = 'SCRIPTINVOICE'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
*            ENDTRY.
*
*            DATA(lt_keys)     = lo_fdp_util->get_keys( ).
*            lt_keys[ name = 'ACCDOCNO' ]-value = lt_head[ 1 ]-accountdocno.        "DifferentFieldName
*            lt_keys[ name = 'SCRIPTSALESDATE' ]-value = lt_head[ 1 ]-SCRIPTDATE.   "DifferentFieldName
*            TRY.
*                DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
*              CATCH cx_fp_fdp_error INTO DATA(lo_exception).
*            ENDTRY.
*            DATA(ls_template) = lo_store->get_template_by_name(
*              iv_get_binary    = abap_true
*              iv_form_name     = 'SCRIPTINVOICE'
*              iv_template_name = 'SCRIPTINVOICE'
*            ).
**        cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml
**                                              iv_xdp_layout   = ls_template-xdp_template
**                                              iv_locale       = 'en_US'
**                                              is_options      = VALUE #(
**                                                          trace_level = 4 )
**                                    IMPORTING ev_pdf          = DATA(lv_pdf01)
**                                              ev_trace_string = DATA(lv_trace01)
**                                               ).
*            cl_fp_ads_util=>render_4_pq(
*              EXPORTING
*                iv_locale       = 'en_US'
*                iv_pq_name      = lv_printq "'TAXINVDOM'
*                iv_xml_data     = lv_xml
*                iv_xdp_layout   = ls_template-xdp_template
*                is_options      = VALUE #(
*                  trace_level = 4 "Use 0 in production environment
*            )
*              IMPORTING
*                ev_trace_string = DATA(lv_trace)
*                ev_pdl          = DATA(lv_pdf)
*            ).
*
*            DATA: lv_text TYPE char120.
*            lv_text = |SCRIPT INVOICE | && lt_head[ 1 ]-accountdocno.
*            cl_print_queue_utils=>create_queue_item_by_data(
*              iv_qname            = lv_printq
*              iv_print_data       = lv_pdf
*              iv_name_of_main_doc = lv_text
*              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
*            ).
*
*          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
*        ENDTRY.
*
*
*      ENDIF.
*
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
