CLASS lsc_zi_ghead DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_ghead IMPLEMENTATION.

  METHOD save_modified.

    IF update-zi_ghead IS NOT INITIAL.

      DATA(lt_head) = update-zi_ghead.
      IF lt_head[ 1 ]-tprint = 'X'.
        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
             iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
             iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).
            SELECT SINGLE * FROM zr_printqueue
              WHERE cbuser = @sy-uname
               INTO @DATA(ls_queue).

            IF sy-subrc IS NOT INITIAL.

              ls_queue-printque = 'ZDEFAULT'.

            ENDIF.
            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZSD_GATEPASS_01' ) .


            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'GATEFORM' ).
                "   out->write( 'Schema found in form' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
                "" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
                "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
*                  lo_store->set_schema(
*                    iv_form_name = 'GATEFORM'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
                "" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys)     = lo_fdp_util->get_keys( ).
            lt_keys[ name = 'ID' ]-value = lt_head[ 1 ]-id.

            TRY.
                DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
                "out->write( 'Service data retrieved' ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception).
            ENDTRY..

            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'GATEFORM'
              iv_template_name = 'GATEFORM'
            ).

            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      = CONV zde_pqname( ls_queue-printque ) "'YYGATEFORM' "'PRINT_QUEUE'
                iv_xml_data     = lv_xml
                iv_xdp_layout   = ls_template-xdp_template
                is_options      = VALUE #(
                  trace_level = 4 "Use 0 in production environment
            )
              IMPORTING
                ev_trace_string = DATA(lv_trace)
                ev_pdl          = DATA(lv_pdf)
            ).
            DATA: lv_name TYPE char120.
            lv_name = |Gatepass Print { lt_head[ 1 ]-gatepass }|.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = CONV zde_pqname( ls_queue-printque ) "'YYGATEFORM'
              iv_print_data       = lv_pdf
              iv_name_of_main_doc = lv_name
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
            " out->write( 'Exception occurred.' ).
        ENDTRY.
        "out->write( 'Finished processing.' ).
      ENDIF.
    ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_ghead DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_ghead RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_ghead RESULT result.

*    METHODS cancel FOR MODIFY
*      IMPORTING keys FOR ACTION zi_ghead~cancel RESULT result.

    METHODS deleted FOR MODIFY
      IMPORTING keys FOR ACTION zi_ghead~deleted RESULT result.

    METHODS gatepassout FOR MODIFY
      IMPORTING keys FOR ACTION zi_ghead~gatepassout RESULT result.

    METHODS print FOR MODIFY
      IMPORTING keys FOR ACTION zi_ghead~print RESULT result.

    METHODS determinegatepassnumber FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_ghead~determinegatepassnumber.

    METHODS mandatefieldsheader FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_ghead~mandatefieldsheader.

*    METHODS wlfpl FOR MODIFY
*      IMPORTING keys FOR ACTION zi_ghead~wlfpl RESULT result.

    METHODS item FOR MODIFY
      IMPORTING keys FOR ACTION zi_ghead~item RESULT result.

    METHODS checkvehicle FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_ghead~checkvehicle.

    METHODS checkperchal FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_ghead~checkperchal.

    METHODS checkqty FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_ghead~checkqty.

    METHODS challanno_date FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_ghead~challanno_date.

    METHODS headerdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_ghead~headerdetails.
    METHODS vendorcodeupdate FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_ghead~vendorcodeupdate.
    METHODS vehiclecheck FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_ghead~vehiclecheck.
    METHODS create FOR MODIFY
      IMPORTING keys FOR ACTION zi_ghead~create RESULT result.
    METHODS methodrgp FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_ghead~methodrgp.
    METHODS checkuniquechallan FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_ghead~checkuniquechallan.
    METHODS methoddeliveryno FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_ghead~methoddeliveryno.
    METHODS gateitem FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_ghead~gateitem.
    METHODS transporterdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_ghead~transporterdetails.
    METHODS tprint FOR MODIFY
      IMPORTING keys FOR ACTION zi_ghead~tprint RESULT result.

    METHODS customer_name FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_ghead~customer_name.
    METHODS checkauth FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_ghead~checkauth.
*    METHODS weighment_wt FOR DETERMINE ON SAVE
*      IMPORTING keys FOR zi_ghead~weighment_wt.

ENDCLASS.


CLASS lhc_zi_ghead IMPLEMENTATION.
  METHOD get_instance_features.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).
    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>).
    SELECT SINGLE * FROM zdt_gitem WHERE id = @<head>-id INTO @DATA(lv_gitem).
    IF lv_gitem IS NOT INITIAL.
      DATA(lv_subrc) = 'X'.
    ENDIF.
    DATA flag TYPE char1.
    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

*select single * from  YY1_MM_GATEUSERS into @data(ls_gateusers) .

    IF lv_date = <head>-gateentrydate.
      flag = 'X'.
    ENDIF.

    SELECT SINGLE * FROM zdt_userid
    WHERE userid = @sy-uname
     INTO @DATA(ls_user).
    IF sy-subrc EQ 0 AND ls_user-deleteable = 'X'.
      DATA(flagdelete) = 'X'.
    ENDIF.

*    IF <head>-status = 'Confirm' AND ls_user-edit IS INITIAL.
*      DATA(flagedit) = 'X'.
*    ENDIF.


*    IF <head>-status = 'Deleted' OR <head>-status = 'Exit Confirmed'.
*      flagedit = 'X'.
*    ENDIF.

    IF ls_user-edit IS INITIAL.
      IF <head>-status = 'Deleted' OR <head>-status = 'Exit Confirmed' OR <head>-status = 'Confirm'.
        DATA(flagedit) = 'X'.
      ENDIF.
    ENDIF.


*    IF <head>-type = 'RGP'.
*      SELECT * FROM zdt_gitem WHERE id = @<head>-id INTO TABLE @DATA(lt_gitem).
*      LOOP AT lt_gitem INTO DATA(ls_i) WHERE challanqty IS INITIAL.
*        lv_subrc = ''.
*      ENDLOOP.
*    ENDIF.
    result = VALUE #(
        FOR gs_header IN header
        ( %tky                            = gs_header-%tky

          %assoc-_item                    = COND #(  WHEN ls_user-edit IS NOT INITIAL
                                                     THEN  if_abap_behv=>fc-o-enabled
                                                     WHEN ( gs_header-status = 'Canceled' OR gs_header-status = 'Exit Confirmed'
                                                            OR gs_header-status = 'Deleted' OR gs_header-status = 'Confirm' ) THEN
                                                       if_abap_behv=>fc-o-disabled
                                                     WHEN gs_header-gatepass IS INITIAL OR gs_header-gatepass = '0000000000'
                                                      " OR gs_header-type      = 'SALES' OR gs_header-type     = 'SALES RETURN'
                                                       OR gs_header-gateout IS NOT INITIAL THEN
                                                       if_abap_behv=>fc-o-disabled
                                                     WHEN gs_header-gatepass IS NOT INITIAL THEN
                                                       if_abap_behv=>fc-o-enabled )
          %field-customercode             = COND #( WHEN gs_header-type = 'PO' OR flagedit = 'X' OR gs_header-type = 'NONPO / SERVICE' OR gs_header-type = 'RGP' OR gs_header-type = 'STO'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %action-edit                    = COND #( WHEN ls_user-edit IS NOT INITIAL
                                                    THEN  if_abap_behv=>fc-o-enabled
                                                    WHEN  (  ( <head>-vehicleouttime IS NOT INITIAL OR <head>-deleteuser IS NOT INITIAL
                                                            OR <head>-cancel         IS NOT INITIAL ) AND ( <head>-gateentrydate <> sy-datum ) )
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    WHEN ( <head>-status = 'Deleted' OR <head>-status = 'Exit Confirmed'
                                                           OR gs_header-status = 'Deleted' OR gs_header-status = 'Confirm' )
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled )
*          %action-wlfpl                   = COND #( WHEN gs_header-type      = 'PO'        OR gs_header-type     = 'NONPO / SERVICE' OR gs_header-type       = 'RGP'       OR gs_header-type     = 'STO'
*                                                      OR gs_header-gatepass IS INITIAL     OR gs_header-gateout IS NOT INITIAL       OR gs_header-%is_draft IS NOT INITIAL OR <head>-deleteuser IS NOT INITIAL
*                                                      OR <head>-cancel      IS NOT INITIAL
*                                                    THEN if_abap_behv=>fc-o-disabled
*                                                    ELSE if_abap_behv=>fc-o-disabled )
          %action-item                    = COND #( WHEN gs_header-type       = 'PO'        OR gs_header-type         = 'NONPO / SERVICE' OR gs_header-type     = 'RGP'       OR gs_header-type     = 'STO'
                                                      OR gs_header-%is_draft IS NOT INITIAL OR gs_header-gatepass    IS INITIAL           OR gs_header-gateout IS NOT INITIAL OR <head>-deleteuser IS NOT INITIAL
                                                      OR <head>-cancel       IS NOT INITIAL OR gs_header-plantgateno CS 'WL'
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %action-deleted                 = COND #( WHEN flagdelete IS NOT INITIAL THEN
                                                      if_abap_behv=>fc-o-enabled
*                                                    WHEN gs_header-gatepass  IS INITIAL
*                                                      OR gs_header-%is_draft IS NOT INITIAL OR gs_header-gatepass = '0000000000' OR gs_header-gateout IS NOT INITIAL OR <head>-deleteuser IS NOT INITIAL
*                                                      OR <head>-cancel       IS NOT INITIAL THEN
*                                                      if_abap_behv=>fc-o-disabled
*                                                    WHEN <head>-vehicleouttime IS NOT INITIAL OR gs_header-gatepass IS INITIAL THEN
*                                                      if_abap_behv=>fc-o-disabled
*                                                      WHEN <head>-status = 'Created'
*                                                      THEN if_abap_behv=>fc-o-enabled
                                                      ELSE
                                                      if_abap_behv=>fc-o-disabled )

          %action-gatepassout             = COND #( WHEN gs_header-gatepass  IS INITIAL
                                                      OR gs_header-%is_draft IS NOT INITIAL OR gs_header-gateout IS NOT INITIAL OR <head>-deleteuser IS NOT INITIAL
                                                      OR <head>-cancel       IS NOT INITIAL OR gs_header-status = 'Created'
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled )

*          %action-cancel                  = COND #( WHEN gs_header-gatepass  IS INITIAL
*                                                      OR gs_header-%is_draft IS NOT INITIAL OR gs_header-gateout IS NOT INITIAL OR <head>-deleteuser IS NOT INITIAL
*                                                      OR <head>-cancel       IS NOT INITIAL
*                                                    THEN if_abap_behv=>fc-o-disabled
*                                                    ELSE if_abap_behv=>fc-o-enabled )
          %action-create                  = COND #( WHEN gs_header-gatepass IS  INITIAL OR gs_header-%is_draft IS NOT INITIAL OR <head>-deleteuser IS NOT INITIAL
                                                      OR <head>-cancel      IS NOT INITIAL "or gs_header-Status = 'Confirm'
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled )

          %field-challannumber            = COND #( WHEN flagedit = 'X' AND NOT gs_header-plantgateno CS 'WL' THEN
                                                      if_abap_behv=>fc-f-read_only
                                                    WHEN  gs_header-cancel IS NOT INITIAL OR gs_header-deleted IS NOT INITIAL THEN
                                                      if_abap_behv=>fc-f-read_only
                                                    ELSE
                                                      if_abap_behv=>fc-o-enabled )

          %field-challandate              = COND #( WHEN gs_header-deleted IS NOT INITIAL
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )

          %field-miningchallantpno        = COND #( WHEN gs_header-gateout IS NOT INITIAL OR gs_header-type = 'NONPO / SERVICE' OR gs_header-type = 'RGP'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )

          %field-miningpermissionno       = COND #( WHEN gs_header-gateout IS NOT INITIAL OR gs_header-type = 'NONPO / SERVICE' OR gs_header-type = 'RGP'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )

          %field-rrno                     = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-rrdate                   = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-rgpgatepass              = COND #( WHEN ( gs_header-type = 'RETURN RGP' OR gs_header-type = 'STO INBOUND' )
                                                    THEN if_abap_behv=>fc-o-enabled
                                                    WHEN flagedit = 'X' THEN
                                                      if_abap_behv=>fc-f-read_only
                                                    ELSE
                                                      if_abap_behv=>fc-f-read_only )

          %field-lrblno                   = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-lbbldate                 = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-vendorcode               = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-drivername               = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-deliverynumber               = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
***          %field-customername             = COND #( WHEN flagedit = 'X'
***                                                    THEN if_abap_behv=>fc-f-read_only
***                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-drivercellno             = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-dlno                     = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-vehiclecheck             = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-billofentryno            = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-billofentrydate          = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-testcertificate          = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-taxinvoice               = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-transportercode          = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-transportername          = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE  if_abap_behv=>fc-f-read_only )
          %field-invoice                  = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-invoicedate              = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
*          %field-remarks                  = COND #( WHEN gs_header-gatepass IS NOT INITIAL
*                                                    THEN if_abap_behv=>fc-f-read_only
*                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-gatepassdate             = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-purchasingdocumentnumber = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-unloaddate               = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-unloadtime               = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-cancel                   = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-miscnumber               = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-miscdate                 = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-currentnumber            = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
*          %field-criticality              = COND #( WHEN gs_header-gatepass IS NOT INITIAL
*                                                    THEN if_abap_behv=>fc-f-read_only
*                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-printr                   = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
*          %field-wlfpl                    = COND #( WHEN flagedit = 'X'
*                                                    THEN if_abap_behv=>fc-f-read_only
*                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-item                     = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-fromplace                = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-toplace                  = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-multiweight              = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-noofweight               = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-waybillno                = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-plantweighbridgeno       = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )

          %field-containernumber          = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )

          %field-vesselname               = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )

          %field-rakeno                   = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )

          %field-raketripno               = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )

          %field-sendername               = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )

          %field-vehno                    = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-mpno                     = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )
          %field-remarks                  = COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )

         %field-vendor_grswt =    COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )

          %field-vendor_netwt =    COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )

         %field-vendor_tarwt =    COND #( WHEN flagedit = 'X'
                                                    THEN if_abap_behv=>fc-f-read_only
                                                    ELSE if_abap_behv=>fc-o-enabled )

                                                     )
                   ) .


  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD cancel.
*    DATA lv_date TYPE datn.
*    DATA lv_time TYPE timn.
*
*    READ ENTITIES OF zi_ghead IN LOCAL MODE
*         ENTITY zi_ghead
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT DATA(header_check).
*
*    ASSIGN header_check[ 1 ] TO FIELD-SYMBOL(<head>).
*    IF sy-subrc = 0 AND <head>-remarks IS INITIAL.
*
*      APPEND VALUE #( %tky = <head>-%tky ) TO failed-zi_ghead.
*
*      APPEND VALUE #( %tky             = <head>-%tky
*                      %state_area      = 'Validate_Header'
*                      %msg             = new_message_with_text(
*                                             severity = if_abap_behv_message=>severity-error
*                                             text     = 'Please provide the GatePass Cancellation Remarks' )
*                      %element-remarks = if_abap_behv=>mk-on )
*             TO reported-zi_ghead.
*    ELSE.
*
*      TRY.
*          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
*                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
*        CATCH cx_abap_context_info_error.
*      ENDTRY.
*
*      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
*
*      <head>-deleted    = 'X'.
*      <head>-deletedate = lv_date.
*      <head>-deleteuser = lv_time.
*      <head>-status     = 'Canceled'.
*
*      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*             ENTITY zi_ghead
*             UPDATE
*             FIELDS ( deleted deletedate deleteuser remarks status )
*             WITH VALUE #( FOR key IN keys
*                           ( %tky       = key-%tky
*                             deleted    = <head>-deleted
*                             deletedate = <head>-deletedate
*                             deleteuser = <head>-deleteuser
*                             remarks    = <head>-remarks
*                             status     = <head>-status ) )
*             FAILED failed
*             REPORTED reported.
*
*    ENDIF.
*
*    READ ENTITIES OF zi_ghead IN LOCAL MODE
*         ENTITY zi_ghead
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(header_1).
*
*    result = VALUE #( FOR ls_header IN header_1
*                      ( %tky   = ls_header-%tky
*                        %param = ls_header ) ).
*  ENDMETHOD.

  METHOD deleted.
    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header_check).

    ASSIGN header_check[ 1 ] TO FIELD-SYMBOL(<head>).
    IF sy-subrc = 0 AND <head>-remarks IS INITIAL.

      APPEND VALUE #( %tky = <head>-%tky ) TO failed-zi_ghead.

      APPEND VALUE #( %tky             = <head>-%tky
                      %state_area      = 'Validate_Header'
                      %msg             = new_message_with_text(
                                             severity = if_abap_behv_message=>severity-error
                                             text     = 'Please provide the GatePass Cancellation Remarks' )
                      %element-remarks = if_abap_behv=>mk-on )
             TO reported-zi_ghead.
    ELSE.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      <head>-deleted    = 'X'.
      <head>-deletedate = lv_date.
      <head>-deleteuser = sy-uname.
      <head>-status     = 'Deleted'.

      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
             ENTITY zi_ghead
             UPDATE
             FIELDS ( deleted deletedate deleteuser remarks status )
             WITH VALUE #( FOR key IN keys
                           ( %tky       = key-%tky
                             deleted    = <head>-deleted
                             deletedate = <head>-deletedate
                             deleteuser = <head>-deleteuser
                             remarks    = <head>-remarks
                             status     = <head>-status ) )
             FAILED failed
             REPORTED reported.

    ENDIF.

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD gatepassout.
    DATA lv_date TYPE datn.
    DATA lv_time TYPE timn.

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header).
    READ ENTITY zi_ghead
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_itm)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(itm_failed).
    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>).
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    SELECT SINGLE * FROM zdt_ghead WHERE gatepass = @<head>-gatepass INTO @DATA(wa_head).
*    SELECT SINGLE * FROM zwt_bg
*      WHERE gateno = @wa_head-gatepass
*      INTO @DATA(wa_bg).
    IF sy-subrc = 0.
*    AND wa_bg-brgew IS NOT INITIAL AND wa_bg-ntgew IS NOT INITIAL
*       AND wa_bg-trgew IS NOT INITIAL.
      IF <head>-type EQ 'SALES' OR <head>-type EQ 'SALES RETURN' .
        LOOP AT lt_itm INTO DATA(ls_itm).
          SELECT SINGLE * FROM i_deliverydocument
            WHERE deliverydocument = @ls_itm-vbeln
            INTO @DATA(lv_data).
          IF lv_data-overallgoodsmovementstatus = 'C'.
            CONTINUE.
          ENDIF.

          DATA(lv_msg2) = |PGI/PGR is not completed for the delivery|.

          APPEND VALUE #( %tky = <head>-%tky )
                 TO failed-zi_ghead.

          APPEND VALUE #( %tky        = <head>-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg2 ) )

                 TO reported-zi_ghead.
          RETURN.
        ENDLOOP.

      ENDIF.
      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      <head>-gateout        = 'X'.
      <head>-vehicleoutdate = lv_date.
      <head>-vehicleouttime = lv_time.
      <head>-status         = 'Exit Confirmed'.

      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
             ENTITY zi_ghead
             UPDATE
             FIELDS ( gateout vehicleoutdate vehicleouttime status )
             WITH VALUE #( FOR key IN keys
                           ( %tky           = key-%tky
                             gateout        = <head>-gateout
                             vehicleoutdate = <head>-vehicleoutdate
                             vehicleouttime = <head>-vehicleouttime
                             status         = <head>-status
*                             grswt          = wa_bg-brgew
*                             netwt          = wa_bg-ntgew
*                             tarwt          = wa_bg-trgew
) )
             FAILED failed
             REPORTED reported.

    ELSEIF <head>-plantweighbridgeno = 'NA'.

      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP FINAL(lv_timestamp1) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp1 TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.

      <head>-gateout        = 'X'.
      <head>-vehicleoutdate = lv_date.
      <head>-vehicleouttime = lv_time.
      <head>-status         = 'Exit Confirmed'.

      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
             ENTITY zi_ghead
             UPDATE
             FIELDS ( gateout vehicleoutdate vehicleouttime status )
             WITH VALUE #( FOR key IN keys
                           ( %tky           = key-%tky
                             gateout        = <head>-gateout
                             vehicleoutdate = <head>-vehicleoutdate
                             vehicleouttime = <head>-vehicleouttime
                             status         = <head>-status ) )
             FAILED failed
             REPORTED reported.

    ENDIF.

    " Fill the response table
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD print.

  ENDMETHOD.

  METHOD determinegatepassnumber.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(header_failed).

    " ---------------------------------------------------------------------
    " ==GatePass number creation on create action
    " ---------------------------------------------------------------------
    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-gatepass IS INITIAL.
      SELECT SINGLE suppliername AS supplierfullname FROM zr_supplier_f4
        WHERE supplier = @( |{ gfs_header-vendorcode ALPHA = IN }| )
        INTO @DATA(lv_data).
*      SELECT SINGLE MAX( gatepass ) FROM zdt_ghead INTO @DATA(lv_gatepass).
*      lv_gatepass += 1.
       TRY.

          CALL METHOD cl_numberrange_runtime=>number_get
            EXPORTING
              nr_range_nr = '01'
              object      = 'Z_NR_G_PAS'
            IMPORTING
              number      = DATA(lv_gatepass)
              returncode  = DATA(lv_rcode).

*          SHIFT lv_gatepass LEFT DELETING LEADING '0'.

*          DATA(lo_get_number) = cl_numberrange_buffer=>get_instance( ).
*          lo_get_number->if_numberrange_buffer~number_get_parallel(
*                                         EXPORTING
*                                           iv_object    = 'ZEX_EPCG'
*                                           iv_interval  = '01'
***                                       iv_subobject = lv_subobject
***                                       iv_toyear    = lv_year
*                                         IMPORTING
*                                            ev_number    = DATA(lv_number) ).
        CATCH cx_number_ranges INTO DATA(lr_error).
      ENDTRY .
      gfs_header-gatepass = lv_gatepass.

      DATA(gfs_header1) = VALUE #( header[ 1 ]  OPTIONAL ).
      gfs_header1-gateentrydate = sy-datum.
      TRY.
*             CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
*             INTO TIME STAMP DATA(lv_datetime) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
          GET TIME STAMP FIELD DATA(lv_utctimestamp).
          CONVERT TIME STAMP lv_utctimestamp TIME ZONE 'INDIA' INTO DATE DATA(lv_date) TIME DATA(lv_time).
          CONVERT DATE lv_date TIME lv_time INTO TIME STAMP DATA(lv_datetime) TIME ZONE 'INDIA'.
          gfs_header1-gateentrytime = lv_time.
        CATCH cx_abap_context_info_error.
      ENDTRY.
      gfs_header1-vendorname    = lv_data.
      "gfs_header1-challandate = sy-datum.
      TRANSLATE gfs_header1-vehno TO UPPER CASE.
      CONDENSE gfs_header1-vehno NO-GAPS.
      IF gfs_header-type = 'RGP'.
        TRY.
*             CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
*             INTO TIME STAMP DATA(lv_datetime) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
            GET TIME STAMP FIELD DATA(lv_utctimestamp1).
            CONVERT TIME STAMP lv_utctimestamp1 TIME ZONE 'INDIA' INTO DATE DATA(lv_date1) TIME DATA(lv_time1).
            CONVERT DATE lv_date1 TIME lv_time1 INTO TIME STAMP DATA(lv_datetime1) TIME ZONE 'INDIA'.
            CONCATENATE lv_date1 lv_time1 INTO gfs_header-challannumber.
          CATCH cx_abap_context_info_error.
        ENDTRY.
      ENDIF.
      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
             ENTITY zi_ghead
             UPDATE
             FIELDS (  gatepass gateentrytime gateentrydate vendorname vehno challannumber )
             WITH VALUE #( ( %tky          = gfs_header-%tky

                             gatepass      = gfs_header-gatepass
                             gateentrydate = gfs_header1-gateentrydate
                             gateentrytime = gfs_header1-gateentrytime
                             vendorname    = gfs_header1-vendorname
                             challannumber = gfs_header-challannumber
                          ""   challandate = gfs_header1-challandate
                             vehno         = gfs_header1-vehno ) ).
    ELSE.

    ENDIF.

*    DATA : l_item      TYPE zdt_gitem-gateitem,
*           l_item_numc TYPE zde_gateitem.
*
*    READ ENTITIES OF zi_ghead IN LOCAL MODE
*         ENTITY zi_ghead
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(lt_header)
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         FAILED FINAL(lt_header_failed).
*
*    READ ENTITY zi_ghead
*       BY \_item
*       ALL FIELDS
*       WITH CORRESPONDING #( keys )
*       RESULT FINAL(lt_item)
*       " TODO: variable is assigned but never used (ABAP cleaner)
*       FAILED FINAL(lt_item_failed).
*
*    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
*    CLEAR : l_item , l_item_numc.
*    LOOP AT lt_item INTO DATA(ls_item).
*
*      l_item_numc = l_item_numc + 10.
*      l_item = l_item_numc.
*      ls_item-gateitem = l_item.
*
*
*      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*             ENTITY zi_gitem
*             UPDATE
*             FIELDS (  gateitem ) "
*             WITH VALUE #( id = ls_item-id
*                           ( %tky       = ls_item-%tky
*                             gateitem = ls_item-gateitem  ) ).
*    ENDLOOP.

  ENDMETHOD.

  METHOD mandatefieldsheader.
    DATA: lv_msg_new TYPE string .
*-----------------------------------------------------------------------------------------*
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED DATA(header_failed).

    READ ENTITY zi_ghead
       BY \_item
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT FINAL(lt_item)
       " TODO: variable is assigned but never used (ABAP cleaner)
       FAILED FINAL(lt_item_failed).
*-----------------------------------------------------------------------------------------*
    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).
    DATA(ls_new) = VALUE #( header[ 1 ]  OPTIONAL ).

    IF gfs_header-challannumber IS INITIAL AND
    ( gfs_header-type <> 'SALES' AND gfs_header-type <> 'SALES RETURN' AND
      gfs_header-type <> 'RGP'   AND gfs_header-type <> 'NRGP'         AND
      gfs_header-type <> 'STO OUTBOUND' AND gfs_header-type <> 'CASH ENTRY' ).                    "By SN for Cash Entry

      DATA(lv_msg) = |Please provide the Challan Number|.
      APPEND VALUE #( %tky = gfs_header-%tky )
             TO failed-zi_ghead.

      APPEND VALUE #( %tky           = gfs_header-%tky
                      %state_area    = 'Validate_Header'
                      %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg )
                      %element-vehno = if_abap_behv=>mk-on )
             TO reported-zi_ghead.
    ENDIF.
    IF gfs_header-challandate IS INITIAL AND
     ( gfs_header-type <> 'SALES' AND gfs_header-type <> 'SALES RETURN' AND
       gfs_header-type <> 'RGP'  AND gfs_header-type <> 'NRGP'  AND
       gfs_header-type <> 'STO OUTBOUND' AND  gfs_header-type <> 'CASH ENTRY' ).                  "By SN for Cash Entry

      DATA(lv_msg1) = |Please provide the Challan Date|.
      APPEND VALUE #( %tky = gfs_header-%tky )
             TO failed-zi_ghead.

      APPEND VALUE #( %tky           = gfs_header-%tky
                      %state_area    = 'Validate_Header'
                      %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg1 )
                      %element-vehno = if_abap_behv=>mk-on )
             TO reported-zi_ghead.
    ENDIF.

    IF gfs_header-rgpgatepass IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_ghead WHERE gatepass = @gfs_header-rgpgatepass  INTO @DATA(ls_ghead1).
      IF ls_ghead1-plant <> gfs_header-plant .
        DATA(lv_msg223) = |Plant of Return RGP not matches RGP Plant|.
        APPEND VALUE #( %tky = gfs_header-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky           = gfs_header-%tky
                        %state_area    = 'Validate_Header'
                        %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                text     = lv_msg223 )
                        %element-vehno = if_abap_behv=>mk-on )
               TO reported-zi_ghead.
      ENDIF.
    ENDIF.


    IF ( gfs_header-transportercode IS INITIAL AND ( gfs_header-type = 'SALES' OR gfs_header-type = 'SALES RETURN' ) ).
*      DATA(lv_msg226) = |Transporter code is mandatory for SALES outward|.
*      APPEND VALUE #( %tky = gfs_header-%tky )
*             TO failed-zi_ghead.
*
*      APPEND VALUE #( %tky           = gfs_header-%tky
*                      %state_area    = 'Validate_Header'
*                      %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                              text     = lv_msg226 )
*                      %element-vehno = if_abap_behv=>mk-on )
*             TO reported-zi_ghead.
    ENDIF.

    IF gfs_header-deliverynumber IS NOT INITIAL.

DATA lv_delivery TYPE i_deliverydocument-deliverydocument.

lv_delivery = |{ gfs_header-deliverynumber ALPHA = IN }|.

SELECT SINGLE *
  FROM i_deliverydocument
  WHERE deliverydocument =  @lv_delivery
  INTO @DATA(ls_plant_sales).


      IF ls_plant_sales-shippingpoint <> gfs_header-plantgateno.
        DATA(lv_msg224) = |Plant does not matches with Delivery Document Plant|.
        APPEND VALUE #( %tky = gfs_header-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky           = gfs_header-%tky
                        %state_area    = 'Validate_Header'
                        %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                text     = lv_msg224 )
                        %element-vehno = if_abap_behv=>mk-on )
               TO reported-zi_ghead.
      ENDIF.

    ENDIF.
*    IF gfs_header-plantweighbridgeno IS INITIAL.    //commented by Surajit 12.02
*      IF NOT gfs_header-plantgateno CS 'WL'.
*        DATA(lv_msg2) = |Please provide the Plant Weighbridgeno|.
*        APPEND VALUE #( %tky = gfs_header-%tky )
*               TO failed-zi_ghead.
*
*        APPEND VALUE #( %tky           = gfs_header-%tky
*                        %state_area    = 'Validate_Header'
*                        %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                                text     = lv_msg2 )
*                        %element-vehno = if_abap_behv=>mk-on )
*               TO reported-zi_ghead.
*      ENDIF.
*    ENDIF.
    IF gfs_header-vendorcode IS INITIAL AND
     ( gfs_header-type <> 'SALES' AND gfs_header-type <> 'SALES RETURN' AND
       gfs_header-type <> 'STO OUTBOUND').
      DATA(lv_msg3) = |Please provide the Vendor Code|.
      APPEND VALUE #( %tky = gfs_header-%tky )
             TO failed-zi_ghead.

      APPEND VALUE #( %tky           = gfs_header-%tky
                      %state_area    = 'Validate_Header'
                      %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg3 )
                      %element-vehno = if_abap_behv=>mk-on )
             TO reported-zi_ghead.
    ENDIF.

    IF ( ( gfs_header-type = 'RGP' OR gfs_header-type = 'NRGP' OR gfs_header-type = 'STO OUTWARD' ) AND gfs_header-sendername IS INITIAL ).
      DATA(lv_msg4) = |Please provide the sender name|.
      APPEND VALUE #( %tky = gfs_header-%tky )
             TO failed-zi_ghead.

      APPEND VALUE #( %tky           = gfs_header-%tky
                      %state_area    = 'Validate_Header'
                      %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg4 )
                      %element-vehno = if_abap_behv=>mk-on )
             TO reported-zi_ghead.
    ENDIF.

    IF gfs_header-vehno IS INITIAL AND ( gfs_header-shipmenttype = 'AUTO' OR gfs_header-shipmenttype = 'BULKER'
    OR gfs_header-shipmenttype = 'BY COURIER' OR gfs_header-shipmenttype = 'BY CONTAINER' OR gfs_header-shipmenttype = 'LMV'
    OR gfs_header-shipmenttype = 'MINI-TRUCK' OR gfs_header-shipmenttype = 'TRAILER'   ).
      DATA(lv_msg12) = |Please provide the Vehicle Number|.
      APPEND VALUE #( %tky = gfs_header-%tky )
             TO failed-zi_ghead.

      APPEND VALUE #( %tky           = gfs_header-%tky
                      %state_area    = 'Validate_Header'
                      %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg12 )
                      %element-vehno = if_abap_behv=>mk-on )
             TO reported-zi_ghead.
    ENDIF.

    IF gfs_header-rgpgatepass IS INITIAL AND gfs_header-type = 'RETURN RGP'.
      lv_msg4 = |Please provide RGP Gate Pass Number|.
      APPEND VALUE #( %tky = gfs_header-%tky )
             TO failed-zi_ghead.

      APPEND VALUE #( %tky           = gfs_header-%tky
                      %state_area    = 'Validate_Header'
                      %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg4 )
                      %element-vehno = if_abap_behv=>mk-on )
             TO reported-zi_ghead.
    ENDIF.
    IF gfs_header-gateentrydate IS INITIAL.
      IF ( gfs_header-challandate <> sy-datum AND ( gfs_header-type = 'RGP' OR gfs_header-type = 'NRGP' ) ).
        lv_msg4 = |Please provide today's date as Challan Date|.
        APPEND VALUE #( %tky = gfs_header-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky           = gfs_header-%tky
                        %state_area    = 'Validate_Header'
                        %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                text     = lv_msg4 )
                        %element-vehno = if_abap_behv=>mk-on )
               TO reported-zi_ghead.
      ENDIF.
    ELSE.
      IF ( gfs_header-challandate <> gfs_header-gateentrydate AND ( gfs_header-type = 'RGP' OR gfs_header-type = 'NRGP' ) ).
        lv_msg4 = |Please provide today's date as Challan Date|.
        APPEND VALUE #( %tky = gfs_header-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky           = gfs_header-%tky
                        %state_area    = 'Validate_Header'
                        %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                text     = lv_msg4 )
                        %element-vehno = if_abap_behv=>mk-on )
               TO reported-zi_ghead.
      ENDIF.
    ENDIF.

    IF gfs_header-deliverynumber IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_ghead WHERE deliverynumber = @gfs_header-deliverynumber AND gatepass <> @gfs_header-gatepass AND deleted IS INITIAL
       INTO @DATA(ls_ghead_del).
      IF sy-subrc EQ 0.
        lv_msg4 = |Delivery number is already tagged|.
        APPEND VALUE #( %tky = gfs_header-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky           = gfs_header-%tky
                        %state_area    = 'Validate_Header'
                        %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                text     = lv_msg4 )
                        %element-vehno = if_abap_behv=>mk-on )
               TO reported-zi_ghead.
      ENDIF.
    ENDIF.

    IF ( ( gfs_header-lrblno IS INITIAL OR gfs_header-lbbldate IS INITIAL ) AND ( gfs_header-type = 'SALES' OR gfs_header-type = 'SALES RETURN' ) ).
      lv_msg4 = |Either LR/BL No or LR/BL Date is missing|.
      APPEND VALUE #( %tky = gfs_header-%tky )
             TO failed-zi_ghead.

      APPEND VALUE #( %tky           = gfs_header-%tky
                      %state_area    = 'Validate_Header'
                      %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg4 )
                      %element-vehno = if_abap_behv=>mk-on )
             TO reported-zi_ghead.
    ENDIF.

    "--------- Customer code Validation for STO OUTBOUND ---"
    IF gfs_header-customercode IS INITIAL  AND  gfs_header-type = 'STO OUTBOUND'  .
      lv_msg_new = 'Customer Mandatory for STO Outbound'.
      APPEND VALUE #( %tky = gfs_header-%tky )
             TO failed-zi_ghead.

      APPEND VALUE #( %tky           = gfs_header-%tky
                      %state_area    = 'Validate_Header'
                      %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg_new )
                      %element-vehno = if_abap_behv=>mk-on )
             TO reported-zi_ghead.
    ENDIF.

  ENDMETHOD.

*  METHOD wlfpl.
*    READ ENTITIES OF zi_ghead
*         IN LOCAL MODE
*         ENTITY zi_ghead ALL FIELDS WITH CORRESPONDING #( keys )
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         RESULT DATA(lt_header) FAILED DATA(lt_header_failed).
*    DATA(ls_header) = VALUE #( lt_header[ 1 ]  OPTIONAL ).
*
*    SELECT * FROM zr_wlfpl_item
*      WHERE billingdocument = @ls_header-challannumber
*      INTO TABLE @DATA(lt_item).
*
*    LOOP AT lt_item INTO DATA(ls_item).
*
*      TRY.
*          DATA(lv_item) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
*        CATCH cx_uuid_error.
*          " handle exception
*      ENDTRY.
*
*      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*             ENTITY zi_ghead
*             CREATE BY \_item
*             FROM VALUE #( ( id      = ls_header-id
*                             %target = VALUE #( ( %cid                = lv_item
*                                                  invoice             = ls_item-billingdocument
*                                                  matnr               = ls_item-originallyrequestedmaterial
*                                                  maktx               = ls_item-billingdocumentitemtext
*                                                  meins               = ls_item-baseunit
*                                                  custcode            = ls_item-soldtoparty
*                                                  custdesc            = ls_item-customerfullname
*                                                  challanqty          = ls_item-billingquantity
*                                                  %control-invoice    = if_abap_behv=>mk-on
*                                                  %control-matnr      = if_abap_behv=>mk-on
*                                                  %control-maktx      = if_abap_behv=>mk-on
*                                                  %control-meins      = if_abap_behv=>mk-on
*                                                  %control-custcode   = if_abap_behv=>mk-on
*                                                  %control-custdesc   = if_abap_behv=>mk-on
*                                                  %control-challanqty = if_abap_behv=>mk-on ) ) ) )
*
*                                                                      " TODO: variable is assigned but never used (ABAP cleaner)
*             MAPPED DATA(ls_mapped)
*               " TODO: variable is assigned but never used (ABAP cleaner)
*             FAILED DATA(ls_failed)
*             " TODO: variable is assigned but never used (ABAP cleaner)
*             REPORTED DATA(ls_reported).
*      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*             ENTITY zi_ghead
*             UPDATE
*             FIELDS ( customercode customername challannumber ) "
*             WITH VALUE #( ( %tky          = ls_header-%tky
*                             customercode  = ls_item-soldtoparty
*                             customername  = ls_item-customerfullname
*                             challannumber = '' ) ).
*
*    ENDLOOP.
*
*    READ ENTITIES OF zi_ghead IN LOCAL MODE
*         ENTITY zi_ghead
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(header_w1).
*
*    result = VALUE #( FOR ls_hedader IN header_w1
*                      ( %tky   = ls_hedader-%tky
*                        %param = ls_hedader ) ).
*  ENDMETHOD.

  METHOD item.
    READ ENTITIES OF zi_ghead
         IN LOCAL MODE
         ENTITY zi_ghead ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT DATA(lt_header) FAILED DATA(lt_header_failed).
    DATA(ls_header) = VALUE #( lt_header[ 1 ]  OPTIONAL ).
    SELECT SINGLE *
      FROM zi_gitem
      WHERE id = @ls_header-id
      INTO @DATA(lv_data).
    IF lv_data IS NOT INITIAL.
      DATA(lv_msg4) = |Item is already added|.
      APPEND VALUE #( %tky = ls_header-%tky )
             TO failed-zi_ghead.

      APPEND VALUE #( %tky           = ls_header-%tky
                      %state_area    = 'Validate_Header'
                      %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg4 )
                      )
             TO reported-zi_ghead.
      READ ENTITIES OF zi_ghead IN LOCAL MODE
           ENTITY zi_ghead
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(header_w2).

      result = VALUE #( FOR ls_hedade2r IN header_w2
                        ( %tky   = ls_hedade2r-%tky
                          %param = ls_hedade2r ) ).
      RETURN.
    ENDIF.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_gitem
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).
    IF ls_header-type = 'SALES'.
      SELECT * FROM zi_salesf4
      WHERE deliverydocument = @ls_header-deliverynumber
      INTO TABLE @DATA(lt_it).
*        WHERE yy1_vehiclenumber_dlh = @ls_header-vehno AND yy1_vehiclenumber_dlh IS NOT NULL

    ELSEIF ls_header-type = 'SALES RETURN'.
      SELECT * FROM zi_sales_return
      WHERE deliverydocument = @ls_header-deliverynumber
*        WHERE yy1_vehiclenumber_dlh = @ls_header-vehno AND yy1_vehiclenumber_dlh IS NOT NULL
        INTO CORRESPONDING FIELDS OF TABLE @lt_it.
    ENDIF.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_numc TYPE char5.
    lv_numc = 1.
    LOOP AT lt_it INTO DATA(ls_item1).
      lv_numc = |{ lv_numc ALPHA = IN }|.
      TRY.
          DATA(lv_item) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
          " handle exception
      ENDTRY.

      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
             ENTITY zi_ghead
             CREATE BY \_item
             FROM VALUE #( ( id      = ls_header-id
                             %target = VALUE #( ( %cid                = lv_item " lv_numc &&
                                                  item                = lv_item " lv_numc &&
                                                  matnr               = ls_item1-product
                                                  maktx               = ls_item1-deliverydocumentitemtext
                                                  meins               = ls_item1-deliveryquantityunit
                                                  vbeln               = ls_item1-deliverydocument
                                                  vbelp               = ls_item1-deliverydocumentitem
                                                  deliverqty          = ls_item1-actualdeliveryquantity
                                                  challanqty          = ls_item1-actualdeliveryquantity
                                                  custcode            = ls_item1-soldtoparty
                                                  custdesc            = ls_item1-customername

*                                                  ebeln               = ls_item1-referencesddocument
*                                                  ebelp               = ls_item1-referencesddocumentitem
                                                  %control-matnr      = if_abap_behv=>mk-on
                                                  %control-vbeln      = if_abap_behv=>mk-on
*                                                  %control-ebeln      = if_abap_behv=>mk-on
*                                                  %control-ebelp      = if_abap_behv=>mk-on
                                                  %control-maktx      = if_abap_behv=>mk-on
                                                  %control-meins      = if_abap_behv=>mk-on
                                                  %control-vbelp      = if_abap_behv=>mk-on
                                                  %control-deliverqty = if_abap_behv=>mk-on
                                                  %control-item       = if_abap_behv=>mk-on
                                                  %control-custcode   = if_abap_behv=>mk-on
                                                  %control-custdesc   = if_abap_behv=>mk-on
                                                  %control-challanqty = if_abap_behv=>mk-on  ) ) ) )

                                                                      " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED DATA(ls_mapped)
              " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED DATA(ls_failed)
             " TODO: variable is assigned but never used (ABAP cleaner)
             REPORTED DATA(ls_reported).
      lv_numc += 1.
      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
              ENTITY zi_ghead
              UPDATE
              FIELDS ( customercode customername transportername ) "
                  WITH VALUE #(
                                ( %tky  = ls_header-%tky
                                  customercode = ls_item1-soldtoparty
                                  customername = ls_item1-customername ) ).
*                                  transportername = ls_item1-yy1_transportername_dlh ) ).
    ENDLOOP.

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_w1).

    result = VALUE #( FOR ls_hedader IN header_w1
                      ( %tky   = ls_hedader-%tky
                        %param = ls_hedader ) ).
  ENDMETHOD.

  METHOD checkvehicle.

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(header_w1).
    DATA(lv_s) = VALUE #( header_w1[ 1 ]  OPTIONAL ).

    IF lv_s-vehno IS INITIAL AND  ( lv_s-shipmenttype = 'AUTO' OR lv_s-shipmenttype = 'BULKER'
    OR lv_s-shipmenttype = 'BY COURIER' OR lv_s-shipmenttype = 'BY CONTAINER' OR lv_s-shipmenttype = 'LMV'
    OR lv_s-shipmenttype = 'MINI-TRUCK' OR lv_s-shipmenttype = 'TRAILER'   ).
      DATA(lv_msg) = |Vehicle No. cannot be blank|.
      APPEND VALUE #( %tky = lv_s-%tky )
           TO failed-zi_ghead.

      APPEND VALUE #( %tky        = lv_s-%tky
                      %state_area =  'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )

             TO reported-zi_ghead.
    ENDIF.



  ENDMETHOD.

  METHOD checkperchal.

    DATA:error(1).
    DATA:error2(1).
    READ ENTITIES OF zi_ghead IN LOCAL MODE
       ENTITY zi_ghead
       ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT DATA(header_w1).

    READ ENTITIES OF zi_ghead IN LOCAL MODE
           ENTITY zi_gitem
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT DATA(lt_item)
           FAILED DATA(lt_item_failed).
    CLEAR error.
    DATA(lv_s) = VALUE #( header_w1[ 1 ]  OPTIONAL ).


    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs>) WHERE vbeln IS NOT INITIAL AND vbelp IS NOT INITIAL.
      IF lv_s-miningpermissionno IS INITIAL.
        error = 'X'.
      ENDIF.
      IF lv_s-miningchallantpno IS INITIAL.
        error2 = 'X'.
      ENDIF.
    ENDLOOP.

    IF error IS NOT INITIAL.

      DATA(lv_msg) = |Mining Permission No. cannot be blank|.
      APPEND VALUE #( %tky = lv_s-%tky )
           TO failed-zi_ghead.

      APPEND VALUE #( %tky        = lv_s-%tky
                      %state_area =  'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )

             TO reported-zi_ghead.

    ENDIF.

    IF error2 IS NOT INITIAL.

      lv_msg = |Mining Challan/TP cannot be blank|.
      APPEND VALUE #( %tky = lv_s-%tky )
           TO failed-zi_ghead.

      APPEND VALUE #( %tky        = lv_s-%tky
                      %state_area =  'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )

             TO reported-zi_ghead.

    ENDIF.


  ENDMETHOD.


  METHOD checkqty.

    READ ENTITIES OF zi_ghead IN LOCAL MODE
          ENTITY zi_ghead
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_header)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_gitem
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).



    LOOP AT lt_item INTO DATA(ls_item) WHERE challanqty IS INITIAL.
      DATA(lv_msg) = |Challan Qty cannot be blank|.
      APPEND VALUE #( %tky = ls_item-%tky )
           TO failed-zi_gitem.

      APPEND VALUE #( %tky        = ls_item-%tky
                      %state_area =  'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )

             TO reported-zi_gitem.
    ENDLOOP.




  ENDMETHOD.



  METHOD headerdetails.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).
    DATA(ls_hdr) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    IF ls_hdr-plantgateno IS NOT INITIAL.
      IF ls_hdr-plantgateno CS 'WL'.
        ls_hdr-plant = 2100.
      ELSE.
        ls_hdr-plant = |{ ls_hdr-plantgateno+1(2) }00|.
      ENDIF.

      ls_hdr-erdat = sy-datum.
      ls_hdr-gatepassdate = sy-datum.
      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
             ENTITY zi_ghead
             UPDATE
             FIELDS ( plant erdat gatepassdate status )
             WITH VALUE #( ( %tky  = ls_hdr-%tky
                             plant = ls_hdr-plant
                             erdat = ls_hdr-erdat
                             status = 'Created'
                             gatepassdate = ls_hdr-gatepassdate ) ).
    ELSE.
    ENDIF.
  ENDMETHOD.


  METHOD vendorcodeupdate.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cAleaner)
         FAILED FINAL(lt_header_failed).
    DATA(ls_hdr) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_hdr-plantgateno IS NOT INITIAL.
      SELECT SINGLE suppliername,bpaddrstreetname,postalcode FROM zr_supplier_f4 WHERE supplier = @ls_hdr-vendorcode INTO @DATA(lv_data).
      ls_hdr-vendorname = lv_data-suppliername.
      CONCATENATE lv_data-bpaddrstreetname lv_data-postalcode INTO ls_hdr-toplace SEPARATED BY space.
      SELECT SINGLE  name, plantaddr1 FROM zdt_mm_pc_tmg
      WHERE plant = @ls_hdr-plantgateno
     INTO @DATA(ls_plant).
      CONCATENATE ls_plant-name ls_plant-plantaddr1 INTO ls_hdr-fromplace SEPARATED BY space.
      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
             ENTITY zi_ghead
             UPDATE
             FIELDS ( vendorname toplace fromplace )
             WITH VALUE #( ( %tky       = ls_hdr-%tky
                             vendorname = ls_hdr-vendorname
                             toplace = ls_hdr-toplace
                             fromplace = ls_hdr-fromplace ) ).
    ELSE.
    ENDIF.
  ENDMETHOD.



  METHOD vehiclecheck.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
           ENTITY zi_ghead
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(lt_header_failed).
    DATA(ls_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ls_head-vehno IS NOT INITIAL.
      IF  ls_head-vehno CA '!@#$%^&*()_,./<>?\|-=+'.
        DATA(lv_msg) = |Vehicle No. cannot Contain Special Charater|.
        APPEND VALUE #( %tky = ls_head-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky        = ls_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )

               TO reported-zi_ghead.
      ENDIF.
      IF ls_head-vehno+0(1) CA 'ABCDEFGHIJKLMNOPRSTUVWXYZ' AND ls_head-vehno+1(1) CA 'ABCDEFGHIJKLMNOPRSTUVWXYZ'.

      ELSE.
        DATA(lv_msg_new) = |Check Vehicle number charecters|.
        APPEND VALUE #( %tky = ls_head-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky        = ls_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg_new ) )

               TO reported-zi_ghead.
      ENDIF.
      IF  strlen( ls_head-vehno ) GT 10.
        lv_msg = |Vehicle No. cannot be more than 10 Characters|.
        APPEND VALUE #( %tky = ls_head-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky        = ls_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg ) )

               TO reported-zi_ghead.
      ENDIF.
    ENDIF.

    SELECT SINGLE vehno, gatepass
    FROM zi_ghead
    WHERE vehno = @ls_head-vehno
    AND gatepass IS NOT INITIAL
    AND gateout IS INITIAL
    AND cancel IS INITIAL
    AND deleted IS INITIAL
    INTO @DATA(lv_vehno).
    IF lv_vehno-vehno IS NOT INITIAL AND lv_vehno-gatepass NE ls_head-gatepass.
*      lv_msg = |Vehicle already Exist in the Plant|.
*      APPEND VALUE #( %tky = ls_head-%tky )
*             TO failed-zi_ghead.
*
*      APPEND VALUE #( %tky        = ls_head-%tky
*                      %state_area = 'Validate_Head'
*                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                           text     = lv_msg ) )
*
*             TO reported-zi_ghead.
    ENDIF.


  ENDMETHOD.

  METHOD create.
    READ ENTITIES OF zi_ghead IN LOCAL MODE ENTITY zi_ghead ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT DATA(lt_header) FAILED DATA(lt_header_failed).
    DATA(lv_s) = VALUE #( lt_header[ 1 ]  OPTIONAL ).
    DATA nr_number TYPE cl_numberrange_runtime=>nr_number.
    DATA obj_text  TYPE cl_numberrange_objects=>nr_obj_text.
    DATA lv_c      TYPE char6.

    IF ( lv_s-type = 'SALES' ).
      SELECT * FROM z_i_billingdocumentitem  WHERE referencesddocument = @lv_s-deliverynumber
      INTO TABLE @DATA(lt_deliverydocumentitem).

      IF sy-subrc NE 0.
        DATA(lv_msg234) = |Billing Document yet not created|.
        APPEND VALUE #( %tky = lv_s-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky        = lv_s-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg234 ) )

               TO reported-zi_ghead.
      ENDIF.
    ENDIF.

    IF ( lv_s-type = 'SALES RETURN' ).

      SELECT * FROM Zi_deliverydocument WHERE deliverydocumenttype = 'LR2' AND deliverydocument = @lv_s-deliverynumber
       AND overallgoodsmovementstatus = 'C'
       INTO TABLE @DATA(lt_delievrycheck) .

      IF sy-subrc NE 0.

        DATA(lv_msg239) = |Goods Receipt not been done yet|.
        APPEND VALUE #( %tky = lv_s-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky        = lv_s-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg239 ) )

               TO reported-zi_ghead.
      ENDIF.
    ENDIF.


    MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         UPDATE
         FIELDS ( status )
         WITH VALUE #( ( %tky  = lv_s-%tky
                         status = 'Confirm' ) ).


*    IF lv_s-type = 'RGP'.
*      SELECT a~id,
*             b~*
*        FROM zi_hgate_pass AS a
*               INNER JOIN
*                 zi_itemgate_pass AS b ON a~id = b~id
*        WHERE a~gatetype = 'RGP'
*          AND a~gatepass = @lv_s-rgpgatepass
*        INTO TABLE @DATA(lt_it).
*      IF lt_it IS NOT INITIAL.
*        LOOP AT lt_it INTO DATA(ls_item1).
*
*          TRY.
*              DATA(lv_item) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
*            CATCH cx_uuid_error.
*              " handle exception
*          ENDTRY.
*
*          MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*                 ENTITY zi_ghead
*                 CREATE BY \_item
*                 FROM VALUE #( ( id      = lv_s-id
*                                 %target = VALUE #( ( %cid              = lv_item " lv_numc &&
*                                                      item              = lv_item " lv_numc &&
*                                                      matnr             = ls_item1-b-matnr
*                                                      maktx             = ls_item1-b-maktx
*                                                      meins             = ls_item1-b-meins
*                                                      orderqty          = ls_item1-b-menge
*
**
*                                                      %control-matnr    = if_abap_behv=>mk-on
*
*                                                      %control-maktx    = if_abap_behv=>mk-on
*                                                      %control-meins    = if_abap_behv=>mk-on
*
*                                                      %control-orderqty = if_abap_behv=>mk-on
*                                                      %control-item     = if_abap_behv=>mk-on ) ) ) )
*
*                                                                          " TODO: variable is assigned but never used (ABAP cleaner)
*                 MAPPED DATA(ls_mapped)
*                  " TODO: variable is assigned but never used (ABAP cleaner)
*                 FAILED DATA(ls_failed)
*                 " TODO: variable is assigned but never used (ABAP cleaner)
*                 REPORTED DATA(ls_reported).
*
*        ENDLOOP.
*      ELSE.
*        DATA(lv_msg) = |Please provide correct Gatepass Number|.
*        APPEND VALUE #( %tky = lv_s-%tky )
*               TO failed-zi_ghead.
*
*        APPEND VALUE #( %tky        = lv_s-%tky
*                        %state_area = 'Validate_Head'
*                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                             text     = lv_msg ) )
*
*               TO reported-zi_ghead.
*        RETURN.
*      ENDIF.
*    ENDIF.
*
*    IF lv_s-gatepass IS INITIAL.
*
*      obj_text-object = 'ZPO'.
*      TRY.
*          cl_numberrange_runtime=>number_get( EXPORTING nr_range_nr = '01'
*                                                        object      = obj_text-object
*                                              IMPORTING number      = nr_number ).
*
*        CATCH cx_nr_object_not_found.
*        CATCH cx_number_ranges.
*      ENDTRY.
*
*      lv_c = nr_number+14(6).
*      lv_c = |{ lv_c ALPHA = IN }|.
*      SELECT SINGLE fiscalyear FROM zr_fiscalyear INTO @DATA(lv_fisc).
*      IF lv_fisc IS INITIAL.
*        lv_fisc = sy-datum+0(4).
*      ENDIF.
*      CONCATENATE lv_fisc lv_c INTO lv_s-gatepass.
*      lv_s-gatepassdate = sy-datum.
*      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*             ENTITY zi_ghead
*             UPDATE
*             FIELDS ( gatepass gatepassdate status )
*             WITH VALUE #( ( %tky         = lv_s-%tky
*                             gatepass     = lv_s-gatepass
*                             gatepassdate = lv_s-gatepassdate
*                             status = 'Vehicle In' ) ).
*    ENDIF.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD methodrgp.
    READ ENTITIES OF zi_ghead IN LOCAL MODE ENTITY zi_ghead ALL FIELDS WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT DATA(lt_header) FAILED DATA(lt_header_failed).
    DATA(lv_s) = VALUE #( lt_header[ 1 ]  OPTIONAL ).

    SELECT SINGLE * FROM zr_hgate_f4 WHERE gatepass = @lv_s-rgpgatepass INTO @DATA(lv_data).
    lv_s-rgpdate = lv_data-createdate.

    SELECT SINGLE id , gatepass FROM zdt_ghead  WHERE gatepass = @lv_s-rgpgatepass
    INTO @DATA(ls_hdr).



    SELECT * FROM zdt_gitem  WHERE id = @ls_hdr-id
    INTO TABLE @DATA(lt_gitem).

    SELECT * FROM zdt_ghead WHERE rgpgatepass = @ls_hdr-gatepass AND gatepass <> @lv_s-gatepass AND status <> 'Deleted'
    INTO TABLE @DATA(lt_ghead_cal).

    IF lt_ghead_cal IS NOT INITIAL.
      SELECT * FROM zdt_gitem FOR ALL ENTRIES IN @lt_ghead_cal
       WHERE id = @lt_ghead_cal-id
       INTO TABLE @DATA(lt_gitem_cal).
    ENDIF.

    SELECT  gateitem , SUM( plantqty ) AS plantqty , SUM( deliverqty ) AS deliverqty
    FROM @lt_gitem_cal AS a
    GROUP BY gateitem
    INTO TABLE @DATA(lt_gitem_cal_group) .


    MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
           ENTITY zi_ghead
           UPDATE
           FIELDS ( rgpdate )
           WITH VALUE #( ( %tky    = lv_s-%tky
                           rgpdate = lv_s-rgpdate ) ).

    LOOP AT lt_gitem INTO DATA(ls_item1).
      TRY.
          DATA(lv_item) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
          " handle exception
      ENDTRY.

      READ TABLE lt_gitem_cal_group INTO DATA(ls_gitem_cal_group) WITH KEY gateitem = ls_item1-gateitem.
      IF sy-subrc EQ 0.
        ls_item1-deliverqty = ls_gitem_cal_group-plantqty.
        ls_item1-balanceqty = ls_item1-challanqty - ls_item1-deliverqty.
      ELSE.
        ls_item1-balanceqty = ls_item1-challanqty.
      ENDIF.
      ls_item1-plantqty = ls_item1-balanceqty.

      IF ls_item1-balanceqty IS NOT INITIAL. "Added by SP on 01.08.2025

      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
             ENTITY zi_ghead
             CREATE BY \_item
             FROM VALUE #( ( id      = lv_s-id
                             %target = VALUE #( ( %cid                = lv_item " lv_numc &&
                                                  item                = lv_item " lv_numc &&
                                                  matnr               = ls_item1-matnr
                                                  maktx               = ls_item1-maktx
                                                  meins               = ls_item1-meins
                                                  vbeln               = ls_item1-vbeln
                                                  vbelp               = ls_item1-vbelp
                                                  deliverqty          = ls_item1-deliverqty
                                                  balanceqty          = ls_item1-balanceqty
                                                  orderqty            = ls_item1-challanqty
                                                  challanqty          = ls_item1-balanceqty
                                                  plantqty            = ls_item1-balanceqty
                                                  custcode            = ls_item1-custcode
                                                  custdesc            = ls_item1-custdesc
                                                  gateitem            = ls_item1-gateitem
                                                  ebeln               = ls_item1-ebeln
                                                  ebelp               = ls_item1-ebelp

                                                  %control-matnr      = if_abap_behv=>mk-on
                                                  %control-vbeln      = if_abap_behv=>mk-on
                                                  %control-ebeln      = if_abap_behv=>mk-on
                                                  %control-ebelp      = if_abap_behv=>mk-on
                                                  %control-maktx      = if_abap_behv=>mk-on
                                                  %control-meins      = if_abap_behv=>mk-on
                                                  %control-vbelp      = if_abap_behv=>mk-on
                                                  %control-deliverqty = if_abap_behv=>mk-on
                                                  %control-balanceqty = if_abap_behv=>mk-on
                                                  %control-plantqty = if_abap_behv=>mk-on
                                                  %control-orderqty = if_abap_behv=>mk-on
                                                  %control-item       = if_abap_behv=>mk-on
                                                  %control-custcode   = if_abap_behv=>mk-on
                                                  %control-custdesc   = if_abap_behv=>mk-on
                                                  %control-challanqty = if_abap_behv=>mk-on
                                                  %control-gateitem = if_abap_behv=>mk-on
                                                   ) ) ) )

                                                                      " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED DATA(ls_mapped)
              " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED DATA(ls_failed)
             " TODO: variable is assigned but never used (ABAP cleaner)
             REPORTED DATA(ls_reported).
      ENDIF. "Added by SP on 01.08.2025
    ENDLOOP.
  ENDMETHOD.

  METHOD challanno_date.

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).
    DATA(ls_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    IF  ( ( ls_head-type = 'PO' ) AND ( ls_head-challannumber IS INITIAL OR ls_head-challandate IS INITIAL ) ).
      DATA(lv_msg) = |Challan Number or Date is missing|.
      APPEND VALUE #( %tky = ls_head-%tky )
             TO failed-zi_ghead.

      APPEND VALUE #( %tky        = ls_head-%tky
                      %state_area = 'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )

             TO reported-zi_ghead.
    ENDIF.
  ENDMETHOD.

  METHOD checkuniquechallan.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
           ENTITY zi_ghead
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(lt_header_failed).
    DATA(ls_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    IF ( ls_head-type = 'PO' ).
      IF ls_head-challandate+4(2) > 3.
        DATA(year) = ls_head-challandate+0(4).
      ELSE.
        year = ls_head-challandate+0(4) - 1.
      ENDIF.

      SELECT * FROM zdt_ghead
       WHERE challannumber = @ls_head-challannumber AND vendorcode = @ls_head-vendorcode
       AND type = 'PO' AND status <> 'Deleted' "added by khalid on 08.03.2025 for PO
       INTO TABLE @DATA(lt_checkunique).
      LOOP AT lt_checkunique INTO DATA(ls_checkunique).
        IF ls_checkunique-challandate+4(2) > 3.
          DATA(year2) = ls_checkunique-challandate+0(4).
        ELSE.
          year2 = ls_checkunique-challandate+0(4) - 1.
        ENDIF.
        IF ( year2 = year AND ls_checkunique-gatepass <> ls_head-gatepass ).
          DATA(lv_msg) = |Challan Number & Date & Vendor not unique|.
          APPEND VALUE #( %tky = ls_head-%tky )
                 TO failed-zi_ghead.

          APPEND VALUE #( %tky        = ls_head-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg ) )

                 TO reported-zi_ghead.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD methoddeliveryno.
    READ ENTITIES OF zi_ghead
       IN LOCAL MODE
       ENTITY zi_ghead ALL FIELDS WITH CORRESPONDING #( keys )
       " TODO: variable is assigned but never used (ABAP cleaner)
       RESULT DATA(lt_header) FAILED DATA(lt_header_failed).
    DATA(ls_header) = VALUE #( lt_header[ 1 ]  OPTIONAL ).

    SELECT SINGLE *
      FROM zi_gitem
      WHERE id = @ls_header-id
      INTO @DATA(lv_data).
    IF lv_data IS NOT INITIAL.
      DATA(lv_msg4) = |Item is already added|.
      APPEND VALUE #( %tky           = ls_header-%tky
                      %state_area    = 'Validate_Header'
                      %msg           = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text     = lv_msg4 )
                      )
             TO reported-zi_ghead.
      RETURN.
    ENDIF.

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_gitem
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).
    IF ls_header-type = 'SALES'.
      SELECT * FROM zi_salesf4
      WHERE deliverydocument = @ls_header-deliverynumber AND type = 'SALES'
      INTO TABLE @DATA(lt_it).

    ELSEIF ls_header-type = 'SALES RETURN'.
      SELECT * FROM zi_salesf4
      WHERE deliverydocument = @ls_header-deliverynumber AND type = 'SALES RETURN'
        INTO TABLE @lt_it.
    ENDIF.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_numc TYPE char5.
    lv_numc = 1.
    LOOP AT lt_it INTO DATA(ls_item1).
      lv_numc = |{ lv_numc ALPHA = IN }|.
      TRY.
          DATA(lv_item) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
        CATCH cx_uuid_error.
          " handle exception
      ENDTRY.

      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
             ENTITY zi_ghead
             CREATE BY \_item
             FROM VALUE #( ( id      = ls_header-id
                             %target = VALUE #( ( %cid                = lv_item " lv_numc &&
                                                  item                = lv_item " lv_numc &&
                                                  matnr               = ls_item1-product
                                                  maktx               = ls_item1-deliverydocumentitemtext
                                                  meins               = ls_item1-deliveryquantityunit
                                                  vbeln               = ls_item1-deliverydocument
                                                  vbelp               = ls_item1-deliverydocumentitem
                                                  deliverqty          = ls_item1-actualdeliveryquantity
                                                  challanqty          = ls_item1-actualdeliveryquantity
                                                  custcode            = ls_item1-soldtoparty
                                                  custdesc            = ls_item1-customername
                                                  netwt               = ls_item1-itemnetweight

*                                                  ebeln               = ls_item1-referencesddocument
*                                                  ebelp               = ls_item1-referencesddocumentitem
                                                  %control-matnr      = if_abap_behv=>mk-on
                                                  %control-vbeln      = if_abap_behv=>mk-on
*                                                  %control-ebeln      = if_abap_behv=>mk-on
*                                                  %control-ebelp      = if_abap_behv=>mk-on
                                                  %control-maktx      = if_abap_behv=>mk-on
                                                  %control-meins      = if_abap_behv=>mk-on
                                                  %control-vbelp      = if_abap_behv=>mk-on
                                                  %control-deliverqty = if_abap_behv=>mk-on
                                                  %control-item       = if_abap_behv=>mk-on
                                                  %control-custcode   = if_abap_behv=>mk-on
                                                  %control-custdesc   = if_abap_behv=>mk-on
                                                  %control-netwt      = if_abap_behv=>mk-on
                                                  %control-challanqty = if_abap_behv=>mk-on  ) ) ) )

                                                                      " TODO: variable is assigned but never used (ABAP cleaner)
             MAPPED DATA(ls_mapped)
              " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED DATA(ls_failed)
             " TODO: variable is assigned but never used (ABAP cleaner)
             REPORTED DATA(ls_reported).
      lv_numc += 1.
      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
              ENTITY zi_ghead
              UPDATE
              FIELDS ( customercode customername transportercode transportername containernumber ) "
                  WITH VALUE #(
                                ( %tky  = ls_header-%tky
                                  customercode = ls_item1-soldtoparty
                                  customername = ls_item1-customername
                                  transportercode = ls_item1-transportercode
                                  transportername = ls_item1-transportername
                                  containernumber = ls_item1-containernumber ) ).
*                                  transportername = ls_item1-yy1_transportername_dlh ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD gateitem.

    DATA : l_item      TYPE zdt_gitem-gateitem,
           l_item_numc TYPE zde_gateitem.

    READ ENTITIES OF zi_ghead IN LOCAL MODE
        ENTITY zi_ghead
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
        " TODO: variable is assigned but never used (ABAP cleaner)
        FAILED FINAL(lt_header_failed).
*
    READ ENTITY zi_ghead
        BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    CLEAR : l_item , l_item_numc.

    SELECT SINGLE MAX( a~gateitem ) AS gateitem FROM @lt_item AS a
    INTO @DATA(l_item_numc_1).
    IF l_item_numc_1 IS NOT INITIAL.
      l_item_numc = l_item_numc_1.
    ENDIF.

    LOOP AT lt_item INTO DATA(ls_item).
      IF ls_item-gateitem IS INITIAL.
        l_item_numc = l_item_numc + 10.
        l_item = l_item_numc.
        ls_item-gateitem = l_item.

        MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
               ENTITY zi_gitem
               UPDATE
               FIELDS (  gateitem gatepass ) "
               WITH VALUE #( id = ls_item-id
                             ( %tky       = ls_item-%tky
                               gateitem = ls_item-gateitem
                               gatepass = gs_head-gatepass
                                ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD transporterdetails.

    READ ENTITIES OF zi_ghead IN LOCAL MODE
      ENTITY zi_ghead
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT FINAL(lt_header)
      " TODO: variable is assigned but never used (ABAP cleaner)
      FAILED FINAL(lt_header_failed).
    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
*

    SELECT SINGLE * FROM i_supplier
     WHERE supplier = @gs_head-transportercode
      INTO @DATA(ls_supplier).


    MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
            ENTITY zi_ghead
            UPDATE
            FIELDS (  transportername  ) "
                WITH VALUE #(
                              ( %tky  = gs_head-%tky
                                transportername = ls_supplier-suppliername ) ).
*                                  transportername = ls_item1-yy1_transportername_dlh ) ).

  ENDMETHOD.

  METHOD tprint.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
        ENTITY zi_ghead
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(header)
        " TODO: variable is assigned but never used (ABAP cleaner)
        FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_gate>).
      IF <fs_gate> IS ASSIGNED.

        <fs_gate>-tprint = 'X'.

        MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
                ENTITY zi_ghead
                UPDATE
                FIELDS ( tprint )
                WITH VALUE #( ( %tky          = <fs_gate>-%tky
                                 tprint =  <fs_gate>-tprint
                                  %control-printr   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY  zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

*  METHOD weighment_wt.
*    READ ENTITIES OF zi_ghead IN LOCAL MODE
*      ENTITY zi_ghead
*      ALL FIELDS
*      WITH CORRESPONDING #( keys )
*      RESULT FINAL(lt_header)
*      " TODO: variable is assigned but never used (ABAP cleaner)
*      FAILED FINAL(lt_header_failed).
**
*    READ ENTITY zi_ghead
*        BY \_item
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(lt_item)
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         FAILED FINAL(lt_item_failed).
*
*    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).
*
*
*
*    SELECT MAX( grswt ) AS max_gross_wt FROM @lt_item AS a
*    INTO TABLE @DATA(lt_grosswt).
*
*    DATA(gs_grosswt_max) = VALUE #( lt_grosswt[ 1 ] OPTIONAL ).
*
*    SELECT MIN( tarwt ) AS min_tare_wt FROM @lt_item AS b
*     INTO TABLE @DATA(lt_tarewt).
*
*    DATA(gs_tarewt_min) = VALUE #( lt_tarewt[ 1 ] OPTIONAL ).
*    DATA(gs_netwt) = gs_grosswt_max-max_gross_wt - gs_tarewt_min-min_tare_wt .
*
*
*    IF lt_item IS NOT INITIAL AND ( ls_header-grswt <> gs_grosswt_max-max_gross_wt OR ls_header-netwt <> gs_netwt OR ls_header-tarwt <> gs_tarewt_min-min_tare_wt   ).
*      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*          ENTITY zi_ghead
*          UPDATE
*          FIELDS ( grswt tarwt netwt ) "
*              WITH VALUE #(
*                            ( %tky  = ls_header-%tky
*                              grswt = gs_grosswt_max-max_gross_wt
*                              tarwt = gs_tarewt_min-min_tare_wt
*                              netwt = gs_netwt ) ).
**                                  transportername = ls_item1-yy1_transportername_dlh ) ).
*
*
*    ENDIF.
*
*  ENDMETHOD.

  METHOD customer_name.
    DATA: lv_update TYPE char1.
*---------------------------------------------------------------------------*
    READ ENTITIES OF zi_ghead IN LOCAL MODE
        ENTITY zi_ghead
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT FINAL(lt_header)
        " TODO: variable is assigned but never used (ABAP cleaner)
        FAILED FINAL(lt_header_failed).

    DATA(ls_header) =  VALUE #( lt_header[ 1 ]  OPTIONAL ).
    CLEAR:lv_update.
*---------------------------------------------------------------------------*
    IF ls_header-customercode IS NOT INITIAL  AND ls_header-type = 'STO OUTBOUND'.

      SELECT SINGLE * FROM Z_I_Customer WHERE customer = @ls_header-customercode INTO @DATA(ls_custnam).
      IF sy-subrc EQ 0 AND ls_custnam-bpcustomerfullname <> ls_header-customername .
        ls_header-customername = ls_custnam-bpcustomerfullname  .
        lv_update = abap_true.
      ENDIF.
    ELSE.
      SELECT SINGLE * FROM z_i_customer WHERE customer = @ls_header-customercode INTO @DATA(ls_custnam1).
      IF sy-subrc EQ 0.
        ls_header-customername = ls_custnam1-bpcustomername  .
        lv_update = abap_true.
      ENDIF.
    ENDIF.



    IF lv_update IS NOT INITIAL.
      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
              ENTITY zi_ghead
              UPDATE
              FIELDS ( customername )
              WITH VALUE #( ( %tky           = ls_header-%tky
                               customername  = ls_header-customername
                              ) ).
    ENDIF.
  ENDMETHOD.

  METHOD checkauth.

    READ ENTITIES OF zi_ghead IN LOCAL MODE
           ENTITY zi_ghead
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT DATA(header_w1).
    DATA(lv_s) = VALUE #( header_w1[ 1 ]  OPTIONAL ).

    SELECT SINGLE * FROM zdt_gate_auth WHERE type = @lv_s-type AND userid = @sy-uname INTO @DATA(ls_auth).

    IF ls_auth IS INITIAL.
      DATA(lv_msg) = |You are not Authorized to save the data|.
      APPEND VALUE #( %tky = lv_s-%tky )
           TO failed-zi_ghead.

      APPEND VALUE #( %tky        = lv_s-%tky
                      %state_area =  'Validate_Head'
                      %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                           text     = lv_msg ) )

             TO reported-zi_ghead.
    ENDIF.
    CLEAR : ls_auth.

  ENDMETHOD.

ENDCLASS.


CLASS lhc_zi_gitem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_gitem RESULT result.

*    METHODS update_item FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR zi_gitem~update_item.

    METHODS itemdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gitem~itemdetails.
    METHODS mandatefieldsitem FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_gitem~mandatefieldsitem.
    METHODS checkdelno FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_gitem~checkdelno.
    METHODS checkpoval FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_gitem~checkpoval.
*    METHODS popitem FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR zi_gitem~popitem.
    METHODS popmaterial FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gitem~popmaterial.
*    METHODS popitemsto FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR zi_gitem~popitemsto.
    METHODS poitem1 FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gitem~poitem1.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_gitem RESULT result.

*    METHODS copy FOR MODIFY
*      IMPORTING keys FOR ACTION zi_gitem~copy RESULT result.
    METHODS vbelnfind FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gitem~vbelnfind.
    METHODS matdocfind FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gitem~matdocfind.
*    METHODS gateitem FOR DETERMINE ON SAVE
*      IMPORTING keys FOR zi_gitem~gateitem.

    METHODS updateitem FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gitem~update_item.
    METHODS weighment_wt FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_gitem~weighment_wt.

    METHODS popweiunit FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_gitem~popweiunit.

ENDCLASS.


CLASS lhc_zi_gitem IMPLEMENTATION.
  METHOD get_instance_features.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(header_failed).

    IF header IS INITIAL.
      RETURN.
    ENDIF.
    FINAL(ls_head) = VALUE #( header[ 1 ] OPTIONAL ).
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_gitem
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(fg)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(fg_failed).

    SELECT * FROM zi_gitem
      WHERE id = @ls_head-id
      INTO TABLE @DATA(lt_data).

    SELECT SINGLE * FROM zdt_userid
WHERE userid = @sy-uname
INTO @DATA(ls_user).
    IF sy-subrc EQ 0 AND ls_user-deleteable = 'X'.
      DATA(flagdelete) = 'X'.
    ENDIF.

*    IF ls_head-status = 'Confirm' AND ls_user-edit IS INITIAL.
*      DATA(flagedit) = 'X'.
*    ENDIF.

    IF ls_user-edit IS INITIAL.
      IF ls_head-status = 'Deleted' OR ls_head-status = 'Exit Confirmed' OR ls_head-status = 'Confirm'.
        DATA(flagedit) = 'X'.
      ENDIF.
    ENDIF.


    result = VALUE #(
        FOR gs_header IN fg
        ( %tky               = gs_header-%tky

*          %features-%update  = COND #( WHEN VALUE #( lt_data[ id   = gs_header-id
*                                                              item = gs_header-item ]-challanqty OPTIONAL ) IS INITIAL
*                                        AND ( ls_head-type = 'RGP' OR ls_head-type = 'RETURN RGP' OR ls_head-type = 'STO INBOUND' ) THEN
*                                         if_abap_behv=>fc-o-enabled
**                                       WHEN VALUE #( lt_data[ id   = gs_header-id
**                                                              item = gs_header-item ] OPTIONAL ) IS NOT INITIAL THEN
**                                         if_abap_behv=>fc-o-disabled
*                                       WHEN ( ls_head-status = 'Exit Confirmed' OR ( ls_head-status = 'Confirm' AND flagedit IS NOT INITIAL ) )
*                                       THEN if_abap_behv=>fc-o-disabled
*                                       ELSE
*                                         if_abap_behv=>fc-o-enabled )


          %features-%update  = if_abap_behv=>fc-o-enabled

          %features-%delete  = COND #(  WHEN flagdelete IS NOT INITIAL THEN
                                        if_abap_behv=>fc-o-enabled
                                       WHEN ls_head-status = 'Exit Confirmed' OR ls_head-status = 'Confirm' OR ls_head-status = 'Deleted'
                                       THEN if_abap_behv=>fc-o-disabled
                                       ELSE if_abap_behv=>fc-o-enabled )

          %field-matnr       = COND #( WHEN  ( ls_head-type = 'NONPO / SERVICE' OR ls_head-type = 'RGP' OR ls_head-type = 'NRGP' OR ls_head-type = 'RETURN RGP' OR ls_head-type = 'CASH ENTRY') AND flagedit <> 'X'
                                       THEN if_abap_behv=>fc-o-enabled
                                       ELSE if_abap_behv=>fc-f-read_only  )
          %field-mpno        = COND #( WHEN ls_head-type = 'PO'
                                       THEN if_abap_behv=>fc-o-enabled
                                       ELSE if_abap_behv=>fc-f-read_only  )
          %field-tpno        = COND #( WHEN ls_head-type = 'PO'
                                       THEN if_abap_behv=>fc-o-enabled
                                       ELSE if_abap_behv=>fc-f-read_only  )
          %field-potext        = COND #( WHEN ls_head-type = 'PO'
                                       THEN if_abap_behv=>fc-f-read_only
                                       ELSE if_abap_behv=>fc-f-read_only  )
          %field-maktx       = COND #( WHEN ( ( ls_head-type = 'RGP' OR ls_head-type = 'NRGP' OR ls_head-type = 'STO OUTBOUND' ) AND flagedit <> 'X' ) OR ( ls_head-type = 'NONPO / SERVICE' AND flagedit <> 'X' )
                                       OR (  ls_head-type = 'CASH ENTRY' AND flagedit <> 'X' )
                                       THEN if_abap_behv=>fc-o-enabled
                                       ELSE if_abap_behv=>fc-f-read_only  )
          %field-meins       = COND #( WHEN ( ls_head-type = 'NONPO / SERVICE' OR ls_head-type = 'STO OUTBOUND'  ) AND flagedit = 'X'
                                       THEN if_abap_behv=>fc-o-enabled
                                       WHEN ( ls_head-type = 'RGP' OR ls_head-type = 'NRGP' OR ls_head-type = 'CASH ENTRY') AND gs_header-matnr IS INITIAL AND flagedit <> 'X'
                                       THEN if_abap_behv=>fc-o-enabled
                                       ELSE if_abap_behv=>fc-f-read_only  )
          %field-itemval     = COND #( WHEN ls_head-type = 'RGP' AND flagedit <> 'X'
                                       THEN if_abap_behv=>fc-o-enabled
                                       ELSE if_abap_behv=>fc-f-read_only  )
          %field-currency    = COND #( WHEN ( ls_head-type = 'RGP' OR ls_head-type = 'NRGP' ) AND flagedit <> 'X'
                                       THEN if_abap_behv=>fc-o-enabled
                                       ELSE if_abap_behv=>fc-f-read_only  )
          %field-pounique    = COND #( WHEN ( ls_head-type = 'NONPO / SERVICE'  OR ls_head-type = 'RGP'   OR ls_head-type = 'STO'  OR flagedit = 'X' )
                                       THEN if_abap_behv=>fc-f-read_only
                                       ELSE if_abap_behv=>fc-o-enabled  )
          %field-pouniquesto = COND #( WHEN ls_head-type = 'STO' AND flagedit <> 'X'
                                       THEN if_abap_behv=>fc-o-enabled
                                       ELSE if_abap_behv=>fc-f-read_only  )
         %field-vbeln = COND #( WHEN ls_head-type = 'CASH ENTRY' AND flagedit <> 'X'          "By SN for CASH ENTRY
                                       THEN if_abap_behv=>fc-f-read_only
                                       ELSE  if_abap_behv=>fc-o-enabled )
         %field-vbelp = COND #( WHEN ls_head-type = 'CASH ENTRY' AND flagedit <> 'X'          "By SN for CASH ENTRY
                                       THEN if_abap_behv=>fc-f-read_only
                                       ELSE  if_abap_behv=>fc-o-enabled )
          %field-ebeln = COND #( WHEN ls_head-type = 'CASH ENTRY' AND flagedit <> 'X'          "By SN for CASH ENTRY
                                       THEN if_abap_behv=>fc-f-read_only
                                       ELSE  if_abap_behv=>fc-o-enabled )
          %field-ebelp = COND #( WHEN ls_head-type = 'CASH ENTRY' AND flagedit <> 'X'          "By SN for CASH ENTRY
                                       THEN if_abap_behv=>fc-f-read_only
                                       ELSE  if_abap_behv=>fc-o-enabled )

         %field-mblnr = COND #( WHEN ( ( ls_head-type = 'SALES' OR ls_head-type = 'SALES RETURN' OR ls_head-type = 'PO' OR  ls_head-type = 'STO OUTBOUND' OR ls_head-type = 'STO INBOUND'  OR ls_head-type = 'CASH ENTRY' ) AND flagedit <> 'X' )
                                       THEN if_abap_behv=>fc-f-read_only
                                       ELSE if_abap_behv=>fc-o-enabled  )
         %field-mjahr = COND #( WHEN ( ( ls_head-type = 'SALES' OR ls_head-type = 'SALES RETURN' OR ls_head-type = 'PO' OR  ls_head-type = 'STO OUTBOUND' OR ls_head-type = 'STO INBOUND' OR ls_head-type = 'CASH ENTRY'  ) AND flagedit <> 'X' )
                                       THEN if_abap_behv=>fc-f-read_only
                                       ELSE if_abap_behv=>fc-o-enabled  )
         %field-zeile = COND #( WHEN ( ( ls_head-type = 'SALES' OR ls_head-type = 'SALES RETURN' OR ls_head-type = 'PO' OR  ls_head-type = 'STO OUTBOUND' OR ls_head-type = 'STO INBOUND' OR ls_head-type = 'CASH ENTRY' ) AND flagedit <> 'X' )
                                       THEN if_abap_behv=>fc-f-read_only
                                       ELSE if_abap_behv=>fc-o-enabled  )

                 )  ) .
  ENDMETHOD.

*  METHOD update_item.
**    DATA lv_mat TYPE char18.
*
**    DATA itm    TYPE zi_iito_trans-itoitem.
*    READ ENTITIES OF zi_ghead IN LOCAL MODE
*         ENTITY zi_ghead
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(lt_header)
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         FAILED FINAL(lt_header_failed).
*
*    READ ENTITIES OF zi_ghead IN LOCAL MODE
*         ENTITY zi_gitem
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(lt_item)
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         FAILED FINAL(lt_item_failed).
*    DATA lv_posnr TYPE zi_gitem-gateitem.
*    lv_posnr = 10.
*    lv_posnr = |{ lv_posnr ALPHA = IN }|.
*    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
*    LOOP AT lt_item INTO DATA(ls_item).
**      lv_mat = |{ ls_item-matnr ALPHA = IN }|.
*      IF (  ls_item-pounique IS NOT INITIAL OR ls_item-pouniquesto IS NOT INITIAL ) AND
*       ( gs_head-type = 'PO' OR gs_head-type = 'STO' ).
*        SELECT SINGLE * FROM zpof4_final_n
*          WHERE po             = @ls_item-pounique
*            AND purchaseorder IS NOT INITIAL
*          INTO @DATA(ls_item1).
*        IF ls_item1 IS INITIAL.
*          SELECT SINGLE * FROM zpof4_final_n_sto
*            WHERE po             = @ls_item-pouniquesto
*              AND purchaseorder IS NOT INITIAL
*            INTO @ls_item1.
*        ENDIF.
*        ls_item-balanceqty = ls_item1-bal_qty.
*        ls_item-deliverqty = ls_item1-actualdeliveryquantity.
*        ls_item-ebeln      = ls_item1-purchaseorder.
*        ls_item-ebelp      = ls_item1-purchaseorderitem.
*        ls_item-maktx      = ls_item1-purchaseorderitemtext.
*        ls_item-meins      = ls_item1-purchaseorderquantityunit.
*        ls_item-vbeln      = ls_item1-deliverydocument.
*        ls_item-vbelp      = ls_item1-deliverydocumentitem.
*        ls_item-matnr      = ls_item1-material.
*        ls_item-vendor     = gs_head-vendorcode.
*        ls_item-orderqty   = ls_item1-orderquantity.
*        IF ls_item-mpno IS INITIAL.
*          ls_item-mpno = ls_item1-deliverydocumentbysupplier.
*        ENDIF.
*        IF ls_item-tpno IS INITIAL.
*          ls_item-tpno = ls_item1-billoflading.
*        ENDIF.
*        MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*               ENTITY zi_gitem
*               UPDATE
*               FIELDS ( balanceqty deliverqty ebelp maktx meins vbeln vbelp matnr vendor orderqty gatepass gateitem
*                            mpno tpno )
*               WITH VALUE #( id = ls_item-id
*                             ( %tky       = ls_item-%tky
*                               balanceqty = ls_item-balanceqty
*                               deliverqty = ls_item-deliverqty
*                               ebelp      = ls_item-ebelp
*                               maktx      = ls_item-maktx
*                               meins      = ls_item-meins
*                               vbeln      = ls_item-vbeln
*                               vbelp      = ls_item-vbelp
*                               matnr      = ls_item-matnr
*                               vendor     = ls_item-vendor
*                               orderqty   = ls_item-orderqty
*                               gatepass   = gs_head-gatepass
*                               mpno       = ls_item-mpno
*                               tpno       = ls_item-tpno
*                               gateitem   = lv_posnr ) ).
*
*        IF gs_head-transportercode IS INITIAL.
*          MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*                 ENTITY zi_ghead
*                 UPDATE
*                 FIELDS ( transportercode transportername )
*                 WITH VALUE #( ( %tky            = gs_head-%tky
*                                 transportercode = ls_item1-unloadingpointname ) ).
**                                 transportername = ls_item1-transname ) ).
*        ENDIF.
*      ELSE.
*        ls_item-vendor = gs_head-vendorcode.
*        ls_item-plant  = gs_head-plant.
*        MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*               ENTITY zi_gitem
*               UPDATE
*               FIELDS ( vendor gatepass gateitem plant )
*               WITH VALUE #( id = ls_item-id
*                             ( %tky     = ls_item-%tky
*                               vendor   = ls_item-vendor
*                               gatepass = gs_head-gatepass
*                               gateitem = lv_posnr
*                               plant    = ls_item-plant ) ).
*        IF gs_head-type = 'NONPO / SERVICE'.
*          DATA lv_char TYPE char18.
*          lv_char = |{ ls_item-matnr ALPHA = IN }|.
*          SELECT SINGLE * FROM zi_nonpof4 WHERE product = @lv_char INTO @DATA(ls_mat).
*          IF sy-subrc IS INITIAL.
*            ls_item-maktx = ls_mat-productdescription.
*            IF ls_item-meins IS INITIAL.
*              ls_item-meins = ls_mat-baseunit.
*
*            ENDIF.
*            MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*                   ENTITY zi_gitem
*                   UPDATE
*                   FIELDS ( maktx meins ) "
*                   WITH VALUE #( id = ls_item-id
*                                 ( %tky  = ls_item-%tky
*                                   maktx = ls_item-maktx
*                                   meins = ls_item-meins ) ).
*          ENDIF.
*
*        ENDIF.
*      ENDIF.
*      lv_posnr += 10.
*      lv_posnr = |{ lv_posnr ALPHA = IN }|.
*    ENDLOOP.
*
*    lv_posnr /= 10.
*    IF gs_head-type CS 'SALES'.
*      lv_posnr = 2.
*    ENDIF.
*    MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*           ENTITY zi_ghead
*           UPDATE
*           FIELDS ( noofweight multiweight )
*           WITH VALUE #( ( %tky        = gs_head-%tky
*                           noofweight  = lv_posnr
*                           multiweight = COND #( WHEN lv_posnr > 2 AND NOT gs_head-type CS 'SALES'
*                                                 THEN 'Y'
*                                                 ELSE 'N' ) ) ).
*  ENDMETHOD.
*
  METHOD itemdetails.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_gitem
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    LOOP AT lt_item INTO DATA(ls_item).
*      lv_mat = |{ ls_item-matnr ALPHA = IN }|.
      IF ls_item-pounique IS NOT INITIAL OR ls_item-pouniquesto IS NOT INITIAL.
        SELECT SINGLE * FROM zpof4_final_n
          WHERE po             = @ls_item-pounique
            AND purchaseorder IS NOT INITIAL
          INTO @DATA(ls_item1).
        IF ls_item1 IS INITIAL.
          SELECT SINGLE * FROM zpof4_final_n_sto
            WHERE po             = @ls_item-pouniquesto
              AND purchaseorder IS NOT INITIAL
            INTO @ls_item1.
        ENDIF.

        IF ls_item1-purchaseorder IS NOT INITIAL.
          SELECT SINGLE plainlongtext
          FROM i_purchaseorderitemnotetp_2
          WHERE purchaseorder = @ls_item1-purchaseorder AND purchaseorderitem = @ls_item1-purchaseorderitem
            AND language = 'E' AND textobjecttype = 'F01'
          INTO @DATA(lv_longtext).
          ls_item-potext = lv_longtext.
        ENDIF.

*        IF gs_head-type = 'PO'.
*          IF lt_pog_group_item IS NOT INITIAL.
*            READ TABLE lt_pog_group_item INTO DATA(ls_pog_group_item) WITH KEY ebeln = ls_item-ebeln ebelp = ls_item-ebelp.
*            IF sy-subrc EQ 0.
*              ls_item1-actualdeliveryquantity = ls_pog_group_item-plantqty.
*              ls_item1-bal_qty = ls_item1-orderquantity - ls_item1-actualdeliveryquantity .
*            ELSE.
*            ENDIF.
*          ENDIF.
*        ENDIF.

        ls_item-balanceqty = ls_item1-bal_qty.
        ls_item-deliverqty = ls_item1-actualdeliveryquantity.
        ls_item-ebeln      = ls_item1-purchaseorder.
        ls_item-ebelp      = ls_item1-purchaseorderitem.
        ls_item-maktx      = ls_item1-purchaseorderitemtext.
        ls_item-meins      = ls_item1-purchaseorderquantityunit.
        ls_item-vbeln      = ls_item1-deliverydocument.
        ls_item-vbelp      = ls_item1-deliverydocumentitem.
        ls_item-matnr      = ls_item1-material.
        ls_item-vendor     = gs_head-vendorcode.
        ls_item-orderqty   = ls_item1-orderquantity.
        ls_item-plant      = gs_head-plantgateno.
*        IF ls_item-mpno IS INITIAL.
*          ls_item-mpno       = ls_item1-deliverydocumentbysupplier.
*        ENDIF.
*        IF ls_item-tpno IS INITIAL.
*          ls_item-tpno       = ls_item1-billoflading.
*        ENDIF.
        MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
               ENTITY zi_gitem
               UPDATE
               FIELDS ( ebeln balanceqty deliverqty ebelp maktx meins vbeln vbelp matnr vendor orderqty plant tpno potext )
               WITH VALUE #( id = ls_item-id
                             ( %tky       = ls_item-%tky
                               balanceqty = ls_item-balanceqty
                               deliverqty = ls_item-deliverqty
                               ebeln      = ls_item-ebeln
                               ebelp      = ls_item-ebelp
                               maktx      = ls_item-maktx
                               meins      = ls_item-meins
                               vbeln      = ls_item-vbeln
                               vbelp      = ls_item-vbelp
                               matnr      = ls_item-matnr
                               vendor     = ls_item-vendor
                               orderqty   = ls_item-orderqty
                               plant      = ls_item-plant

                               tpno       = ls_item-tpno
                               potext     = ls_item-potext  ) ).
      ELSE.

        IF ls_item-vendor IS INITIAL OR ls_item-plant IS INITIAL OR ls_item-vehno IS INITIAL.
          ls_item-vendor = gs_head-vendorcode.
          ls_item-plant  = gs_head-plantgateno.
          ls_item-vehno  = gs_head-vehno.

          MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
                 ENTITY zi_gitem
                 UPDATE
                 FIELDS ( vendor plant vehno  )
                 WITH VALUE #( id = ls_item-id
                               ( %tky   = ls_item-%tky
                                 vendor = ls_item-vendor
                                 plant  = ls_item-plant
                                 vehno = ls_item-vehno
                                 ) ).
        ENDIF.
      ENDIF.

    ENDLOOP.

*    DATA : l_val TYPE zdt_ghead-ernam.
*    IF gs_head-ernam IS INITIAL.
*      l_val = sy-uname. "gs_head-ernam.
*      "l_val = l_val + 1.
*      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*          ENTITY zi_ghead
*          UPDATE
*          FIELDS ( ernam )
*          WITH VALUE #( ( %tky  = gs_head-%tky
*                          ernam = l_val ) ).
*    ENDIF.
  ENDMETHOD.

  METHOD mandatefieldsitem.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITY zi_ghead
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(item_failed).
    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    FINAL(ls_new) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    FINAL(ls_item_f) = VALUE #( lt_item[ 1 ] OPTIONAL ).
    LOOP AT lt_item INTO DATA(ls_item).

*      IF gs_head-type = 'PO'.   commented by Surajit 12.02
*        IF ls_item-challanqty > ls_item-balanceqty.
*          DATA(lv_msg1) = |Challan Qty. Should Not be Greater Than Balance Qty|.
*          APPEND VALUE #( %tky = gs_head-%tky )
*                 TO failed-zi_ghead.
*
*          APPEND VALUE #( %tky        = gs_head-%tky
*                          %state_area = 'Validate_Head'
*                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                               text     = lv_msg1 ) )
*
*                 TO reported-zi_ghead.
*
*        ENDIF.
*        IF ls_item-challanqty > ls_item-deliverqty AND ls_item-deliverqty > 0.  commented by Surajit 12.02
*          lv_msg1 = |Challan Qty. Should Not be Greater Than Delivery Qty|.
*          APPEND VALUE #( %tky = gs_head-%tky )
*                 TO failed-zi_ghead.
*
*          APPEND VALUE #( %tky        = gs_head-%tky
*                          %state_area = 'Validate_Head'
*                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                               text     = lv_msg1 ) )
*
*                 TO reported-zi_ghead.
*
*        ENDIF.
*      ENDIF.
      IF ls_item-maktx IS INITIAL AND ( gs_head-type = 'NONPO / SERVICE' OR gs_head-type = 'RGP' ).
        DATA(lv_msg3) = |Material Description Cannot be Blank|.
        APPEND VALUE #( %tky = gs_head-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky        = gs_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg3 ) )

               TO reported-zi_ghead.

      ENDIF.
      IF ( ls_item-itemval1 IS INITIAL OR ls_item-currency IS INITIAL ) AND (  gs_head-type = 'RGP' OR gs_head-type = 'NRGP' ) .
        IF gs_head-type = 'RGP'.
          DATA(lv_msg4) = |Challan Value is mandatory for RGP|.
        ELSE.
          lv_msg4 = |Challan Value is mandatory for NRGP|.
        ENDIF.
        APPEND VALUE #( %tky = gs_head-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky            = gs_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg4 ) )

               TO reported-zi_ghead.
      ENDIF.
      IF ( ls_item-creationdate IS INITIAL ) AND (  gs_head-type = 'RGP' ) .
        DATA(lv_msg40) = |Return By Date is missing|.
        APPEND VALUE #( %tky = gs_head-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky        = gs_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg40 ) )

               TO reported-zi_ghead.
      ENDIF.
      IF ls_item-challanqty IS INITIAL .
        lv_msg3 = |Please enter Challan Qty.|.
        APPEND VALUE #( %tky = gs_head-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky        = gs_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg3 ) )

               TO reported-zi_ghead.

      ENDIF.

      IF ls_item-plantqty IS INITIAL AND ( gs_head-type = 'PO' OR gs_head-type = 'RETURN RGP' ) .
        lv_msg3 = |Please enter Plant Qty.|.
        APPEND VALUE #( %tky = gs_head-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky        = gs_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg3 ) )

               TO reported-zi_ghead.

      ENDIF.

      IF ls_item-meins IS INITIAL AND gs_head-type = 'RGP'.
        lv_msg3 = |Please enter UOM value|.
        APPEND VALUE #( %tky = gs_head-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky        = gs_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg3 ) )

               TO reported-zi_ghead.

      ENDIF.

      IF ( ls_item-plantqty IS NOT INITIAL AND ( ls_item-plantqty > ls_item-balanceqty ) AND ( gs_head-type = 'RETURN RGP') ). "gs_head-type = 'PO'
        DATA(lv_msg56) = |Plant Qty cannot be more than Balance Qty|.
        APPEND VALUE #( %tky = gs_head-%tky )
               TO failed-zi_ghead.

        APPEND VALUE #( %tky        = gs_head-%tky
                        %state_area = 'Validate_Head'
                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                             text     = lv_msg56 ) )

               TO reported-zi_ghead.
      ENDIF.

      IF  ( gs_head-type = 'SALES' OR gs_head-type = 'SALES RETURN' ).
        IF ls_item_f-vbeln <> ls_item-vbeln.
          DATA(lv_msg57) = |Only 1 Delivery Document can be tagged|.
          APPEND VALUE #( %tky = gs_head-%tky )
                 TO failed-zi_ghead.

          APPEND VALUE #( %tky        = gs_head-%tky
                          %state_area = 'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msg57 ) )

                 TO reported-zi_ghead.
        ENDIF.
      ENDIF.
*      IF gs_head-type = 'PO' AND ls_item-vbeln IS NOT INITIAL AND ( ls_item-mpno IS INITIAL OR ls_item-tpno IS INITIAL ).
*        lv_msg3 = |Please enter MP/TP No.|.
*        APPEND VALUE #( %tky = gs_head-%tky )
*               TO failed-zi_ghead.
*
*        APPEND VALUE #( %tky        = gs_head-%tky
*                        %state_area = 'Validate_Head'
*                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                             text     = lv_msg3 ) )
*
*               TO reported-zi_ghead.
*
*      ENDIF.

*      IF gs_head-type = 'RGP'.
*        IF ls_item-creationdate IS NOT INITIAL.
*          lv_msg3 = |Please enter MP/TP No.|.
*          APPEND VALUE #( %tky = gs_head-%tky )
*                 TO failed-zi_ghead.
*
*          APPEND VALUE #( %tky        = gs_head-%tky
*                          %state_area = 'Validate_Head'
*                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                               text     = lv_msg3 ) )
*
*                 TO reported-zi_ghead.
*        ENDIF.
*        IF ls_item-meins IS NOT INITIAL.
*          lv_msg3 = |Please enter MP/TP No.|.
*          APPEND VALUE #( %tky = gs_head-%tky )
*                 TO failed-zi_ghead.
*
*          APPEND VALUE #( %tky        = gs_head-%tky
*                          %state_area = 'Validate_Head'
*                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                               text     = lv_msg3 ) )
*
*                 TO reported-zi_ghead.
*        ENDIF.
      "     ENDIF.


*      IF gs_head-type = 'RGP' AND ls_item-challanqty GT ls_item-orderqty.   commented by Surajit 12.02
*        lv_msg3 = |Challan Qty. cannot be greater than Order Qty.|.
*        APPEND VALUE #( %tky = gs_head-%tky )
*               TO failed-zi_ghead.
*
*        APPEND VALUE #( %tky        = gs_head-%tky
*                        %state_area = 'Validate_Head'
*                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                             text     = lv_msg3 ) )
*
*               TO reported-zi_ghead.
*      ENDIF.
*      SELECT SINGLE * FROM zpof4_final_n
*        WHERE purchaseorder = @ls_item-ebeln AND purchaseorderitem = @ls_item-ebelp
*        INTO @DATA(ls_pof4).
*      IF sy-subrc IS NOT INITIAL.
*        CONTINUE.
*      ENDIF.
*
*      IF ls_pof4-deliverydocument IS NOT INITIAL AND ( gs_head-miningpermissionno IS INITIAL OR gs_head-miningchallantpno IS INITIAL ).
*        DATA(lv_msg) = |MP/TP No. Cannot be blank|.
*        APPEND VALUE #( %tky = ls_item-%tky )
*               TO failed-zi_ghead.
*
*        APPEND VALUE #( %tky        = ls_item-%tky
*                        %state_area = 'Validate_Head'
*                        %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                             text     = lv_msg ) )
*
*               TO reported-zi_ghead.
*
*      ENDIF.

    ENDLOOP.


    "Total Amount Validation
    IF gs_head-type = 'PO' .
      SELECT id , item, purchaseorder , purchaseorderitem , material ,  ( netpriceamount * plantqty )  AS amount ,
      overdelivtolrtdlmtratioinpct , orderqty ,deliverqty , plantqty
       FROM @lt_item AS b
       INNER JOIN i_purchaseorderitemtp_2 AS a ON b~ebeln = a~purchaseorder
        AND b~ebelp = a~purchaseorderitem AND b~matnr = a~material
      INTO TABLE @DATA(lt_purchaseorderitemtp_2).

      DATA : lv_totalamt    TYPE dmbtr,
             lv_maxorderqty TYPE menge_d,
             lv_tolerance   TYPE menge_d,
             lv_itemamt     TYPE dmbtr.
      CLEAR : lv_totalamt.

*      LOOP AT lt_purchaseorderitemtp_2 INTO DATA(ls_purchaseorderitemtp_2).
      LOOP AT lt_item INTO DATA(ls_item1).
        READ TABLE lt_purchaseorderitemtp_2 INTO DATA(ls_purchaseorderitemtp_2) WITH KEY id = ls_item1-id
                                                                                        item = ls_item1-item .
        IF sy-subrc EQ 0.
          lv_itemamt  = ls_purchaseorderitemtp_2-amount.
          lv_totalamt = lv_totalamt + ls_purchaseorderitemtp_2-amount.
          lv_tolerance = ls_purchaseorderitemtp_2-overdelivtolrtdlmtratioinpct .
          lv_maxorderqty = ls_purchaseorderitemtp_2-orderqty * (  1 + ( lv_tolerance / 100 ) ).
          IF ls_purchaseorderitemtp_2-plantqty > ( lv_maxorderqty - ls_purchaseorderitemtp_2-deliverqty ).
            DATA(lv_msgne) = |Please check Plant Qty entered|.
            APPEND VALUE #( %tky = ls_new-%tky )
                 TO failed-zi_ghead.

            APPEND VALUE #( %tky        = ls_new-%tky
                            %state_area =  'Validate_Head'
                            %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                                 text     = lv_msgne ) )

                   TO reported-zi_ghead.
          ENDIF.
*        MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*                 ENTITY zi_gitem
*                 UPDATE
*                 FIELDS ( tamount  )
*                 WITH VALUE #( id = ls_item1-id
*                               ( %tky   = ls_item1-%tky
*                                 tamount = lv_itemamt
*                                 ) ).
        ENDIF.

      ENDLOOP.
*       MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*                 ENTITY zi_ghead
*                 UPDATE
*                 FIELDS ( Amountt  )
*                 WITH VALUE #( (  %tky     = gs_head-%tky
*                                Amountt = lv_totalamt
*                                 ) ).

    ENDIF.


    SELECT SINGLE * FROM i_plant
    WHERE plant = @ls_new-plantgateno
     INTO @DATA(ls_plant).

    SELECT SINGLE * FROM i_supplier
    WHERE supplier = @ls_plant-plantsupplier
    INTO @DATA(ls_supplier).

    SELECT SINGLE * FROM i_supplier
    WHERE supplier = @ls_new-vendorcode
    INTO @DATA(ls_vendor).

    IF ls_vendor-region = ls_supplier-region.
      IF lv_totalamt > 100000.
        IF ls_new-waybillno IS INITIAL .
          DATA(lv_msgn) = |Please enter the Waybill no|.
          APPEND VALUE #( %tky = ls_new-%tky )
               TO failed-zi_ghead.

          APPEND VALUE #( %tky        = ls_new-%tky
                          %state_area =  'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msgn ) )

                 TO reported-zi_ghead.
        ENDIF.

      ENDIF.
    ELSE.
      IF lv_totalamt > 50000.
        IF ls_new-waybillno IS INITIAL .
          DATA(lv_msgnn) = |Please enter the Waybill no|.
          APPEND VALUE #( %tky = ls_new-%tky )
               TO failed-zi_ghead.

          APPEND VALUE #( %tky        = ls_new-%tky
                          %state_area =  'Validate_Head'
                          %msg        = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                               text     = lv_msgnn ) )

                 TO reported-zi_ghead.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


METHOD checkdelno.

*--------------------------------------------------------------------*
* Read Changed Items
*--------------------------------------------------------------------*
  READ ENTITIES OF zi_ghead IN LOCAL MODE
      ENTITY zi_gitem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_changed_items).

  IF lt_changed_items IS INITIAL.
    RETURN.
  ENDIF.

*--------------------------------------------------------------------*
* Loop Changed Items
*--------------------------------------------------------------------*
  LOOP AT lt_changed_items INTO DATA(ls_item).

*--------------------------------------------------------------------*
* Read Header
*--------------------------------------------------------------------*
    READ ENTITIES OF zi_ghead IN LOCAL MODE
      ENTITY zi_gitem BY \_Head
      ALL FIELDS
      WITH VALUE #(
        ( %tky = ls_item-%tky )
      )
      RESULT DATA(lt_header).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    IF ls_header IS INITIAL.
      CONTINUE.
    ENDIF.

*--------------------------------------------------------------------*
* Validation : SALES Type
*--------------------------------------------------------------------*
    IF ( ls_header-type = 'SALES' OR ls_header-type = 'SALES RETURN' ).

*--------------------------------------------------------------------*
* Validate VBELN = Delivery Number
*--------------------------------------------------------------------*
      IF ls_item-vbeln IS NOT INITIAL
         AND ls_header-deliverynumber IS NOT INITIAL
         AND ls_item-vbeln <> ls_header-deliverynumber.

*--------------------------------------------------------------------*
* Error Message
*--------------------------------------------------------------------*
        APPEND VALUE #(
          %tky = ls_item-%tky

          %msg = new_message_with_text(
                    severity = if_abap_behv_message=>severity-error
                    text     = |Delivery Doc in line must match Header Delivery No|
                 )

          %element-vbeln = if_abap_behv=>mk-on

        ) TO reported-zi_gitem.

*--------------------------------------------------------------------*
* Failed Entry
*--------------------------------------------------------------------*
        APPEND VALUE #(
          %tky = ls_item-%tky
        ) TO failed-zi_gitem.

      ENDIF.

    ENDIF.

  ENDLOOP.

ENDMETHOD.


METHOD checkpoval.

  DATA:
    lv_netprice TYPE i_purchaseorderitemapi01-netpriceamount,
    lv_exp_val  TYPE p LENGTH 16 DECIMALS 2.

*--------------------------------------------------------------------*
* Read Changed Items
*--------------------------------------------------------------------*
  READ ENTITIES OF zi_ghead IN LOCAL MODE
    ENTITY zi_gitem
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_gitem).

  LOOP AT lt_gitem INTO DATA(ls_item).

*--------------------------------------------------------------------*
* Validation Applicable only for PO Type
*--------------------------------------------------------------------*
    SELECT SINGLE type
      FROM zc_ghead
      WHERE id = @ls_item-id
      INTO @DATA(lv_type).

    IF lv_type <> 'PO'.
      CONTINUE.
    ENDIF.

*--------------------------------------------------------------------*
* Mandatory Fields Check
*--------------------------------------------------------------------*
    IF ls_item-ebeln IS INITIAL
       OR ls_item-ebelp IS INITIAL
       OR ls_item-challanqty IS INITIAL.
      CONTINUE.
    ENDIF.

*--------------------------------------------------------------------*
* Challan Value Mandatory Check
*--------------------------------------------------------------------*
    IF ls_item-itemval1 IS INITIAL.

      APPEND VALUE #(
        %tky = ls_item-%tky
      ) TO failed-zi_gitem.

      APPEND VALUE #(
        %tky = ls_item-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text     = 'Challan Value is mandatory for PO documents'
               )
        %element-itemval1 = if_abap_behv=>mk-on
      ) TO reported-zi_gitem.

      CONTINUE.

    ENDIF.

*--------------------------------------------------------------------*
* Read PO Net Price
*--------------------------------------------------------------------*
    CLEAR lv_netprice.

    SELECT SINGLE netpriceamount
      FROM i_purchaseorderitemapi01
      WHERE purchaseorder     = @ls_item-ebeln
        AND purchaseorderitem = @ls_item-ebelp
      INTO @lv_netprice.

    IF sy-subrc <> 0.
      CONTINUE.
    ENDIF.

*--------------------------------------------------------------------*
* Calculate Expected Challan Value
*--------------------------------------------------------------------*
    lv_exp_val = ls_item-challanqty * lv_netprice.

*--------------------------------------------------------------------*
* Validate Challan Value
*--------------------------------------------------------------------*
    IF ls_item-itemval1 <> lv_exp_val.

      APPEND VALUE #(
        %tky = ls_item-%tky
      ) TO failed-zi_gitem.

      APPEND VALUE #(
        %tky = ls_item-%tky
        %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text = |Challan Value mismatch with PO Value.|
               )
        %element-itemval1 = if_abap_behv=>mk-on
      ) TO reported-zi_gitem.

    ENDIF.

  ENDLOOP.

ENDMETHOD.



*  METHOD popitem.
*    READ ENTITIES OF zi_ghead IN LOCAL MODE
*         ENTITY zi_ghead
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(lt_header)
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         FAILED FINAL(lt_header_failed).
*
*    READ ENTITIES OF zi_ghead IN LOCAL MODE
*         ENTITY zi_gitem
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(lt_item)
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         FAILED FINAL(lt_item_failed).
*
*    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
*    LOOP AT lt_item INTO DATA(ls_item).
**      lv_mat = |{ ls_item-matnr ALPHA = IN }|.
*      IF ls_item-pounique IS INITIAL AND ls_item-pouniquesto IS INITIAL.
*        CONTINUE.
*      ENDIF.
*
*      SELECT SINGLE * FROM zpof4_final_n
*        WHERE po             = @ls_item-pounique
*          AND purchaseorder IS NOT INITIAL
*        INTO @DATA(ls_item1).
*      IF ls_item1 IS INITIAL.
*        SELECT SINGLE * FROM zpof4_final_n_sto
*          WHERE po             = @ls_item-pouniquesto
*            AND purchaseorder IS NOT INITIAL
*          INTO @ls_item1.
*      ENDIF.
*      IF sy-subrc IS NOT INITIAL.
*        CONTINUE.
*      ENDIF.
*      ls_item-balanceqty = ls_item1-bal_qty.
*      ls_item-deliverqty = ls_item1-actualdeliveryquantity.
*      ls_item-ebeln      = ls_item1-purchaseorder.
*      ls_item-ebelp      = ls_item1-purchaseorderitem.
*      ls_item-maktx      = ls_item1-purchaseorderitemtext.
*      ls_item-meins      = ls_item1-purchaseorderquantityunit.
*      ls_item-vbeln      = ls_item1-deliverydocument.
*      ls_item-vbelp      = ls_item1-deliverydocumentitem.
*      ls_item-matnr      = ls_item1-material.
*      ls_item-vendor     = gs_head-vendorcode.
*      ls_item-orderqty   = ls_item1-orderquantity.
*      IF ls_item-mpno IS INITIAL.
*        ls_item-mpno       = ls_item1-deliverydocumentbysupplier.
*      ENDIF.
*      IF ls_item-tpno IS INITIAL.
*        ls_item-tpno       = ls_item1-billoflading.
*      ENDIF.
*      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*             ENTITY zi_gitem
*             UPDATE
*             FIELDS ( ebeln balanceqty deliverqty ebelp maktx meins vbeln vbelp matnr vendor orderqty mpno tpno ) "
*             WITH VALUE #( id = ls_item-id
*                           ( %tky       = ls_item-%tky
*                             balanceqty = ls_item-balanceqty
*                             deliverqty = ls_item-deliverqty
*                             ebeln      = ls_item-ebeln
*                             ebelp      = ls_item-ebelp
*                             maktx      = ls_item-maktx
*                             meins      = ls_item-meins
*                             vbeln      = ls_item-vbeln
*                             vbelp      = ls_item-vbelp
*                             matnr      = ls_item-matnr
*                             vendor     = ls_item-vendor
*                             orderqty   = ls_item-orderqty
*                             mpno       = ls_item-mpno
*                             tpno       = ls_item-tpno  ) ).
*    ENDLOOP.
*  ENDMETHOD.

  METHOD popmaterial.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_ghead
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_gitem
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    " TODO: variable is assigned but never used (ABAP cleaner)
    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    LOOP AT lt_item INTO DATA(ls_item).
      DATA lv_char TYPE char18.
      lv_char = |{ ls_item-matnr ALPHA = IN }|.
      SELECT SINGLE * FROM zi_nonpof4 WHERE product = @lv_char INTO @DATA(ls_mat).
      IF sy-subrc IS NOT INITIAL.
        CONTINUE.
      ENDIF.
      IF ls_item-maktx IS INITIAL.
        ls_item-maktx = ls_mat-productdescription.
      ENDIF.
      IF ls_item-meins IS INITIAL.
        ls_item-meins = ls_mat-baseunit.

      ENDIF.
      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
              ENTITY zi_gitem
              UPDATE
              FIELDS ( maktx meins ) "
              WITH VALUE #( id = ls_item-id
                            ( %tky  = ls_item-%tky
                              maktx = ls_item-maktx
                              meins = ls_item-meins ) ).

    ENDLOOP.
  ENDMETHOD.

*  METHOD popitemsto.
*    READ ENTITIES OF zi_ghead IN LOCAL MODE
*           ENTITY zi_ghead
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT FINAL(lt_header)
*           " TODO: variable is assigned but never used (ABAP cleaner)
*           FAILED FINAL(lt_header_failed).
*
*    READ ENTITIES OF zi_ghead IN LOCAL MODE
*         ENTITY zi_gitem
*         ALL FIELDS
*         WITH CORRESPONDING #( keys )
*         RESULT FINAL(lt_item)
*         " TODO: variable is assigned but never used (ABAP cleaner)
*         FAILED FINAL(lt_item_failed).
*
*    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
*    LOOP AT lt_item INTO DATA(ls_item).
**      lv_mat = |{ ls_item-matnr ALPHA = IN }|.
*      IF ls_item-pouniquesto IS INITIAL AND ls_item-pounique IS INITIAL.
*        CONTINUE.
*      ENDIF.
*
*      SELECT SINGLE * FROM zpof4_final_n_sto
*        WHERE po             = @ls_item-pouniquesto
*          AND purchaseorder IS NOT INITIAL
*        INTO @DATA(ls_item1).
*      IF sy-subrc IS NOT INITIAL.
*        CONTINUE.
*      ENDIF.
*      ls_item-balanceqty = ls_item1-bal_qty.
*      ls_item-deliverqty = ls_item1-actualdeliveryquantity.
*      ls_item-ebeln      = ls_item1-purchaseorder.
*      ls_item-ebelp      = ls_item1-purchaseorderitem.
*      ls_item-maktx      = ls_item1-purchaseorderitemtext.
*      ls_item-meins      = ls_item1-purchaseorderquantityunit.
*      ls_item-vbeln      = ls_item1-deliverydocument.
*      ls_item-vbelp      = ls_item1-deliverydocumentitem.
*      ls_item-matnr      = ls_item1-material.
*      ls_item-vendor     = gs_head-vendorcode.
*      ls_item-orderqty   = ls_item1-orderquantity.
*      IF ls_item-mpno IS INITIAL.
*        ls_item-mpno       = ls_item1-deliverydocumentbysupplier.
*      ENDIF.
*      IF ls_item-tpno IS INITIAL.
*        ls_item-tpno       = ls_item1-billoflading.
*      ENDIF.
*      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*             ENTITY zi_gitem
*             UPDATE
*             FIELDS ( ebeln balanceqty deliverqty ebelp maktx meins vbeln vbelp matnr vendor orderqty mpno tpno ) "
*             WITH VALUE #( id = ls_item-id
*                           ( %tky       = ls_item-%tky
*                             balanceqty = ls_item-balanceqty
*                             deliverqty = ls_item-deliverqty
*                             ebeln      = ls_item-ebeln
*                             ebelp      = ls_item-ebelp
*                             maktx      = ls_item-maktx
*                             meins      = ls_item-meins
*                             vbeln      = ls_item-vbeln
*                             vbelp      = ls_item-vbelp
*                             matnr      = ls_item-matnr
*                             vendor     = ls_item-vendor
*                             orderqty   = ls_item-orderqty
*                             mpno       = ls_item-mpno
*                             tpno       = ls_item-tpno  ) ).
*    ENDLOOP.
*  ENDMETHOD.

  METHOD poitem1.

    "DATA: l_item TYPE zdt_gitem-gateitem.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
            ENTITY zi_ghead
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_gitem
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).


    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    IF gs_head-type = 'PO'.
      IF lt_item IS NOT INITIAL.
        SELECT id , ebeln , ebelp , plantqty FROM zdt_gitem
        FOR ALL ENTRIES IN @lt_item WHERE ebeln = @lt_item-ebeln AND ebelp = @lt_item-ebelp AND id <> @gs_head-id
        INTO TABLE @DATA(lt_pogitem) .

        SELECT ebeln , ebelp , SUM( plantqty ) AS plantqty FROM @lt_pogitem AS a
         GROUP BY ebeln , ebelp
        INTO TABLE @DATA(lt_pog_group_item).
      ENDIF.
    ENDIF.






    LOOP AT lt_item INTO DATA(ls_item).
*      lv_mat = |{ ls_item-matnr ALPHA = IN }|.
      IF ls_item-ebeln IS INITIAL.
        CONTINUE.
      ENDIF.

      SELECT SINGLE * FROM zpof4_final_n
        WHERE purchaseorder            = @ls_item-ebeln AND purchaseorderitem = @ls_item-ebelp
        INTO @DATA(ls_item1).


      IF sy-subrc IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      Select single * from zr_balqty_grn where
          Ebeln = @ls_item-ebeln AND ebelp = @ls_item-ebelp
        INTO @DATA(ls_item_grn).

      SELECT a~ebeln , a~ebelp , SUM( a~plantqty ) AS plantqty
      FROM zdt_gitem AS a
      WHERE a~ebeln = @ls_item-ebeln AND a~ebelp = @ls_item1-purchaseorderitem
        AND a~item <> @ls_item-item
      GROUP BY ebeln , ebelp
      INTO TABLE @DATA(lt_gateitem).



      IF gs_head-type = 'PO'.
        IF lt_pog_group_item IS NOT INITIAL.
          READ TABLE lt_pog_group_item INTO DATA(ls_pog_group_item) WITH KEY ebeln = ls_item-ebeln ebelp = ls_item-ebelp.
          IF sy-subrc EQ 0.
            ls_item-deliverqty = ls_pog_group_item-plantqty - ls_item_grn-reve_qty.
            ls_item-balanceqty = ls_item1-orderquantity - ls_item-deliverqty  .
          ELSE.
            ls_item-balanceqty = ls_item1-orderquantity .
          ENDIF.
        ELSE.
          ls_item-balanceqty = ls_item1-orderquantity .
        ENDIF.
      ENDIF.


*      READ TABLE lt_gateitem INTO DATA(ls_gateitem) WITH KEY ebeln = ls_item-ebeln ebelp = ls_item-ebelp.
*      IF sy-subrc EQ 0.
*        ls_item-deliverqty = ls_gateitem-plantqty.
*        ls_item-balanceqty = ls_item1-orderquantity - ls_item-deliverqty.
*      ELSE.
*        ls_item-balanceqty = ls_item1-orderquantity.
*      ENDIF.
      ls_item-ebeln      = ls_item1-purchaseorder.
      ls_item-ebelp      = ls_item1-purchaseorderitem.
      ls_item-maktx      = ls_item1-purchaseorderitemtext.
      ls_item-meins      = ls_item1-purchaseorderquantityunit.
      ls_item-vbeln      = ls_item1-deliverydocument.
      ls_item-vbelp      = ls_item1-deliverydocumentitem.
      ls_item-matnr      = ls_item1-material.
      " ls_item-gateitem   = l_item.
      ls_item-vendor     = gs_head-vendorcode.
      ls_item-orderqty   = ls_item1-orderquantity.
      IF ls_item-mpno IS INITIAL.
        ls_item-mpno       = ls_item1-deliverydocumentbysupplier.
      ENDIF.
      IF ls_item-tpno IS INITIAL.
        ls_item-tpno       = ls_item1-billoflading.
      ENDIF.

      IF ls_item1-purchaseorder IS NOT INITIAL.
        SELECT SINGLE plainlongtext
        FROM i_purchaseorderitemnotetp_2
        WHERE purchaseorder = @ls_item1-purchaseorder AND purchaseorderitem = @ls_item1-purchaseorderitem
          AND language = 'E' AND textobjecttype = 'F01'
        INTO @DATA(lv_longtext).
        ls_item-potext = lv_longtext.
      ENDIF.

      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
             ENTITY zi_gitem
             UPDATE
             FIELDS ( balanceqty deliverqty ebelp maktx meins vbeln vbelp matnr vendor orderqty mpno tpno potext ) "gateitem
             WITH VALUE #( id = ls_item-id
                           ( %tky       = ls_item-%tky
                             balanceqty = ls_item-balanceqty
                             deliverqty = ls_item-deliverqty
                             ebelp      = ls_item-ebelp
                             maktx      = ls_item-maktx
                             meins      = ls_item-meins
                             vbeln      = ls_item-vbeln
                             vbelp      = ls_item-vbelp
                             matnr      = ls_item-matnr
                             vendor     = ls_item-vendor
                             orderqty   = ls_item-orderqty
                             mpno       = ls_item-mpno
                             tpno       = ls_item-tpno
                             potext     = ls_item-potext
                             "gateitem   = ls_item-gateitem
                              ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD copy.
*    READ ENTITIES OF zi_ghead IN LOCAL MODE ENTITY zi_ghead ALL FIELDS WITH CORRESPONDING #( keys )
*          " TODO: variable is assigned but never used (ABAP cleaner)
*          RESULT DATA(lt_header) FAILED DATA(lt_header_failed).
*    DATA(lv_s) = VALUE #( lt_header[ 1 ]  OPTIONAL ).
*
*    SELECT SINGLE * FROM zr_hgate_f4 WHERE gatepass = @lv_s-rgpgatepass INTO @DATA(lv_data).
*    lv_s-rgpdate = lv_data-createdate.
*
*    SELECT SINGLE id , challannumber FROM zdt_ghead  WHERE challannumber = @lv_s-rgpgatepass
*    INTO @DATA(ls_hdr).
*
*    SELECT * FROM zdt_gitem  WHERE id = @ls_hdr-id
*    INTO TABLE @DATA(lt_gitem).
*
*
*    MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*           ENTITY zi_ghead
*           UPDATE
*           FIELDS ( rgpdate )
*           WITH VALUE #( ( %tky    = lv_s-%tky
*                           rgpdate = lv_s-rgpdate ) ).
*
*    LOOP AT lt_gitem INTO DATA(ls_item1).
*      TRY.
*          DATA(lv_item) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
*        CATCH cx_uuid_error.
*          " handle exception
*      ENDTRY.
*
*      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
*             ENTITY zi_ghead
*             CREATE BY \_item
*             FROM VALUE #( ( id      = ls_hdr-id
*                             %target = VALUE #( ( %cid                = lv_item " lv_numc &&
*                                                  item                = lv_item " lv_numc &&
*                                                  matnr               = ls_item1-matnr
*                                                  maktx               = ls_item1-maktx
*                                                  meins               = ls_item1-meins
*                                                  vbeln               = ls_item1-vbeln
*                                                  vbelp               = ls_item1-vbelp
**                                                  deliverqty          = ls_item1-actualdeliveryquantity
**                                                  challanqty          = ls_item1-actualdeliveryquantity
*                                                  custcode            = ls_item1-custcode
*                                                  custdesc            = ls_item1-custdesc
*
**                                                  ebeln               = ls_item1-referencesddocument
**                                                  ebelp               = ls_item1-referencesddocumentitem
*                                                  %control-matnr      = if_abap_behv=>mk-on
*                                                  %control-vbeln      = if_abap_behv=>mk-on
*                                                  %control-ebeln      = if_abap_behv=>mk-on
*                                                 %control-ebelp      = if_abap_behv=>mk-on
*                                                  %control-maktx      = if_abap_behv=>mk-on
*                                                  %control-meins      = if_abap_behv=>mk-on
*                                                  %control-vbelp      = if_abap_behv=>mk-on
*                                                 " %control-deliverqty = if_abap_behv=>mk-on
*                                                  %control-item       = if_abap_behv=>mk-on
*                                                  %control-custcode   = if_abap_behv=>mk-on
*                                                  %control-custdesc   = if_abap_behv=>mk-on
*                                                 " %control-challanqty = if_abap_behv=>mk-on
*                                                   ) ) ) )
*
*                                                                      " TODO: variable is assigned but never used (ABAP cleaner)
*             MAPPED DATA(ls_mapped)
*              " TODO: variable is assigned but never used (ABAP cleaner)
*             FAILED DATA(ls_failed)
*             " TODO: variable is assigned but never used (ABAP cleaner)
*             REPORTED DATA(ls_reported).
*    ENDLOOP.
*
*
*    READ ENTITY zi_ghead
*      BY \_item
*      ALL FIELDS
*      WITH CORRESPONDING #( keys )
*      RESULT FINAL(item_upd).
*
*    result = VALUE #( FOR ls_item2 IN item_upd
*                          ( %tky   = ls_item2-%tky
*                            %param = ls_item2 ) ).
*  ENDMETHOD.

  METHOD vbelnfind.

    READ ENTITIES OF zi_ghead IN LOCAL MODE
            ENTITY zi_ghead
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_gitem
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    LOOP AT lt_item INTO DATA(ls_item).

      IF ls_item-vbeln IS INITIAL.
        CONTINUE.
      ENDIF.

      SELECT SINGLE * FROM zi_salesf4
        WHERE deliverydocument            = @ls_item-vbeln AND deliverydocumentitem = @ls_item-vbelp
        INTO @DATA(ls_item1).

      IF sy-subrc IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      SELECT SINGLE * FROM zi_deldash_hdr
      WHERE delivery = @ls_item-vbeln AND forwarder IS NOT INITIAL
       INTO @DATA(ls_deldash).

      ls_item-maktx        = ls_item1-deliverydocumentitemtext.
      ls_item-meins        = ls_item1-deliveryquantityunit.
      ls_item-vbeln        = ls_item1-deliverydocument.
      ls_item-vbelp        = ls_item1-deliverydocumentitem.
      ls_item-matnr        = ls_item1-product.
      ls_item-vendor       = gs_head-vendorcode.
      ls_item-orderqty     = ls_item1-actualdeliveryquantity.
      ls_item-creationdate = ls_item1-creationdate.
      ls_item-custcode     = ls_item1-soldtoparty.
      ls_item-custdesc     = ls_item1-customername.
      IF gs_head-type <> 'RGP' .
        ls_item-meins        = ls_item1-deliveryquantityunit.
      ENDIF.

      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
             ENTITY zi_gitem
             UPDATE
             FIELDS (  maktx meins vbelp matnr vendor orderqty creationdate ) "
             WITH VALUE #( id = ls_item-id
                           ( %tky       = ls_item-%tky
                             maktx      = ls_item-maktx
                             meins      = ls_item-meins
                             vbelp      = ls_item-vbelp
                             matnr      = ls_item-matnr
                             vendor     = ls_item-vendor
                             orderqty   = ls_item-orderqty
                             custcode = ls_item-custcode
                             custdesc = ls_item-custdesc
                             creationdate = ls_item-creationdate  ) ).
*- SOC : Not Required Forword YTransporter in Gate : SM : 11.04.25
***      IF gs_head-transportercode IS INITIAL .
***        MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
***                ENTITY zi_ghead
***                UPDATE
***                FIELDS ( transportercode transportername )
***                WITH VALUE #( ( %tky  = gs_head-%tky
***                                transportercode = ls_deldash-forwarder
***                                transportername = ls_deldash-forwardernam ) ).
***      ENDIF.
*- EOC : Not Required Forword YTransporter in Gate : SM : 11.04.25
    ENDLOOP.

  ENDMETHOD.

  METHOD matdocfind.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
          ENTITY zi_ghead
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT FINAL(lt_header)
          " TODO: variable is assigned but never used (ABAP cleaner)
          FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_gitem
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    LOOP AT lt_item INTO DATA(ls_item).
*      lv_mat = |{ ls_item-matnr ALPHA = IN }|.
      IF ls_item-mblnr IS INITIAL.
        CONTINUE.
      ENDIF.

      SELECT SINGLE * FROM zr_mblnr_f4
        WHERE materialdocument            = @ls_item-mblnr AND materialdocumentitem = @ls_item-zeile
        AND materialdocumentyear = @ls_item-mjahr
        INTO @DATA(ls_item1).

      IF sy-subrc IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      ls_item-maktx      = ls_item1-productname.
      ls_item-meins      = ls_item1-entryunit.
      ls_item-matnr      = ls_item1-material.
      ls_item-vendor     = gs_head-vendorcode.
      ls_item-orderqty   = ls_item1-quantityinentryunit.

      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
             ENTITY zi_gitem
             UPDATE
             FIELDS (  maktx meins matnr vendor orderqty ) "
             WITH VALUE #( id = ls_item-id
                           ( %tky       = ls_item-%tky
                             maktx      = ls_item-maktx
                             meins      = ls_item-meins
                             matnr      = ls_item-matnr
                             vendor     = ls_item-vendor
                             orderqty   = ls_item-orderqty  ) ).
    ENDLOOP.
  ENDMETHOD.

*  METHOD gateitem.
*
*  ENDMETHOD.

  METHOD updateitem.

    READ ENTITIES OF zi_ghead IN LOCAL MODE
           ENTITY zi_ghead
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT FINAL(lt_header)
           " TODO: variable is assigned but never used (ABAP cleaner)
           FAILED FINAL(lt_header_failed).

    FINAL(gs_head) = VALUE #( lt_header[ 1 ] OPTIONAL ).

    DATA : l_val TYPE zdt_ghead-ernam.
    IF gs_head-ernam IS INITIAL.
      l_val = sy-uname. "gs_head-ernam.
      "l_val = l_val + 1.
      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
          ENTITY zi_ghead
          UPDATE
          FIELDS ( ernam )
          WITH VALUE #( ( %tky  = gs_head-%tky
                          ernam = l_val ) ).
    ENDIF.

    READ ENTITY zi_ghead
         BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(item_failed).

    FINAL(ls_new) = VALUE #( lt_header[ 1 ] OPTIONAL ).
    FINAL(ls_item_f) = VALUE #( lt_item[ 1 ] OPTIONAL ).

    IF gs_head-type <> 'CASH ENTRY'.
      SELECT id , item, purchaseorder , purchaseorderitem , material ,  ( netpriceamount * plantqty )  AS amount ,
      overdelivtolrtdlmtratioinpct , orderqty ,deliverqty , plantqty
       FROM @lt_item AS b
       INNER JOIN i_purchaseorderitemtp_2 AS a ON b~ebeln = a~purchaseorder
        AND b~ebelp = a~purchaseorderitem AND b~matnr = a~material
      INTO TABLE @DATA(lt_purchaseorderitemtp_2).

      DATA : lv_totalamt    TYPE dmbtr,
             lv_maxorderqty TYPE menge_d,
             lv_tolerance   TYPE menge_d,
             lv_itemamt     TYPE dmbtr.
      CLEAR : lv_totalamt.

*      LOOP AT lt_purchaseorderitemtp_2 INTO DATA(ls_purchaseorderitemtp_2).
      LOOP AT lt_item INTO DATA(ls_item1).
        READ TABLE lt_purchaseorderitemtp_2 INTO DATA(ls_purchaseorderitemtp_2) WITH KEY id = ls_item1-id
                                                                                        item = ls_item1-item .
        IF sy-subrc EQ 0.
          lv_itemamt  = ls_purchaseorderitemtp_2-amount.
          lv_totalamt = lv_totalamt + ls_purchaseorderitemtp_2-amount.
          MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
                   ENTITY zi_gitem
                   UPDATE
                   FIELDS ( tamount  )
                   WITH VALUE #( id = ls_item1-id
                                 ( %tky   = ls_item1-%tky
                                   tamount = lv_itemamt
                                   ) ).
        ENDIF.

      ENDLOOP.
      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
                ENTITY zi_ghead
                UPDATE
                FIELDS ( amountt  )
                WITH VALUE #( (  %tky     = gs_head-%tky
                               amountt = lv_totalamt
                                ) ).

    ENDIF.

  ENDMETHOD.

  METHOD weighment_wt.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
    ENTITY zi_ghead
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT FINAL(lt_header)
    " TODO: variable is assigned but never used (ABAP cleaner)
    FAILED FINAL(lt_header_failed).
*
    READ ENTITY zi_ghead
        BY \_item
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    DATA(ls_header) = VALUE #( lt_header[ 1 ] OPTIONAL ).



    SELECT MAX( grswt ) AS max_gross_wt FROM @lt_item AS a
    INTO TABLE @DATA(lt_grosswt).

    DATA(gs_grosswt_max) = VALUE #( lt_grosswt[ 1 ] OPTIONAL ).

    SELECT MIN( tarwt ) AS min_tare_wt FROM @lt_item AS b
     INTO TABLE @DATA(lt_tarewt).

    DATA(gs_tarewt_min) = VALUE #( lt_tarewt[ 1 ] OPTIONAL ).
    DATA(gs_netwt) = gs_grosswt_max-max_gross_wt - gs_tarewt_min-min_tare_wt .


    IF lt_item IS NOT INITIAL AND ( ls_header-grswt <> gs_grosswt_max-max_gross_wt OR ls_header-netwt <> gs_netwt OR ls_header-tarwt <> gs_tarewt_min-min_tare_wt   ).
      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
          ENTITY zi_ghead
          UPDATE
          FIELDS ( grswt tarwt netwt ) "
              WITH VALUE #(
                            ( %tky  = ls_header-%tky
                              grswt = gs_grosswt_max-max_gross_wt
                              tarwt = gs_tarewt_min-min_tare_wt
                              netwt = gs_netwt ) ).
*                                  transportername = ls_item1-yy1_transportername_dlh ) ).


    ENDIF.

  ENDMETHOD.

  METHOD popweiunit.
    READ ENTITIES OF zi_ghead IN LOCAL MODE
            ENTITY zi_ghead
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT FINAL(lt_header)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(lt_header_failed).

    READ ENTITIES OF zi_ghead IN LOCAL MODE
         ENTITY zi_gitem
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(lt_item)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_item_failed).

    LOOP AT lt_item INTO DATA(ls_item).

      IF ls_item-meins = 'KG' OR ls_item-meins = 'TO'.
        ls_item-wtunit = ls_item-meins.
      ELSE.
        ls_item-wtunit = 'KG'.
      ENDIF.

      MODIFY ENTITIES OF zi_ghead IN LOCAL MODE
                ENTITY zi_gitem
                UPDATE
                FIELDS (  wtunit ) "
                WITH VALUE #( id = ls_item-id
                              ( %tky       = ls_item-%tky
                                wtunit     = ls_item-wtunit  ) ).
      CLEAR : ls_item.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
