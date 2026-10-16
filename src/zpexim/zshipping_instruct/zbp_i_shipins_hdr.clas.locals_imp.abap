CLASS lhc_zi_shipins_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_shipins_hdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_shipins_hdr RESULT result.

    METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION zi_shipins_hdr~cancel RESULT result.

    METHODS print FOR MODIFY
      IMPORTING keys FOR ACTION zi_shipins_hdr~print RESULT result.
    METHODS headerdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_shipins_hdr~headerdetails.

ENDCLASS.

CLASS lhc_zi_shipins_hdr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD cancel.
  ENDMETHOD.

  METHOD print.
    READ ENTITIES OF zi_shipins_hdr IN LOCAL MODE
            ENTITY zi_shipins_hdr
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT DATA(header)
            " TODO: variable is assigned but never used (ABAP cleaner)
            FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

        <fs_print>-tprint = 'X'.

        MODIFY ENTITIES OF zi_shipins_hdr IN LOCAL MODE
                ENTITY zi_shipins_hdr
                UPDATE
                FIELDS ( tprint )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 tprint =  <fs_print>-tprint
                                  %control-tprint   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_shipins_hdr IN LOCAL MODE
         ENTITY  zi_shipins_hdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD headerdetails.
    READ ENTITIES OF zi_shipins_hdr IN LOCAL MODE
      ENTITY zi_shipins_hdr
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      FAILED DATA(lt_header_failed).

    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<lfs_header>).


      SELECT SINGLE b~incotermsclassification,c~streetname,c~shipinsadd
      FROM zi_deldash_hdr AS a
      LEFT OUTER JOIN i_deliverydocument AS b ON a~delivery = b~deliverydocument
      LEFT OUTER JOIN ZCDS_DEL_CUSDET    AS c ON c~customer = b~shiptoparty
                                              AND c~DeliveryDocument = b~DeliveryDocument
                                              AND c~pfunc = 'WE'
      WHERE bookingno = @<lfs_header>-bookingno
      INTO @DATA(ls_det).
      IF sy-subrc = 0.
        <lfs_header>-consadd1 = ls_det-shipinsadd.
        <lfs_header>-constreet1 = ls_det-streetname.
        <lfs_header>-shippingtype = ls_det-incotermsclassification.
      ENDIF.
      MODIFY ENTITIES OF zi_shipins_hdr IN LOCAL MODE
          ENTITY zi_shipins_hdr
          UPDATE
              FIELDS ( consadd1 constreet1 shippingtype )
              WITH VALUE #(
                             ( %tky        = <lfs_header>-%tky
                              shippingtype = <lfs_header>-shippingtype
                              consadd1     = <lfs_header>-consadd1
                              constreet1   = <lfs_header>-constreet1
                                 %control-shippingtype      = if_abap_behv=>mk-on
                                 %control-consadd1        = if_abap_behv=>mk-on
                                 %control-constreet1       = if_abap_behv=>mk-on
                             ) ).

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_shipins_hdr DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_shipins_hdr IMPLEMENTATION.

  METHOD save_modified.
    IF update-zi_shipins_hdr IS NOT INITIAL.

      DATA(lt_head) = update-zi_shipins_hdr.

      TRY.
          "Initialize Template Store Client
          DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
            iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
            iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
          ).

          DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSERV_SHIP_PRINT' ) .

          TRY.
              lo_store->get_schema_by_name( iv_form_name = 'SHIPINST' ).
            CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
"" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
 "" multiple times and hence user was unable to generate print
*              IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
*                lo_store->set_schema(
*                  iv_form_name = 'SHIPINST'
*                  is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
*                ).
*              ELSE.
*              ENDIF.
"" End Of Comment KJ 06.06.2025
          ENDTRY.

          DATA(lt_keys)     = lo_fdp_util->get_keys( ).
*        lt_keys[ name = 'ID' ]-value = lt_head[ 1 ]-id.
          lt_keys[ name = 'BOOKINGNO' ]-value = lt_head[ 1 ]-bookingno.
*          DATA(lv_sh) = VALUE #( lt_head[ 1 ]-Id OPTIONAL ).
          TRY.
              DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
            CATCH cx_fp_fdp_error INTO DATA(lo_exception).
          ENDTRY.
          DATA(ls_template) = lo_store->get_template_by_name(
            iv_get_binary    = abap_true
            iv_form_name     = 'SHIPINST'
            iv_template_name = 'SHIPINST'
          ).
*          cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml
*                                                iv_xdp_layout   = ls_template-xdp_template
*                                                iv_locale       = 'en_US'
*                                                is_options      = VALUE #(
*                                                            trace_level = 4 )
*                                      IMPORTING ev_pdf          = DATA(lv_pdf01)
*                                                ev_trace_string = DATA(lv_trace01)
*                                                 ).

          DATA: lv_text   TYPE char120,
                lv_printq TYPE char32.

          SELECT SINGLE * FROM zdt_print_queue WHERE cbuser = @sy-uname INTO @DATA(ls_printq).
          IF sy-subrc = 0.
            lv_printq = ls_printq-printque.
          ELSE.
            lv_printq = 'ZDEFAULT'.
          ENDIF.

          cl_fp_ads_util=>render_4_pq(
            EXPORTING
              iv_locale       = 'en_US'
              iv_pq_name      = lv_printq "'SHIPPING_INSTRUCT'
              iv_xml_data     = lv_xml
              iv_xdp_layout   = ls_template-xdp_template
              is_options      = VALUE #(
                trace_level = 4 "Use 0 in production environment
          )
            IMPORTING
              ev_trace_string = DATA(lv_trace)
              ev_pdl          = DATA(lv_pdf)
          ).

          lv_text = |SHIPPING INSTRUCTION PRINT | && lt_head[ 1 ]-bookingno.
          cl_print_queue_utils=>create_queue_item_by_data(
            iv_qname            = lv_printq "'SHIPPING_INSTRUCT'
            iv_print_data       = lv_pdf
            iv_name_of_main_doc = lv_text
            iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
          ).

        CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
      ENDTRY.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
