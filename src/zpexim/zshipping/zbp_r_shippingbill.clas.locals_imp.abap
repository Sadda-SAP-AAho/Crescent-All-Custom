 CLASS lhc_shippingbill DEFINITION INHERITING FROM cl_abap_behavior_handler.
   PRIVATE SECTION.

     METHODS get_instance_features FOR INSTANCE FEATURES
       IMPORTING keys REQUEST requested_features FOR zr_shippingbilltp RESULT result.

     METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
       IMPORTING REQUEST requested_authorizations FOR zr_shippingbilltp RESULT result.

     METHODS change_details FOR DETERMINE ON MODIFY
       IMPORTING keys FOR zr_shippingbilltp~change_details.

     METHODS initialize_exc_rate FOR DETERMINE ON MODIFY
       IMPORTING keys FOR zr_shippingbilltp~initialize_exc_rate.

     METHODS save_details FOR VALIDATE ON SAVE
       IMPORTING keys FOR zr_shippingbilltp~save_details.
     METHODS acc_post FOR DETERMINE ON SAVE
       IMPORTING keys FOR zr_shippingbilltp~acc_post.
     METHODS acc_postdbk FOR DETERMINE ON SAVE
       IMPORTING keys FOR zr_shippingbilltp~acc_postdbk.
     METHODS cancel FOR MODIFY
       IMPORTING keys FOR ACTION zr_shippingbilltp~cancel RESULT result.
     METHODS update_amt FOR DETERMINE ON SAVE
       IMPORTING keys FOR zr_shippingbilltp~update_amt.

*      METHODS precheck_create FOR PRECHECK
*        IMPORTING entities FOR CREATE zr_shippingbilltp.
*
*      METHODS precheck_update FOR PRECHECK
*        IMPORTING entities FOR UPDATE zr_shippingbilltp.

*      Bulk BRC Uploader Methods defined

*      METHODS uploadfile FOR DETERMINE ON SAVE
*        IMPORTING keys FOR zr_shippingbilltp~uploadfile.
*
*      METHODS upload_filedata FOR VALIDATE ON SAVE
*        IMPORTING keys FOR zr_shippingbilltp~validate_filedata.


 ENDCLASS.

 CLASS lhc_shippingbill IMPLEMENTATION.

   METHOD get_instance_features.

     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
           ENTITY zr_shippingbilltp
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(head)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(head_failed).

     result = VALUE #( FOR gs_header1 IN head
                       ( %tky                    = gs_header1-%tky

                         %field-exchangerate     = COND #( WHEN gs_header1-fob_fc_c = 'INR'
                                                                THEN if_abap_behv=>fc-f-read_only
                                                                ELSE if_abap_behv=>fc-f-mandatory
                                                         )

**                        %field-billoflading     = if_abap_behv=>fc-f-mandatory
**
**                        %field-billofladingdate = if_abap_behv=>fc-f-mandatory

                         %field-portcode         = if_abap_behv=>fc-f-mandatory

                         %field-customhandlingagent = if_abap_behv=>fc-f-mandatory

                         %field-tpost            =   COND #( WHEN gs_header1-tpost = 'X'
                                                      THEN if_abap_behv=>fc-f-read_only
                                                      ELSE if_abap_behv=>fc-f-unrestricted
                                                     )

                         %field-tpostdbk         =  COND #( WHEN gs_header1-tpostdbk = 'X'
                                                      THEN if_abap_behv=>fc-f-read_only
                                                      ELSE if_abap_behv=>fc-f-unrestricted
                                                     )

                         %action-edit            =  COND #( WHEN ( ( gs_header1-tpostdbk = 'X' AND
                                                                     gs_header1-tpost    = 'X' ) OR
                                                                     gs_header1-closestatus = 'X' ) THEN if_abap_behv=>fc-o-disabled
                                                                                             ELSE if_abap_behv=>fc-o-enabled
                                                     )
                         %delete                   = if_abap_behv=>fc-o-disabled

                         %action-cancel            =  COND #( WHEN ( gs_header1-tpostdbk = 'X' OR
                                                                     gs_header1-tpost    = 'X' OR
                                                                    gs_header1-closestatus = 'X') AND ( gs_header1-isreversed = '' AND gs_header1-accountdocno IS NOT INITIAL ) THEN if_abap_behv=>fc-o-disabled
                                                                                             ELSE if_abap_behv=>fc-o-enabled
                                                     )

                         %assoc-_shippingbillitem  =  COND #( WHEN ( gs_header1-tpostdbk = 'X' OR
                                                                     gs_header1-tpost    = 'X' OR
                                                                     gs_header1-closestatus = 'X' ) THEN if_abap_behv=>fc-o-disabled
                                                                                             ELSE if_abap_behv=>fc-o-enabled
                                                     )



                         ) ).

   ENDMETHOD.

   METHOD get_global_authorizations.
   ENDMETHOD.

   METHOD change_details.

     DATA: lv_rodtepamt TYPE dmbtr,
           lv_dbkamt    TYPE dmbtr,
           lv_fobamt    TYPE dmbtr.

     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
            ENTITY zr_shippingbilltp
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT DATA(head)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(head_failed).

     READ ENTITY zr_shippingbilltp
          BY \_shippingbillitem
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(item_failed).

     READ ENTITY zr_shippingbilltp
          BY \_shippingbillitemlic
          ALL FIELDS
          WITH CORRESPONDING #( keys )
            " TODO: variable is assigned but never used (ABAP cleaner)
          RESULT FINAL(lic)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(lic_failed).

     ASSIGN head[ 1 ] TO FIELD-SYMBOL(<lfs_head>).
     IF sy-subrc <> 0.
       RETURN.
     ENDIF.

     IF <lfs_head>-fob_fc_c <> 'INR' AND <lfs_head>-exchangerate IS NOT INITIAL.

       lv_rodtepamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN item
                                    NEXT lv_amt = lv_amt + ls_itm-total_rodtep_v_fc ).

       lv_dbkamt = REDUCE dmbtr( INIT lv_amt1 TYPE dmbtr FOR ls_itm IN item
                                    NEXT lv_amt1 = lv_amt1 + ls_itm-total_duty_drawback_v_fc ).

       lv_fobamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN item
                                   NEXT lv_amt = lv_amt + ls_itm-invoicevaluefcv ).


       <lfs_head>-fob_fc_v           = lv_fobamt .
       <lfs_head>-fob_lc_v           = lv_fobamt * <lfs_head>-exchangerate .
       <lfs_head>-rodtepv            = lv_rodtepamt * <lfs_head>-exchangerate .
       <lfs_head>-totaldutydrawbackv = lv_dbkamt    * <lfs_head>-exchangerate .

       MODIFY ENTITIES OF zr_shippingbilltp IN LOCAL MODE
              ENTITY zr_shippingbilltp
              UPDATE
              FIELDS ( rodtepv totaldutydrawbackv )
              WITH VALUE #( ( %tky               = <lfs_head>-%tky

                              totaldutydrawbackv = <lfs_head>-totaldutydrawbackv
                              rodtepv            = <lfs_head>-rodtepv
                            ) ).
     ENDIF.
   ENDMETHOD.

   METHOD initialize_exc_rate.
   ENDMETHOD.

   METHOD save_details.
     DATA lv_usage   TYPE zex_shipbill_hdr-usageamount.
     DATA lv_invoice TYPE zex_shipbill_hdr-usageamount.

     DATA: lv_msg TYPE string.

     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
          ENTITY zr_shippingbilltp
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(head)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(head_failed).

     READ ENTITY zr_shippingbilltp
          BY \_shippingbillitemlic
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(lic)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(lic_failed).

     READ ENTITY zr_shippingbilltp
          BY \_shippingbillitem
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(item)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(item_failed).

     ASSIGN head[ 1 ] TO FIELD-SYMBOL(<lfs_head>).
     IF sy-subrc <> 0.
       RETURN.
     ENDIF.


     IF <lfs_head>-portcode IS INITIAL.
       lv_msg = 'PortCode is mandatory'.

       APPEND VALUE #( %tky = <lfs_head>-%tky )
              TO failed-zr_shippingbilltp.

       APPEND VALUE #( %tky                  = <lfs_head>-%tky
                       %state_area           = 'Validate_Header'
                       %msg                  = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                      text     = lv_msg )
                       %element-portcode = if_abap_behv=>mk-on  )
              TO reported-zr_shippingbilltp.
     ENDIF.

     """""""""""""""" Added by Infocus Akash on 17th Nov 2025 Requested by Infocus Prithwish
     IF <lfs_head>-portcode IS NOT INITIAL.
       SELECT SINGLE gotrackcode FROM zr_shportcode_f4
          WHERE gotrackcode = @<lfs_head>-portcode
          INTO @DATA(lv_port).

       IF sy-subrc <> 0.

         APPEND VALUE #( %tky = <lfs_head>-%tky )
                  TO failed-zr_shippingbilltp.

         APPEND VALUE #(
             %tky = <lfs_head>-%tky
             %state_area = 'Validate_Header'
             %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-error
                      text     = 'Invalid Port Code. Please select from F4 help.' )
             %element-portcode = if_abap_behv=>mk-on
         ) TO reported-zr_shippingbilltp.
       ELSE.
         APPEND VALUE #(
               %tky        = <lfs_head>-%tky
               %state_area = 'Validate_Header'
                   %element-portcode = if_abap_behv=>mk-on
           ) TO reported-zr_shippingbilltp.


       ENDIF.

     ENDIF.
     IF <lfs_head>-destinationcountry IS NOT INITIAL.
       SELECT SINGLE countryname FROM zi_country_f4
          WHERE countryname = @<lfs_head>-destinationcountry
          INTO @DATA(lv_country).

       IF sy-subrc <> 0.

         APPEND VALUE #( %tky = <lfs_head>-%tky )
                  TO failed-zr_shippingbilltp.

         APPEND VALUE #(
             %tky = <lfs_head>-%tky
             %state_area = 'Validate_Header'
             %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-error
                      text     = 'Invalid Country Code. Please select from F4 help.' )
             %element-destinationcountry = if_abap_behv=>mk-on
         ) TO reported-zr_shippingbilltp.
       ELSE.
         APPEND VALUE #(
               %tky        = <lfs_head>-%tky
               %state_area = 'Validate_Header'
                   %element-destinationcountry = if_abap_behv=>mk-on
           ) TO reported-zr_shippingbilltp.


       ENDIF.

     ENDIF.

     """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

     IF <lfs_head>-customhandlingagent IS INITIAL.
       lv_msg = 'Customer Handling Agent is mandatory'.

       APPEND VALUE #( %tky = <lfs_head>-%tky )
              TO failed-zr_shippingbilltp.

       APPEND VALUE #( %tky                  = <lfs_head>-%tky
                       %state_area           = 'Validate_Header'
                       %msg                  = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                      text     = lv_msg )
                       %element-customhandlingagent = if_abap_behv=>mk-on )
              TO reported-zr_shippingbilltp.
     ENDIF.

     LOOP AT lic ASSIGNING FIELD-SYMBOL(<lfs_lic>).
       IF <lfs_lic>-usageamount > <lfs_lic>-pendingamount.
         lv_msg = |License Usage Amount is greater than Pending Amount|.

         APPEND VALUE #( %tky = <lfs_head>-%tky )
                TO failed-zr_shippingbilltp.

         APPEND VALUE #( %tky                 = <lfs_head>-%tky
                         %state_area          = 'Validate_Header'
                         %msg                 = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                       text     = lv_msg )
                         %element-usageamount = if_abap_behv=>mk-on )
                TO reported-zr_shippingbilltp.
       ENDIF.

       lv_usage += <lfs_lic>-usageamount.
     ENDLOOP.

     IF <lfs_head>-fob_lc_v IS INITIAL.

       lv_msg = |FOB Value is missing|.

       APPEND VALUE #( %tky = <lfs_head>-%tky )
              TO failed-zr_shippingbilltp.

       APPEND VALUE #( %tky              = <lfs_head>-%tky
                       %state_area       = 'Validate_Header'
                       %msg              = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                  text     = lv_msg )
                       %element-fob_lc_v = if_abap_behv=>mk-on )
              TO reported-zr_shippingbilltp.
     ENDIF.

     IF <lfs_head>-exchangerate IS INITIAL.

       lv_msg = |Exchange Rate is missing|.

       APPEND VALUE #( %tky = <lfs_head>-%tky )
              TO failed-zr_shippingbilltp.

       APPEND VALUE #( %tky                  = <lfs_head>-%tky
                       %state_area           = 'Validate_Header'
                       %msg                  = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                      text     = lv_msg )
                       %element-exchangerate = if_abap_behv=>mk-on )
              TO reported-zr_shippingbilltp.
     ENDIF.

*    IF lv_invoice <> lv_usage.
*
*      lv_msg = |Sum of the License Usage Amount is not equal to FOB FC Value|.
*
*      APPEND VALUE #( %tky = <lfs_head>-%tky )
*             TO failed-shippingbill.
*
*      APPEND VALUE #( %tky                 = <lfs_head>-%tky
*                      %state_area          = 'Validate_Header'
*                      %msg                 = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                                    text     = lv_msg )
*                      %element-UsageAmount = if_abap_behv=>mk-on )
*             TO reported-shippingbill.
*    ENDIF.


   ENDMETHOD.


*//--- RoDTEP Account Posting --------------------------//
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

     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
        ENTITY zr_shippingbilltp
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header)
        FAILED DATA(lt_header_failed).

     DATA(gfs_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
     CHECK gfs_header-tpost IS NOT INITIAL .
*//--------------------------------------------------------------------------//

     DATA(ls_entry) = gfs_header.
     SELECT SINGLE companycode FROM i_companycode
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

     gs_glitems = VALUE #(  glaccount         = '0036300020' "'0012800700'
                             amt              = ( gfs_header-rodtepv * -1 )
                             waers            = 'INR'
                             ).


     APPEND gs_glitems TO gt_glitems.

     gs_glitems = VALUE #(  glaccount         = '0012800700' "'0036300020'
                             amt              = gfs_header-rodtepv
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
     lv_acpostref = gfs_header-shippingbill && lv_time.


*//-- Set Final Journal Entry line ---
     APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
     <je_deep>-%cid = lv_cid.
     <je_deep>-%param = VALUE #(
                         companycode                  = '1000'
                         documentreferenceid          = ls_entry-shippingbill
                         businesstransactiontype      = 'RFBU'
                         accountingdocumenttype       = 'SA'
                         createdbyuser                = sy-uname
                         documentdate                 = sy-datlo
*                          postingdate                  = sy-datlo
                         postingdate                  = ls_entry-postingdatenew
                         accountingdocumentheadertext = lv_acpostref
*                        taxdeterminationdate         = sy-datlo

                         _glitems                     = VALUE #( FOR ls_item1 IN lt_glitems
                                                                  ( glaccountlineitem      = ls_item1-lv_num
                                                                    glaccount              = ls_item1-glaccount
                                                                    "businessplace          = ls_entry-busiplace
                                                                    "costcenter             = ls_item1-costcenter
                                                                    profitcenter            = '1000'
                                                                    assignmentreference    = gfs_header-shippingbill

                                                                   _currencyamount   = VALUE #( ( currencyrole           = '00'
                                                                                                  journalentryitemamount = ls_item1-amt
                                                                                                  taxbaseamount          = ls_item1-amt
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
        TO reported-zr_shippingbilltp.
         CLEAR lv_msg.
       ENDLOOP.

       TRY.
           DATA(lv_item) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
         CATCH cx_uuid_error.
           " handle exception
       ENDTRY.
       gfs_header-tpost      = ''.
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
*          DATA(lv_result) = <ls_reported_deep01>-%msg->if_message~get_text( ).
           lv_msg = <ls_reported_deep01>-%msg->if_message~get_text( ).

           APPEND VALUE #( %tky        = gfs_header-%tky
                           %state_area = 'Error_Message'
                           %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                text     = lv_msg ) )
          TO reported-zr_shippingbilltp.
           CLEAR lv_msg.
         ENDLOOP.
       ELSE. "---Success

         gfs_header-tpost      = 'X'.
         gfs_header-accpostref = lv_acpostref.
         MODIFY ENTITIES OF zr_shippingbilltp IN LOCAL MODE
                ENTITY zr_shippingbilltp
                UPDATE
                FIELDS ( accpostref )
                WITH VALUE #( FOR key IN keys
                              ( %tky           = gfs_header-%tky
*                               tpost          = gfs_header-tpost
                                accpostref     = gfs_header-accpostref

                              ) )
                 FAILED DATA(failed1)
                 REPORTED DATA(reported1).
       ENDIF.
     ENDIF.

   ENDMETHOD.

*//--- DutyDraw Back Account Posting --------------------------//

   METHOD acc_postdbk.

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

     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
        ENTITY zr_shippingbilltp
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_header)
        FAILED DATA(lt_header_failed).

     DATA(gfs_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

     CHECK gfs_header-tpostdbk IS NOT INITIAL .
*//--------------------------------------------------------------------------//

     DATA(ls_entry) = gfs_header.
     SELECT SINGLE companycode FROM i_companycode
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

     gs_glitems = VALUE #(  glaccount         = '0036300030' "'0012800720'
                             amt              = ( gfs_header-totaldutydrawbackv * -1 )
                             waers            = 'INR'
                             ).

     APPEND gs_glitems TO gt_glitems.

     gs_glitems = VALUE #(  glaccount         = '0012800720' "'0036300030'
                             amt              = gfs_header-totaldutydrawbackv
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
     lv_time = lv_time + 1.
     lv_acpostref = gfs_header-shippingbill && lv_time.


*//-- Set Final Journal Entry line ---
     APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
     <je_deep>-%cid = lv_cid.
     <je_deep>-%param = VALUE #(
                         companycode                  = '1000'
                         documentreferenceid          = ls_entry-shippingbill
                         businesstransactiontype      = 'RFBU'
                         accountingdocumenttype       = 'SA'
                         createdbyuser                = sy-uname
                         documentdate                 = sy-datlo
*                          postingdate                  = sy-datlo
                         postingdate                  = ls_entry-postingdatenew
                         accountingdocumentheadertext = lv_acpostref

                         _glitems                     = VALUE #( FOR ls_item1 IN lt_glitems
                                                                  ( glaccountlineitem      = ls_item1-lv_num
                                                                    glaccount              = ls_item1-glaccount
                                                                    profitcenter           = '1000'
                                                                    assignmentreference    = gfs_header-shippingbill

                                                                   _currencyamount   = VALUE #( ( currencyrole           = '00'
                                                                                                  journalentryitemamount = ls_item1-amt
                                                                                                  taxbaseamount          = ls_item1-amt
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
        TO reported-zr_shippingbilltp.
         CLEAR lv_msg.
       ENDLOOP.

       TRY.
           DATA(lv_item) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
         CATCH cx_uuid_error.
           " handle exception
       ENDTRY.
       gfs_header-tpostdbk      = ''.
       gfs_header-accpostrefdbk = ''.

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
*          DATA(lv_result) = <ls_reported_deep01>-%msg->if_message~get_text( ).
           lv_msg = <ls_reported_deep01>-%msg->if_message~get_text( ).

           APPEND VALUE #( %tky        = gfs_header-%tky
                           %state_area = 'Error_Message'
                           %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                text     = lv_msg ) )
          TO reported-zr_shippingbilltp.
           CLEAR lv_msg.
         ENDLOOP.
       ELSE. "---Success

         gfs_header-tpostdbk      = 'X'.
         gfs_header-accpostrefdbk = lv_acpostref.
         MODIFY ENTITIES OF zr_shippingbilltp IN LOCAL MODE
                ENTITY zr_shippingbilltp
                UPDATE
                FIELDS ( accpostrefdbk )
                WITH VALUE #( FOR key IN keys
                              ( %tky           = gfs_header-%tky
                                accpostrefdbk  = gfs_header-accpostrefdbk

                              ) )
                 FAILED DATA(failed1)
                 REPORTED DATA(reported1).
       ENDIF.
     ENDIF.

   ENDMETHOD.

   METHOD cancel.

     MODIFY ENTITIES OF zr_shippingbilltp IN LOCAL MODE
            ENTITY zr_shippingbilltp
               UPDATE
               FROM VALUE #( FOR key IN keys
                                    ( internalshipbill        = key-internalshipbill
                                      closestatus             = 'X'
                                      %control-closestatus    = if_abap_behv=>mk-on  ) )
               FAILED failed
               REPORTED reported.

     "Read changed data for action result
     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
       ENTITY zr_shippingbilltp
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT DATA(heads).

     result = VALUE #( FOR head IN heads
                       ( %tky   = head-%tky
                         %param = head ) ).

     INSERT VALUE #(
       %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Cancel' )
      ) INTO TABLE reported-zr_shippingbilltp.


   ENDMETHOD.

   METHOD update_amt.

     DATA: lv_fobamt    TYPE dmbtr,
           lv_rodtepamt TYPE dmbtr,
           lv_dbkamt    TYPE dmbtr.
     DATA: lv_rodtepvalcheck TYPE dmbtr,
           lv_dbkvalcheck    TYPE dmbtr.
*//===============================================================//
     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
                  ENTITY zr_shippingbilltp
                  ALL FIELDS
                  WITH CORRESPONDING #( keys )
                  RESULT FINAL(header)
                  FAILED FINAL(header_failed).

     DATA(ls_header) = VALUE #( header[ 1 ] OPTIONAL ) .

     READ ENTITY zr_shippingbilltp
          BY \_shippingbillitem
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_item)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(item_failed).
*//===============================================================//
     CHECK ls_header-tpost IS INITIAL AND ls_header-tpostdbk IS INITIAL .
     CHECK lt_item IS NOT INITIAL.

     lv_fobamt    = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_item
                            NEXT lv_amt = lv_amt + ls_itm-invoicevaluefcv ).
     lv_rodtepamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_item
                            NEXT lv_amt = lv_amt + ls_itm-total_rodtep_v_fc ).
     lv_dbkamt    = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_item
                            NEXT lv_amt = lv_amt + ls_itm-total_duty_drawback_v_fc ).

     lv_rodtepvalcheck = ( lv_rodtepamt * ls_header-exchangerate ).
     lv_dbkvalcheck    = ( lv_dbkamt * ls_header-exchangerate ).

     IF ls_header-fob_fc_v           = lv_fobamt AND
        ls_header-rodtepv            = lv_rodtepvalcheck AND
        ls_header-totaldutydrawbackv = lv_dbkvalcheck.
       RETURN.
     ELSE.
       "---- FOB Total value---"
       ls_header-fob_fc_v = lv_fobamt .
       ls_header-fob_lc_v = lv_fobamt * ls_header-exchangerate.

       "---- RoDTEP Total value---"
*        ls_header-rodtepv = lv_rodtepamt * ls_header-exchangerate.
       ls_header-rodtepv = lv_rodtepvalcheck .

       "---- DBK Total value---"
*        ls_header-totaldutydrawbackv = lv_dbkamt * ls_header-exchangerate.
       ls_header-totaldutydrawbackv = lv_dbkvalcheck.

       MODIFY ENTITIES OF zr_shippingbilltp IN LOCAL MODE
              ENTITY zr_shippingbilltp
              UPDATE
              FIELDS ( fob_fc_v fob_lc_v rodtepv totaldutydrawbackv )
              WITH VALUE #( ( %tky     = ls_header-%tky

                              fob_fc_v           = ls_header-fob_fc_v
                              fob_lc_v           = ls_header-fob_lc_v
                              rodtepv            = ls_header-rodtepv
                              totaldutydrawbackv = ls_header-totaldutydrawbackv
                              ) ).
     ENDIF.

   ENDMETHOD.

*    METHOD precheck_create.
*    ENDMETHOD.
*
*    METHOD precheck_update.
*    ENDMETHOD.

*   Bulk BRC Uploader Methods Implemented
*    METHOD uploadfile.
*
*      TYPES: BEGIN OF ty_excel,
*               brcno TYPE char20,
*               brcdate type dats,
*               brcvalue type char255,
*             END OF ty_excel,
*             tt_excel TYPE STANDARD TABLE OF ty_excel.
*
*      DATA: lt_excel TYPE tt_excel,
*            lv_msg   TYPE string,
*            lv_data  TYPE char30.
**----------------------------------------------------------*
*
*      READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
*           ENTITY zr_shippingbilltp
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT FINAL(lt_header)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           FAILED FINAL(lt_header_failed).
*
*      READ ENTITY zr_shippingbilltp
*           BY \_item
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT FINAL(lt_item)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           FAILED FINAL(lt_item_failed).
*
*      DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
*      IF ls_header IS INITIAL OR ls_header-attachment IS INITIAL.
*        RETURN.
*      ENDIF.
*
**// Excel Upload File
*
*      FINAL(lv_attachment) = ls_header-attachment.
*      IF lv_attachment IS NOT INITIAL.
*        FINAL(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attachment )->read_access( ).
*        FINAL(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).
*
*        FINAL(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).
*
*        FINAL(lo_execute) = lo_worksheet->select( lo_selection_pattern
*          )->row_stream(
*          )->operation->write_to( REF #( lt_excel ) ).
*
*        lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
*                   )->if_xco_xlsx_ra_operation~execute( ).
*      ENDIF.
*
*      DELETE lt_excel INDEX 1.
*      IF lt_excel[] IS INITIAL .
*        RETURN.
*      ENDIF.
*
*      SELECT a~* FROM zex_shipbill_hdr AS a
*               INNER JOIN @lt_excel AS b ON a~shipping_bill = b~shipno
*            INTO TABLE @DATA(lt_shippingbill).
*      IF sy-subrc = 0.
*        SORT lt_shippingbill BY shipping_bill.
*
*        SELECT * FROM zex_shipbill_hdr
*          FOR ALL ENTRIES IN @lt_shippingbill
*          WHERE internal_shipbill = @lt_shippingbill-internal_shipbill
*          INTO TABLE @DATA(lt_shippingbillitem).
*        IF sy-subrc = 0.
*          SORT lt_shippingbillitem BY internal_shipbill.
*        ENDIF.
*      ENDIF.
*
*      LOOP AT lt_shippingbillitem ASSIGNING FIELD-SYMBOL(<lfs_shippingbillitem>).
*        FINAL(ls_shippingbill) = VALUE #( lt_shippingbill[ internal_shipbill = <lfs_shippingbillitem>-internal_shipbill ] OPTIONAL ).
*        TRY.
*            FINAL(lv_id) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
*          CATCH cx_uuid_error.
*        ENDTRY.
*
*        MODIFY ENTITIES OF zr_scrollhead IN LOCAL MODE
*               ENTITY head
*               CREATE BY \_item
*               FROM VALUE #(
*                   ( id      = ls_header-id
*                     %target = VALUE #(
*                         ( %cid                        = lv_id
*                           item                        = lv_id
*                           scrollno                    = ls_header-scrollno
*                           shipping_bill               = ls_shippingbill-shipping_bill
*                           shipping_bill_date          = ls_shippingbill-shipping_bill_date
*                           port_code                   = ls_shippingbill-port_code
*                           port_codename               = ls_shippingbill-port_codename
*                           currency                    = 'INR'
*                           fob_lc_v                    = <lfs_shippingbillitem>-fob_lc_v
*                           rodtep_dd_v                 = COND #( WHEN ls_header-scrolltype = '1'
*                                                                 THEN <lfs_shippingbillitem>-total_rodtep_v
*                                                                 ELSE <lfs_shippingbillitem>-total_duty_drawback_v )
*
*                           %control-scrollno           = if_abap_behv=>mk-on
*                           %control-shipping_bill      = if_abap_behv=>mk-on
*                           %control-shipping_bill_date = if_abap_behv=>mk-on
*                           %control-port_code          = if_abap_behv=>mk-on
*                           %control-port_codename      = if_abap_behv=>mk-on
*                           %control-currency           = if_abap_behv=>mk-on
*                           %control-fob_lc_v           = if_abap_behv=>mk-on
*                           %control-rodtep_dd_v        = if_abap_behv=>mk-on ) ) ) )
*               " TODO: variable is assigned but never used (ABAP cleaner)
*               MAPPED FINAL(ls_mapped)
*               " TODO: variable is assigned but never used (ABAP cleaner)
*               FAILED FINAL(ls_failed)
*               " TODO: variable is assigned but never used (ABAP cleaner)
*               REPORTED FINAL(ls_reported).
*      ENDLOOP.
*
***    MODIFY ENTITIES OF zr_scrollhead IN LOCAL MODE
***                 ENTITY head
***                 UPDATE
***                 FIELDS ( mimetype attachment filename )
***                 WITH VALUE #( ( %tky       = ls_header-%tky
***
***                                 mimetype    = ''
***                                 attachment  = ''
***                                 filename    = '' ) ).
*
*    ENDMETHOD.
*
**// ----- Validation Upload File ---
*    METHOD validate_filedata.
*
*      TYPES: BEGIN OF ty_excel,
*               shipno TYPE string,
*             END OF ty_excel,
*             tt_excel TYPE STANDARD TABLE OF ty_excel.
*
*      DATA: lt_excel TYPE tt_excel,
*            lv_msg   TYPE string.
**----------------------------------------------------------*
*
*      READ ENTITIES OF zr_scrollhead IN LOCAL MODE
*           ENTITY head
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT FINAL(lt_header)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           FAILED FINAL(lt_header_failed).
*
*      READ ENTITY zr_scrollhead
*           BY \_item
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT FINAL(lt_item)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           FAILED FINAL(lt_item_failed).
*
*      DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
*      IF ls_header IS INITIAL OR ls_header-attachment IS INITIAL.
*        RETURN.
*      ENDIF.
*
**// Excel Upload File
*
*      FINAL(lv_attachment) = ls_header-attachment.
*      IF lv_attachment IS NOT INITIAL.
*        FINAL(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attachment )->read_access( ).
*        FINAL(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).
*
*        FINAL(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).
*
*        FINAL(lo_execute) = lo_worksheet->select( lo_selection_pattern
*          )->row_stream(
*          )->operation->write_to( REF #( lt_excel ) ).
*
*        lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
*                   )->if_xco_xlsx_ra_operation~execute( ).
*      ENDIF.
**//-- Validate Excel File data
*      DELETE lt_excel INDEX 1.
*      SORT lt_excel BY shipno.
*
****    IF ls_header-filename IS INITIAL.
****      lv_msg = |Please provide filename|.
****      APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head .
****
****      APPEND VALUE #( %tky        = ls_header-%tky
****                      %state_area = 'Validate_Header'
****                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
****                                                           text     = lv_msg ) )
****      TO reported-head.
****      RETURN.
****    ENDIF.
*
*      IF lt_excel[] IS INITIAL.
*        lv_msg = |No Data is Present in File|.
*        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head .
*
*        APPEND VALUE #( %tky        = ls_header-%tky
*                        %state_area = 'Validate_Header'
*                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                             text     = lv_msg ) )
*        TO reported-head.
*        RETURN.
*      ENDIF.
*
*      LOOP AT lt_excel INTO DATA(ls_excel).
*        DATA(lt_exl_tmp) = lt_excel .
*        DELETE lt_exl_tmp WHERE shipno <> ls_excel-shipno .
*        IF lines( lt_exl_tmp ) > 1 .
*          lv_msg = |Ship Bill- | && ls_excel-shipno && | Duplicate in Excel File|.
*          APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head .
*
*          APPEND VALUE #( %tky        = ls_header-%tky
*                          %state_area = 'Validate_Header'
*                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                               text     = lv_msg ) )
*          TO reported-head.
*        ENDIF.
*
*
*        SELECT SINGLE * FROM zex_shipbill_hdr WHERE shipping_bill = @ls_excel-shipno
*              INTO @DATA(ls_shipping_hed).
*        IF sy-subrc <> 0 .
*          lv_msg = |Ship Bill- | && ls_excel-shipno && | Does not Exist|.
*          APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head .
*
*          APPEND VALUE #( %tky        = ls_header-%tky
*                          %state_area = 'Validate_Header'
*                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                               text     = lv_msg ) )
*          TO reported-head.
*        ENDIF.
*
*        SELECT SINGLE * FROM zex_shipbill_hdr WHERE shipping_bill = @ls_excel-shipno
*              INTO @DATA(ls_ship_check).
*        IF sy-subrc <> 0 .
*          lv_msg = |Ship Bill- | && ls_excel-shipno && | Does not Exist|.
*          APPEND VALUE #( %tky = ls_header-%tky ) TO failed-head .
*
*          APPEND VALUE #( %tky        = ls_header-%tky
*                          %state_area = 'Validate_Header'
*                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                               text     = lv_msg ) )
*          TO reported-head.
*        ENDIF.
*
*      ENDLOOP.
*
*
*    ENDMETHOD.



 ENDCLASS.

 CLASS lhc_shippingbillitemlic DEFINITION INHERITING FROM cl_abap_behavior_handler.
   PRIVATE SECTION.

     METHODS get_instance_features FOR INSTANCE FEATURES
       IMPORTING keys REQUEST requested_features FOR zr_shippingbillilictp RESULT result.

     METHODS change_details FOR DETERMINE ON MODIFY
       IMPORTING keys FOR zr_shippingbillilictp~change_details.
     METHODS update_utilization FOR DETERMINE ON MODIFY
       IMPORTING keys FOR zr_shippingbillilictp~update_utilization.

 ENDCLASS.

 CLASS lhc_shippingbillitemlic IMPLEMENTATION.

   METHOD get_instance_features.


   ENDMETHOD.

   METHOD change_details.

     DATA: lt_epcg_ultdata TYPE STANDARD TABLE OF zr_licence_hdr.

*//===============================================================//
     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
           ENTITY zr_shippingbilltp
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT DATA(head)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(head_failed).

     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
          ENTITY zr_shippingbillilictp
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_lic)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(lic_failed).

     ASSIGN head[ 1 ] TO FIELD-SYMBOL(<lfs_head>).
     IF sy-subrc <> 0.
       RETURN.
     ENDIF.

*//===============================================================//

     CHECK lt_lic[] IS NOT INITIAL .
     CLEAR :lt_epcg_ultdata[].

* //== Get All Utilization EPCG license Data ==//
     SELECT a~* FROM zr_licence_hdr AS a
              INNER JOIN @lt_lic AS b ON a~licenceint = b~licencint
              APPENDING CORRESPONDING FIELDS OF TABLE @lt_epcg_ultdata.


* //== Update Line item Field ==//
     LOOP AT lt_lic ASSIGNING FIELD-SYMBOL(<lfs_lic>).

       "//== Get License Details ==//
       READ TABLE lt_epcg_ultdata INTO DATA(ls_epcg_ultdata) WITH KEY licenceint = <lfs_lic>-licencint .
       IF sy-subrc EQ 0.
         <lfs_lic>-licencenumber = ls_epcg_ultdata-licenceext  .
         DATA(lv_amt)  = ( ls_epcg_ultdata-boeusage + ls_epcg_ultdata-shipusage ) .

***** Old Logic *****
*          <lfs_lic>-pendingamount =  ls_epcg_ultdata-plandutysaveinr - lv_amt .

***** New Logic *****
         <lfs_lic>-pendingamount =  ls_epcg_ultdata-explicremaininr .

       ENDIF.

* //== Modify Entities Line item Field ==//
       MODIFY ENTITIES OF zr_shippingbilltp IN LOCAL MODE
              ENTITY zr_shippingbillilictp
              UPDATE
              FIELDS ( pendingamount )
              WITH VALUE #( ( %tky          = <lfs_lic>-%tky
                              pendingamount = <lfs_lic>-pendingamount ) ).
     ENDLOOP.

***    SELECT * FROM ZI_LicenseMasterTP_3
***      FOR ALL ENTRIES IN @lic
***      WHERE Licencenumber = @lic-Licencenumber
***      INTO TABLE @DATA(lt_ZI_LicenseMasterTP_3).
***    IF sy-subrc = 0.
***      SORT lt_zi_licensemastertp_3 BY Licencenumber.
***    ENDIF.
***
***    CLEAR <lfs_head>-UsageAmount.
***
***    LOOP AT lic ASSIGNING FIELD-SYMBOL(<lfs_lic>).
***      READ TABLE lt_zi_licensemastertp_3 INTO FINAL(ls_license_master) WITH KEY Licencenumber = <lfs_lic>-Licencenumber
***           BINARY SEARCH.
***      IF sy-subrc = 0.
***        <lfs_lic>-PendingAmount = ls_license_master-BalanceAmount.
***      ENDIF.
***
***      MODIFY ENTITIES OF ZR_ShippingBillTP IN LOCAL MODE
***             ENTITY ShippingBillItemLIC
***             UPDATE
***             FIELDS ( PendingAmount )
***             WITH VALUE #( ( %tky          = <lfs_lic>-%tky
***                             PendingAmount = <lfs_lic>-PendingAmount ) ).
***    ENDLOOP.
   ENDMETHOD.

   METHOD update_utilization.


     DATA: lt_epcg_ultdata TYPE STANDARD TABLE OF zr_licence_hdr.

*//===============================================================//
     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
                  ENTITY zr_shippingbilltp
                  ALL FIELDS
                  WITH CORRESPONDING #( keys )
                  RESULT FINAL(header)
                  FAILED FINAL(header_failed).

     DATA(ls_header) = VALUE #( header[ 1 ] OPTIONAL ) .

     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
          ENTITY zr_shippingbillilictp
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_item)
          FAILED FINAL(lt_item_failed).
*//===============================================================//

     CHECK lt_item[] IS NOT INITIAL .
     CLEAR :lt_epcg_ultdata[].

* //== Get All Utilization EPCG license Data ==//
     SELECT a~* FROM zr_licence_hdr AS a
              INNER JOIN @lt_item AS b ON a~licenceint = b~licencint
              APPENDING CORRESPONDING FIELDS OF TABLE @lt_epcg_ultdata.

* //== Update Line item Field ==//
     LOOP AT lt_item INTO DATA(ls_item).

       "//== Get License Details ==//
       READ TABLE lt_epcg_ultdata INTO DATA(ls_epcg_ultdata) WITH KEY licenceint = ls_item-licencint .
       IF sy-subrc EQ 0.
         ls_item-licencenumber = ls_epcg_ultdata-licenceext  .
         DATA(lv_assignamount)  = ( ls_epcg_ultdata-boeusage + ls_epcg_ultdata-shipusage ) .

****** Old Logic ******
*          ls_item-pendingamount =  ls_epcg_ultdata-plandutysaveinr - lv_assignamount .
****** New Logic ******
         ls_item-pendingamount =  ls_epcg_ultdata-explicremaininr.
         ls_item-fobfc         = ls_epcg_ultdata-liccurrency.
       ENDIF.

* //== Modify Entities Line item Field ==//
       MODIFY ENTITIES OF zr_shippingbilltp IN LOCAL MODE
               ENTITY zr_shippingbillilictp
               UPDATE
               FIELDS ( pendingamount licencenumber fobfc )
               WITH VALUE #( (   %tky           = ls_item-%tky

*                              assignamount     = ls_item-assignamount
                               pendingamount    = ls_item-pendingamount
*                              usageamount      = ls_item-usageamount
                               licencenumber    = ls_item-licencenumber
                               fobfc            = ls_item-fobfc
                               ) )
                       MAPPED FINAL(ls_mapped)
                       FAILED FINAL(ls_failed)
                       REPORTED FINAL(ls_reported).                        .
     ENDLOOP.


   ENDMETHOD.

 ENDCLASS.




 CLASS lhc_shippingbillitem DEFINITION INHERITING FROM cl_abap_behavior_handler.
   PRIVATE SECTION.

     METHODS get_instance_features FOR INSTANCE FEATURES
       IMPORTING keys REQUEST requested_features FOR zr_shippingbillitemtp RESULT result.

     METHODS change_details FOR DETERMINE ON MODIFY
       IMPORTING keys FOR zr_shippingbillitemtp~change_details.

     METHODS val_invoice FOR VALIDATE ON SAVE
       IMPORTING keys FOR zr_shippingbillitemtp~val_invoice.

*      METHODS precheck_update FOR PRECHECK
*        IMPORTING entities FOR UPDATE zr_shippingbillitemtp.

 ENDCLASS.

 CLASS lhc_shippingbillitem IMPLEMENTATION.
   METHOD get_instance_features .

     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
            ENTITY zr_shippingbilltp
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT DATA(head)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(head_failed).

     READ ENTITY zr_shippingbilltp
          BY \_shippingbillitem
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_item)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(item_failed).

     DATA(ls_head) = VALUE #( head[ 1 ] OPTIONAL ) .
     result = VALUE #( FOR gs_item IN lt_item
                       ( %tky                    = gs_item-%tky

                         %delete                  =  COND #( WHEN ( ls_head-tpostdbk = 'X' OR
                                                                    ls_head-tpost    = 'X' OR
                                                                    ls_head-closestatus = 'X') THEN if_abap_behv=>fc-o-disabled
                                                                                               ELSE if_abap_behv=>fc-o-enabled
                                                     )

                         ) ).




   ENDMETHOD.

   METHOD change_details.
     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
            ENTITY zr_shippingbilltp
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT DATA(head)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(head_failed).

     READ ENTITY zr_shippingbilltp
          BY \_shippingbillitem
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(item)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(item_failed).

     ASSIGN head[ 1 ] TO FIELD-SYMBOL(<lfs_head>).
     IF sy-subrc <> 0.
       RETURN.
     ENDIF.

     LOOP AT item ASSIGNING FIELD-SYMBOL(<lfs_item>).
       <lfs_item>-invoice = |{ <lfs_item>-invoice ALPHA = IN }|.
     ENDLOOP.

     SELECT * FROM zi_billingdocumentitem_3
       FOR ALL ENTRIES IN @item
       WHERE billingdocument = @item-invoice
       INTO TABLE @DATA(lt_billingdoc_item).
     IF sy-subrc = 0.
       SORT lt_billingdoc_item BY billingdocument.
       DATA(lt_bill_temp) = lt_billingdoc_item .
     ELSE.
       RETURN.
     ENDIF.

     CLEAR: <lfs_head>-fob_fc_v,
            <lfs_head>-fob_fc_c,
            <lfs_head>-rodtepv,
            <lfs_head>-totaldutydrawbackv.

     LOOP AT item ASSIGNING <lfs_item>.

       READ TABLE lt_billingdoc_item INTO FINAL(ls_billingdoc_item) WITH KEY billingdocument = <lfs_item>-invoice
            BINARY SEARCH.
       IF sy-subrc = 0.
         <lfs_item>-invoicedate              = ls_billingdoc_item-billingdocumentdate.
         <lfs_item>-invoicevaluefcv          = ls_billingdoc_item-netamount.
         <lfs_item>-invoicevaluefcc          = ls_billingdoc_item-transactioncurrency.
         <lfs_item>-invoicevaluelcc          = 'INR'.
         <lfs_item>-invoicevaluelcv          = ls_billingdoc_item-netamount * ls_billingdoc_item-pricedetnexchangerate.
*        <lfs_item>-total_duty_drawback_lc   = ls_billingdoc_item-dutydrawbackp.
         <lfs_item>-total_duty_drawback_v_fc = ls_billingdoc_item-dutydrawbackvfc.
         <lfs_item>-total_duty_drawback_v_lc = ls_billingdoc_item-dutydrawbackv.
*        <lfs_item>-total_rodtep_lc          = ls_billingdoc_item-rodtepp.
         <lfs_item>-total_rodtep_v_fc        = ls_billingdoc_item-rodtepvfc.
         <lfs_item>-total_rodtep_v_lc        = ls_billingdoc_item-rodtepv.

         <lfs_head>-invoicehed  = <lfs_item>-invoice.
       ENDIF.

       "-- Get PORT CODE------"
       SELECT SINGLE a~referencesddocument,
                     b~pol,b~cod,
                     c~gotrackcode
                FROM zi_billingdocumentitem AS a
                       INNER JOIN zdt_deldash_hdr AS b ON a~referencesddocument = b~delivery
                       INNER JOIN zdt_mpol_tmg AS c ON b~pol = c~polcodename
                INTO @DATA(ls_portcode).
       IF sy-subrc EQ 0 AND <lfs_head>-portcode IS INITIAL.
         <lfs_head>-portcode  = ls_portcode-gotrackcode.
         <lfs_head>-countrybl = ls_portcode-cod.
       ENDIF.

       "---- Set Exchange Rate ----"
       IF <lfs_head>-exchangerate IS INITIAL.
         <lfs_head>-exchangerate = ls_billingdoc_item-pricedetnexchangerate.
       ENDIF.

       "---- Set Header Value ----"
       <lfs_head>-fob_fc_v           += <lfs_item>-invoicevaluefcv.
       <lfs_head>-totaldutydrawbackv += <lfs_item>-total_duty_drawback_v_lc.
       <lfs_head>-rodtepv            += <lfs_item>-total_rodtep_v_lc.

       <lfs_head>-fob_fc_c  = <lfs_item>-invoicevaluefcc.
       <lfs_head>-fob_lc_v  = <lfs_head>-fob_fc_v * <lfs_head>-exchangerate.
       <lfs_head>-fob_lc_c  = 'INR'.

       "---- Set Default Exchange Rate ----"
       IF  <lfs_head>-fob_fc_c = 'INR'.
         <lfs_head>-exchangerate = '1.0000'.
       ENDIF.


       MODIFY ENTITIES OF zr_shippingbilltp IN LOCAL MODE
              ENTITY zr_shippingbillitemtp
              UPDATE
              FIELDS ( invoicedate invoicevaluefcc invoicevaluefcv invoicevaluelcc invoicevaluelcv
                       total_duty_drawback_lc total_duty_drawback_v_lc total_rodtep_lc total_rodtep_v_lc
                       total_duty_drawback_v_fc total_rodtep_v_fc )
              WITH VALUE #( ( %tky                     = <lfs_item>-%tky
                              invoicedate              = <lfs_item>-invoicedate
                              invoicevaluefcc          = <lfs_item>-invoicevaluefcc
                              invoicevaluefcv          = <lfs_item>-invoicevaluefcv
                              invoicevaluelcc          = <lfs_item>-invoicevaluelcc
                              invoicevaluelcv          = <lfs_item>-invoicevaluelcv
                              total_duty_drawback_lc   = <lfs_item>-total_duty_drawback_lc
                              total_duty_drawback_v_lc = <lfs_item>-total_duty_drawback_v_lc
                              total_rodtep_lc          = <lfs_item>-total_rodtep_lc
                              total_rodtep_v_lc        = <lfs_item>-total_rodtep_v_lc
                              total_duty_drawback_v_fc = <lfs_item>-total_duty_drawback_v_fc
                              total_rodtep_v_fc        = <lfs_item>-total_rodtep_v_fc

                            ) )
                       MAPPED FINAL(ls_mapped)
                       FAILED FINAL(ls_failed)
                       REPORTED FINAL(ls_reported).

     ENDLOOP.

     MODIFY ENTITIES OF zr_shippingbilltp IN LOCAL MODE
            ENTITY zr_shippingbilltp
            UPDATE
            FIELDS ( fob_fc_c fob_fc_v fob_lc_c fob_lc_v rodtepv totaldutydrawbackv exchangerate
                     portcode countrybl invoicehed )
            WITH VALUE #( ( %tky     = <lfs_head>-%tky

                            fob_fc_v           = <lfs_head>-fob_fc_v
                            fob_fc_c           = <lfs_head>-fob_fc_c
                            fob_lc_c           = <lfs_head>-fob_lc_c
                            fob_lc_v           = <lfs_head>-fob_lc_v
                            rodtepv            = <lfs_head>-rodtepv
                            totaldutydrawbackv = <lfs_head>-totaldutydrawbackv
                            exchangerate       = <lfs_head>-exchangerate
                            portcode           = <lfs_head>-portcode
                            countrybl          = <lfs_head>-countrybl
                            invoicehed          = <lfs_head>-invoicehed
                            ) ).

   ENDMETHOD.

*//-------- Invoice line no Validation-----//
   METHOD val_invoice.

     DATA: lv_msg  TYPE string.

     READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
          ENTITY zr_shippingbilltp
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(head)
          FAILED FINAL(head_failed).

     READ ENTITY zr_shippingbilltp
          BY \_shippingbillitem
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(item)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(item_failed).

     ASSIGN head[ 1 ] TO FIELD-SYMBOL(<lfs_head>).
     IF sy-subrc <> 0.
       RETURN.
     ENDIF.

     LOOP AT item ASSIGNING FIELD-SYMBOL(<lfs_item>).
       "---- Multiple Line item check--
       IF lines( item ) > 1 .
         lv_msg = |Multiple Invoice Tag not Allow|.
         APPEND VALUE #( %tky = <lfs_head>-%tky ) TO failed-zr_shippingbilltp.

         APPEND VALUE #( %tky        = <lfs_head>-%tky
                         %state_area = 'Validate_Item'
                         %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg ) )

         TO reported-zr_shippingbilltp.
         EXIT.
       ENDIF.

       "--- Duplicate Invoice check----
       DATA(lv_lines) = REDUCE i( INIT x = 0 FOR wa IN item WHERE ( invoice = <lfs_item>-invoice ) NEXT x = x + 1 ).
       IF lv_lines > 1.
         lv_msg = |Duplicate Entry For | &&  <lfs_item>-invoice && | in Item Line|.
         APPEND VALUE #( %tky = <lfs_head>-%tky ) TO failed-zr_shippingbilltp.

         APPEND VALUE #( %tky        = <lfs_head>-%tky
                         %state_area = 'Validate_Item'
                         %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg ) )
         TO reported-zr_shippingbilltp.
       ENDIF.

       SELECT SINGLE b~* FROM zex_shipbill_itm AS a
                         INNER JOIN zex_shipbill_hdr AS b ON a~internal_shipbill = b~internal_shipbill
                      WHERE a~invoice = @<lfs_item>-invoice AND
                            a~internal_shipbill <> @<lfs_item>-internalshipbill
                      INTO @DATA(ls_invoice).
       IF sy-subrc EQ 0 AND ls_invoice-closestatus <> 'X'.
         lv_msg = |Inv- | && <lfs_item>-invoice && | usein SB| && ls_invoice-shipping_bill.
         CONDENSE lv_msg .
         APPEND VALUE #( %tky = <lfs_head>-%tky ) TO failed-zr_shippingbilltp.

         APPEND VALUE #( %tky        = <lfs_head>-%tky
                         %state_area = 'Validate_Item'
                         %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg ) )
         TO reported-zr_shippingbilltp.
       ENDIF.


     ENDLOOP.

   ENDMETHOD.

*    METHOD precheck_update.
*
*      DATA: lv_msg  TYPE string.
*
*      READ ENTITIES OF zr_shippingbilltp IN LOCAL MODE
*           ENTITY zr_shippingbilltp
*           ALL FIELDS
*           WITH CORRESPONDING #( entities )
*           RESULT DATA(head)
*           FAILED FINAL(head_failed).
*
*      READ ENTITY zr_shippingbilltp
*           BY \_shippingbillitem
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT DATA(item)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           FAILED FINAL(item_failed).
*
*      ASSIGN head[ 1 ] TO FIELD-SYMBOL(<lfs_head>).
*      IF sy-subrc <> 0.
*        RETURN.
*      ENDIF.
*
*      LOOP AT item ASSIGNING FIELD-SYMBOL(<lfs_item>).
*        "---- Multiple Line item check--
*        IF lines( item ) > 1 .
*          lv_msg = |Multiple Invoice Tag not Allow|.
*          APPEND VALUE #( %tky = <lfs_head>-%tky ) TO failed-zr_shippingbilltp.
*
*          APPEND VALUE #( %tky        = <lfs_head>-%tky
*                          %state_area = 'Validate_Item'
*                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                               text     = lv_msg ) )
*
*          TO reported-zr_shippingbilltp.
*          EXIT.
*        ENDIF.
*
*        "--- Duplicate Invoice check----
*        DATA(lv_lines) = REDUCE i( INIT x = 0 FOR wa IN item WHERE ( invoice = <lfs_item>-invoice ) NEXT x = x + 1 ).
*        IF lv_lines > 1.
*          lv_msg = |Duplicate Entry For | &&  <lfs_item>-invoice && | in Item Line|.
*          APPEND VALUE #( %tky = <lfs_head>-%tky ) TO failed-zr_shippingbilltp.
*
*          APPEND VALUE #( %tky        = <lfs_head>-%tky
*                          %state_area = 'Validate_Item'
*                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                               text     = lv_msg ) )
*          TO reported-zr_shippingbilltp.
*        ENDIF.
*
*        SELECT SINGLE b~* FROM zex_shipbill_itm AS a
*                          INNER JOIN zex_shipbill_hdr AS b ON a~internal_shipbill = b~internal_shipbill
*                       WHERE a~invoice = @<lfs_item>-invoice AND
*                             a~internal_shipbill <> @<lfs_item>-internalshipbill
*                       INTO @DATA(ls_invoice).
*        IF sy-subrc EQ 0.
*          lv_msg = |Inv- | && <lfs_item>-invoice && | usein SB| && ls_invoice-shipping_bill.
*          CONDENSE lv_msg .
*          APPEND VALUE #( %tky = <lfs_head>-%tky ) TO failed-zr_shippingbilltp.
*
*          APPEND VALUE #( %tky        = <lfs_head>-%tky
*                          %state_area = 'Validate_Item'
*                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                               text     = lv_msg ) )
*          TO reported-zr_shippingbilltp.
*        ENDIF.
*
*
*      ENDLOOP.
*
*    ENDMETHOD.

 ENDCLASS.
