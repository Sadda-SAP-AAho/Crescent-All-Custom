CLASS lhc_zi_ocform_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_ocform_header RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_ocform_header RESULT result.

    METHODS print FOR MODIFY
      IMPORTING keys FOR ACTION zi_ocform_header~print RESULT result.

ENDCLASS.

CLASS lhc_zi_ocform_header IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITIES OF zi_ocform_header IN LOCAL MODE
                   ENTITY zi_ocform_header
                   ALL FIELDS
                   WITH CORRESPONDING #( keys )
                   RESULT FINAL(header)
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   FAILED FINAL(header_failed).

    result = VALUE #(
             FOR gs_header IN header
                 ( %tky = gs_header-%tky
                   %action-print = COND #(
                   WHEN gs_header-ordno IS NOT INITIAL
                   THEN if_abap_behv=>fc-o-enabled ) ) ).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD print.
    READ ENTITIES OF zi_ocform_header IN LOCAL MODE
                   ENTITY zi_ocform_header
                   ALL FIELDS
                   WITH CORRESPONDING #( keys )
                   RESULT DATA(header)
                   " TODO: variable is assigned but never used (ABAP cleaner)
                   FAILED FINAL(header_failed).

    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

        <fs_print>-printflag = 'X'.
        <fs_print>-flag = 'A'.

        MODIFY ENTITIES OF zi_ocform_header IN LOCAL MODE
                ENTITY zi_ocform_header
                UPDATE
                FIELDS ( printflag flag )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 printflag =  <fs_print>-printflag
                                 flag = <fs_print>-flag
                                 %control-flag   = if_abap_behv=>mk-on
                                 %control-printflag   = if_abap_behv=>mk-on
                              ) ).

      ENDIF.
    ENDLOOP.

    " Fill the response table
    READ ENTITIES OF zi_ocform_header IN LOCAL MODE
         ENTITY  zi_ocform_header
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_ocform_header DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_ocform_header IMPLEMENTATION.

  METHOD save_modified.

    IF update-zi_ocform_header IS NOT INITIAL.

      DATA: lv_printq TYPE char32.
      SELECT SINGLE * FROM zdt_print_queue WHERE cbuser = @sy-uname INTO @DATA(ls_printq).
      IF sy-subrc = 0.
        lv_printq = ls_printq-printque.
      ELSE.
        lv_printq = 'ZDEFAULT'.
      ENDIF.
      DATA(lt_head) = update-zi_ocform_header.
      READ TABLE lt_head INDEX 1 INTO DATA(wa_head).

      IF wa_head-flag = 'A'.

        TRY.
            "Initialize Template Store Client
            DATA(lo_store1) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util1) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSD_OCPRINT'
                                                                  iv_root_node = 'ZCUS_OCFORM' ) .

            TRY.
                lo_store1->get_schema_by_name(  iv_form_name = 'OCFORM' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error1).
                "" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
                "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error1->mv_http_status_code = 404 OR lo_tmpl_error1->mv_http_status_code = 403 .
*                  lo_store1->set_schema(
*                    iv_form_name = 'OCFORM'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util1->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
                "" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys1)     = lo_fdp_util1->get_keys( ).
            lt_keys1[ name = 'ORDNO' ]-value = lt_head[ 1 ]-ordno.
            TRY.
                DATA(lv_xml1) = lo_fdp_util1->read_to_xml( lt_keys1 ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception1).
            ENDTRY.
            DATA(ls_template1) = lo_store1->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'OCFORM'
              iv_template_name = 'OCFORM'
            ).
            cl_fp_ads_util=>render_4_pq(
             EXPORTING
               iv_locale       = 'en_US'
               iv_pq_name      = lv_printq
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
            lv_text1 = |Order Confirmation Print-| && lt_head[ 1 ]-ordno.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq
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
