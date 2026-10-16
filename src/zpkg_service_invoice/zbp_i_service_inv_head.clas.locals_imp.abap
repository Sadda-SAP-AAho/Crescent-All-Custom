CLASS lhc_zi_service_inv_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_service_inv_head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_service_inv_head RESULT result.

    METHODS print FOR MODIFY
      IMPORTING keys FOR ACTION zi_service_inv_head~print RESULT result.

ENDCLASS.


CLASS lhc_zi_service_inv_head IMPLEMENTATION.
  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD print.
    READ ENTITIES OF zi_service_inv_head IN LOCAL MODE
         ENTITY zi_service_inv_head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_header)
         " TODO: variable is assigned but never used (ABAP cleaner)
         FAILED FINAL(lt_header_failed).

    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<fs_head>).
      IF <fs_head> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

      <fs_head>-tprint = 'X'.

      MODIFY ENTITIES OF zi_service_inv_head IN LOCAL MODE
             ENTITY zi_service_inv_head
             UPDATE
             FIELDS ( tprint )
             WITH VALUE #( FOR key IN keys
                           ( %tky            = <fs_head>-%tky
                             tprint          = <fs_head>-tprint
                             %control-tprint = if_abap_behv=>mk-on ) )
              " TODO: variable is assigned but never used (ABAP cleaner)
             FAILED FINAL(failed1)
             " TODO: variable is assigned but never used (ABAP cleaner)
             REPORTED FINAL(reported1).
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_service_inv_head IN LOCAL MODE
         ENTITY zi_service_inv_head
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.
ENDCLASS.


CLASS lsc_zi_service_inv_head DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save_modified    REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.


CLASS lsc_zi_service_inv_head IMPLEMENTATION.
  METHOD save_modified.
    DATA lv_name TYPE char120.

    IF update-zi_service_inv_head IS INITIAL.
      RETURN.
    ENDIF.

    FINAL(lt_head) = update-zi_service_inv_head.
    IF lt_head[ 1 ]-tprint <> 'X'.
      RETURN.
    ENDIF.
    SELECT SINGLE * FROM zr_printqueue
          WHERE cbuser = @sy-uname
           INTO @DATA(ls_queue).

    IF sy-subrc IS NOT INITIAL.

      ls_queue-printque = 'ZDEFAULT'.

    ENDIF.
    TRY.
        " Initialize Template Store Client
        FINAL(lo_store) = NEW zcl_fp_tmpl_store_client1( iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
                                                         iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST' ).

        FINAL(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition = 'ZSD_INV_PRINT'
                                                               iv_root_node = 'ZZVVHEADER' ).

        TRY.
            lo_store->get_schema_by_name( iv_form_name = 'SERVICEINVOICE' ).
            "   out->write( 'Schema found in form' ).
          CATCH zcx_fp_tmpl_store_error1 INTO FINAL(lo_tmpl_error).
            "  out->write( 'No schema in form found' ).
*            IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403.
*              " Upload service definition
*              lo_store->set_schema( iv_form_name = 'SERVICEINVOICE'
*                                    is_data      = VALUE #( note        = ''
*                                                            schema_name = 'schema'
*                                                            xsd_schema  = lo_fdp_util->get_xsd( ) ) ).
*            ELSE.
*
*            ENDIF.
        ENDTRY.

        DATA(lt_keys) = lo_fdp_util->get_keys( ).
        lt_keys[ name = 'INVOICENO' ]-value = lt_head[ 1 ]-invoiceno.
*            lt_keys[ name = 'FISCALYEAR' ]-value = lt_head[ 1 ]-fiscalyear.

        TRY.
            FINAL(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
            " out->write( 'Service data retrieved' ).
          CATCH cx_fp_fdp_error INTO FINAL(lo_exception). " TODO: variable is assigned but never used (ABAP cleaner)
        ENDTRY.

        FINAL(ls_template) = lo_store->get_template_by_name( iv_get_binary    = abap_true
                                                             iv_form_name     = 'SERVICEINVOICE'
                                                             iv_template_name = 'SERVICEINVOICE' ).

        cl_fp_ads_util=>render_4_pq( EXPORTING iv_locale       = 'en_US'
                                               iv_pq_name      = CONV zde_pqname( ls_queue-printque ) " 'YYSERVINV' "'PRINT_QUEUE'
                                               iv_xml_data     = lv_xml
                                               iv_xdp_layout   = ls_template-xdp_template
                                               is_options      = VALUE #( trace_level = 4 ) " Use 0 in production environment
                                     IMPORTING
                                     " TODO: variable is assigned but never used (ABAP cleaner)
                                               ev_trace_string = FINAL(lv_trace)
                                               ev_pdl          = FINAL(lv_pdf) ).
        lv_name = |Service Invoice Print { lt_head[ 1 ]-invoiceno }|.
        cl_print_queue_utils=>create_queue_item_by_data(
            iv_qname            = CONV zde_pqname( ls_queue-printque ) "'YYSERVINV'
            iv_print_data       = lv_pdf
            iv_name_of_main_doc = lv_name
            iv_itemid           = cl_print_queue_utils=>create_queue_itemid( ) ).

      CATCH cx_fp_fdp_error
            zcx_fp_tmpl_store_error1
            cx_fp_ads_util.
        " out->write( 'Exception occurred.' ).
    ENDTRY.
    " out->write( 'Finished processing.' ).
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
