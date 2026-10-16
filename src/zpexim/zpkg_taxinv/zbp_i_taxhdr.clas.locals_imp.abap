CLASS lhc_zi_taxhdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_taxhdr RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_taxhdr RESULT result.

    METHODS printdom FOR MODIFY
      IMPORTING keys FOR ACTION zi_taxhdr~printdom RESULT result.

    METHODS printigst FOR MODIFY
      IMPORTING keys FOR ACTION zi_taxhdr~printigst RESULT result.

    METHODS printlut FOR MODIFY
      IMPORTING keys FOR ACTION zi_taxhdr~printlut RESULT result.

    METHODS printpro FOR MODIFY
      IMPORTING keys FOR ACTION zi_taxhdr~printpro RESULT result.

    METHODS printpat FOR MODIFY
      IMPORTING keys FOR ACTION zi_taxhdr~printpat RESULT result.

    METHODS printsam FOR MODIFY
      IMPORTING keys FOR ACTION zi_taxhdr~printsam RESULT result.

    METHODS headerdetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_taxhdr~headerdetails.

ENDCLASS.

CLASS lhc_zi_taxhdr IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD printdom.
    READ ENTITIES OF zi_taxhdr IN LOCAL MODE
                ENTITY zi_taxhdr
                ALL FIELDS
                WITH CORRESPONDING #( keys )
                RESULT DATA(header)
                " TODO: variable is assigned but never used (ABAP cleaner)
                FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

        <fs_print>-taxdomprint = 'X'.
        <fs_print>-flag = 'A'.

        MODIFY ENTITIES OF zi_taxhdr IN LOCAL MODE
                ENTITY zi_taxhdr
                UPDATE
                FIELDS ( taxdomprint flag )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 taxdomprint =  <fs_print>-taxdomprint
                                 flag = <fs_print>-flag
                                  %control-flag   = if_abap_behv=>mk-on
                                  %control-taxdomprint   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_taxhdr IN LOCAL MODE
         ENTITY  zi_taxhdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD printigst.
    READ ENTITIES OF zi_taxhdr IN LOCAL MODE
                 ENTITY zi_taxhdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT DATA(header)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

        <fs_print>-taxigstprint = 'X'.
        <fs_print>-flag = 'B'.

        MODIFY ENTITIES OF zi_taxhdr IN LOCAL MODE
                ENTITY zi_taxhdr
                UPDATE
                FIELDS ( taxigstprint flag )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 taxigstprint =  <fs_print>-taxigstprint
                                 flag = <fs_print>-flag
                                  %control-flag   = if_abap_behv=>mk-on
                                  %control-taxigstprint   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_taxhdr IN LOCAL MODE
         ENTITY  zi_taxhdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD printlut.
    READ ENTITIES OF zi_taxhdr IN LOCAL MODE
                 ENTITY zi_taxhdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT DATA(header)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

        <fs_print>-taxlutprint = 'X'.
        <fs_print>-flag = 'C'.

        MODIFY ENTITIES OF zi_taxhdr IN LOCAL MODE
                ENTITY zi_taxhdr
                UPDATE
                FIELDS ( taxlutprint flag )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 taxlutprint =  <fs_print>-taxlutprint
                                 flag = <fs_print>-flag
                                  %control-flag   = if_abap_behv=>mk-on
                                  %control-taxlutprint   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_taxhdr IN LOCAL MODE
         ENTITY  zi_taxhdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD printpro.
    READ ENTITIES OF zi_taxhdr IN LOCAL MODE
                 ENTITY zi_taxhdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT DATA(header)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

        <fs_print>-proinvprint = 'X'.
        <fs_print>-flag = 'D'.

        MODIFY ENTITIES OF zi_taxhdr IN LOCAL MODE
                ENTITY zi_taxhdr
                UPDATE
                FIELDS ( proinvprint flag )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 proinvprint =  <fs_print>-proinvprint
                                 flag = <fs_print>-flag
                                  %control-flag   = if_abap_behv=>mk-on
                                  %control-proinvprint   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_taxhdr IN LOCAL MODE
         ENTITY  zi_taxhdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD printpat.
    READ ENTITIES OF zi_taxhdr IN LOCAL MODE
                 ENTITY zi_taxhdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT DATA(header)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

        <fs_print>-patinvprint = 'X'.
        <fs_print>-flag = 'E'.

        MODIFY ENTITIES OF zi_taxhdr IN LOCAL MODE
                ENTITY zi_taxhdr
                UPDATE
                FIELDS ( patinvprint flag )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 patinvprint =  <fs_print>-patinvprint
                                 flag = <fs_print>-flag
                                  %control-flag   = if_abap_behv=>mk-on
                                  %control-patinvprint   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_taxhdr IN LOCAL MODE
         ENTITY  zi_taxhdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD printsam.
    READ ENTITIES OF zi_taxhdr IN LOCAL MODE
                 ENTITY zi_taxhdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT DATA(header)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(header_failed).


    LOOP AT header ASSIGNING FIELD-SYMBOL(<fs_print>).
      IF <fs_print> IS ASSIGNED.

        <fs_print>-samcusprint = 'X'.
        <fs_print>-flag = 'F'.

        MODIFY ENTITIES OF zi_taxhdr IN LOCAL MODE
                ENTITY zi_taxhdr
                UPDATE
                FIELDS ( samcusprint flag )
                WITH VALUE #( ( %tky          = <fs_print>-%tky
                                 samcusprint =  <fs_print>-samcusprint
                                 flag = <fs_print>-flag
                                  %control-flag   = if_abap_behv=>mk-on
                                  %control-samcusprint   = if_abap_behv=>mk-on
                                ) ).

      ENDIF.
    ENDLOOP.
    " Fill the response table
    READ ENTITIES OF zi_taxhdr IN LOCAL MODE
         ENTITY  zi_taxhdr
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT FINAL(header_1).

    result = VALUE #( FOR ls_header IN header_1
                      ( %tky   = ls_header-%tky
                        %param = ls_header ) ).
  ENDMETHOD.

  METHOD headerdetails.
    READ ENTITIES OF zi_taxhdr IN LOCAL MODE
                 ENTITY zi_taxhdr
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT DATA(header)
                 " TODO: variable is assigned but never used (ABAP cleaner)
                 FAILED FINAL(header_failed).

    DATA(gfs_header) = VALUE #( header[ 1 ]  OPTIONAL ).


    SELECT SINGLE * FROM i_billingdocument
    WHERE billingdocument = @gfs_header-billingdoc
    INTO @DATA(ls_doc).

    gfs_header-invdate = ls_doc-billingdocumentdate.
    gfs_header-invtype = ls_doc-billingdocumenttype.
    gfs_header-invcreatedby = ls_doc-createdbyuser.

    SELECT * FROM i_billingdocumentitem
    WHERE billingdocument = @gfs_header-billingdoc
    INTO Table @DATA(lt_doci).

    READ TABLE lt_doci into DATA(ls_doci) INDEX 1.

    gfs_header-Delivery = ls_doci-ReferenceSDDocument.

    clear : ls_doci.

    MODIFY ENTITIES OF zi_taxhdr IN LOCAL MODE
           ENTITY zi_taxhdr
           UPDATE
               FIELDS ( invdate invtype invcreatedby Delivery )
               WITH VALUE #( ( %tky   = gfs_header-%tky
                               invdate = gfs_header-invdate
                               invtype = gfs_header-invtype
                               invcreatedby = gfs_header-invcreatedby
                               Delivery = gfs_header-Delivery
                               %control-invdate  = if_abap_behv=>mk-on
                               %control-invtype  = if_abap_behv=>mk-on
                               %control-invcreatedby  = if_abap_behv=>mk-on
                               %control-Delivery  = if_abap_behv=>mk-on
                              ) ).


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_taxhdr DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_taxhdr IMPLEMENTATION.

  METHOD save_modified.

    IF update-zi_taxhdr IS NOT INITIAL.

      DATA: lv_printq TYPE char32.

      SELECT SINGLE * FROM zdt_print_queue WHERE cbuser = @sy-uname INTO @DATA(ls_printq).
      IF sy-subrc = 0.
        lv_printq = ls_printq-printque.
      ELSE.
        lv_printq = 'ZDEFAULT'.
      ENDIF.

      DATA(lt_head) = update-zi_taxhdr.
      READ TABLE lt_head INDEX 1 INTO DATA(wa_head).

      IF wa_head-flag = 'A'.


        TRY.
            "Initialize Template Store Client
            DATA(lo_store) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSD_TAXINV' ) .

            TRY.
                lo_store->get_schema_by_name( iv_form_name = 'TAXINVDOM' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error).
"" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
 "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error->mv_http_status_code = 404 OR lo_tmpl_error->mv_http_status_code = 403 .
*                  lo_store->set_schema(
*                    iv_form_name = 'TAXINVDOM'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
"" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys)     = lo_fdp_util->get_keys( ).
*        lt_keys[ name = 'ID' ]-value = lt_head[ 1 ]-id.
            lt_keys[ name = 'BILLINGDOCUMENT' ]-value = lt_head[ 1 ]-billingdoc.
*        lt_keys[ name = 'REVISION' ]-value = lt_head[ 1 ]-REVISION.
*          DATA(lv_sh) = VALUE #( lt_head[ 1 ]-Id OPTIONAL ).
            TRY.
                DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception).
            ENDTRY.
            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'TAXINVDOM'
              iv_template_name = 'TAXINVDOM'
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
            lv_text = |TAX INVOICE DOMESTIC | && lt_head[ 1 ]-billingdoc.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq "'TAXINVDOM'
              iv_print_data       = lv_pdf
              iv_name_of_main_doc = lv_text
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        ENDTRY.


      ENDIF.
      IF wa_head-flag = 'B'.


        TRY.
            "Initialize Template Store Client
            DATA(lo_store1) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util1) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSD_TAXINV' ) .


            TRY.
                lo_store1->get_schema_by_name( iv_form_name = 'TAXINVIGST' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error1).
"" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
 "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error1->mv_http_status_code = 404 OR lo_tmpl_error1->mv_http_status_code = 403 .
*                  lo_store1->set_schema(
*                    iv_form_name = 'TAXINVIGST'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util1->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
"" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys1)     = lo_fdp_util1->get_keys( ).
            lt_keys1[ name = 'BILLINGDOCUMENT' ]-value = lt_head[ 1 ]-billingdoc.
*            lt_keys1[ name = 'REVISION' ]-value = lt_head[ 1 ]-REVISION.
            TRY.
                DATA(lv_xml1) = lo_fdp_util1->read_to_xml( lt_keys1 ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception1).
            ENDTRY.
            DATA(ls_template1) = lo_store1->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'TAXINVIGST'
              iv_template_name = 'TAXINVIGST'
            ).
*          cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml1
*                                                iv_xdp_layout   = ls_template1-xdp_template
*                                                iv_locale       = 'en_US'
*                                                is_options      = VALUE #(
*                                                            trace_level = 4 )
*                                      IMPORTING ev_pdf          = DATA(lv_pdf02)
*                                                ev_trace_string = DATA(lv_trace02)
*                                                 ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      = lv_printq "'TAXINVIGST'
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
            lv_text1 = |TAX INVOICE IGST| && lt_head[ 1 ]-billingdoc.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq "'TAXINVIGST'
              iv_print_data       = lv_pdf1
              iv_name_of_main_doc = lv_text1
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        ENDTRY.


      ENDIF.
      IF wa_head-flag = 'C'.

        TRY.
            "Initialize Template Store Client
            DATA(lo_store2) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util2) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSD_TAXINV' ) .


            TRY.
                lo_store2->get_schema_by_name( iv_form_name = 'TAXINVLUT' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error2).
"" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
 "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error2->mv_http_status_code = 404 OR lo_tmpl_error2->mv_http_status_code = 403 .
*                  lo_store2->set_schema(
*                    iv_form_name = 'TAXINVLUT'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util2->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
"" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys2)     = lo_fdp_util2->get_keys( ).
            lt_keys2[ name = 'BILLINGDOCUMENT' ]-value = lt_head[ 1 ]-billingdoc.
*            lt_keys1[ name = 'REVISION' ]-value = lt_head[ 1 ]-REVISION.
            TRY.
                DATA(lv_xml2) = lo_fdp_util2->read_to_xml( lt_keys2 ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception2).
            ENDTRY.
            DATA(ls_template2) = lo_store2->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'TAXINVLUT'
              iv_template_name = 'TAXINVLUT'
            ).
*          cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml2
*                                                iv_xdp_layout   = ls_template2-xdp_template
*                                                iv_locale       = 'en_US'
*                                                is_options      = VALUE #(
*                                                            trace_level = 4 )
*                                      IMPORTING ev_pdf          = DATA(lv_pdf03)
*                                                ev_trace_string = DATA(lv_trace03)
*                                                 ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      = lv_printq "'TAXINVLUT'
                iv_xml_data     = lv_xml2
                iv_xdp_layout   = ls_template2-xdp_template
                is_options      = VALUE #(
                  trace_level = 4 "Use 0 in production environment
            )
              IMPORTING
                ev_trace_string = DATA(lv_trace2)
                ev_pdl          = DATA(lv_pdf2)
            ).

            DATA: lv_text2 TYPE char120.
            lv_text2 = |TAX INVOICE LUT| && lt_head[ 1 ]-billingdoc.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq "'TAXINVLUT'
              iv_print_data       = lv_pdf2
              iv_name_of_main_doc = lv_text2
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        ENDTRY.


      ENDIF.
      IF wa_head-flag = 'D'.

        TRY.
            "Initialize Template Store Client
            DATA(lo_store3) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util3) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSD_PROINV' ) .


            TRY.
                lo_store3->get_schema_by_name( iv_form_name = 'INDIACUSTOMSINVOICE' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error3).
"" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
 "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error3->mv_http_status_code = 404 OR lo_tmpl_error3->mv_http_status_code = 403 .
*                  lo_store3->set_schema(
*                    iv_form_name = 'INDIACUSTOMSINVOICE'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util3->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
"" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys3)     = lo_fdp_util3->get_keys( ).
            lt_keys3[ name = 'BILLINGDOCUMENT' ]-value = lt_head[ 1 ]-billingdoc.
*            lt_keys1[ name = 'REVISION' ]-value = lt_head[ 1 ]-REVISION.
            TRY.
                DATA(lv_xml3) = lo_fdp_util3->read_to_xml( lt_keys3 ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception3).
            ENDTRY.
            DATA(ls_template3) = lo_store3->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'INDIACUSTOMSINVOICE'
              iv_template_name = 'INDIACUSTOMSINVOICE'
            ).
*          cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml3
*                                                iv_xdp_layout   = ls_template3-xdp_template
*                                                iv_locale       = 'en_US'
*                                                is_options      = VALUE #(
*                                                            trace_level = 4 )
*                                      IMPORTING ev_pdf          = DATA(lv_pdf04)
*                                                ev_trace_string = DATA(lv_trace04)
*                                                 ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      = lv_printq "'INDIACUST_INV '
                iv_xml_data     = lv_xml3
                iv_xdp_layout   = ls_template3-xdp_template
                is_options      = VALUE #(
                  trace_level = 4 "Use 0 in production environment
            )
              IMPORTING
                ev_trace_string = DATA(lv_trace3)
                ev_pdl          = DATA(lv_pdf3)
            ).

            DATA: lv_text3 TYPE char120.
            data: lv_bill type char120.

            lv_bill = lt_head[ 1 ]-billingdoc.

            SELECT SINGLE DocumentReferenceId FROM zcds_proinvhed
            WHERE billingdocument = @lv_bill
            INTO @DATA(lv_proinv).
            lv_text3 = |India Customs Invoice | && lv_proinv.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq "'INDIACUST_INV '
              iv_print_data       = lv_pdf3
              iv_name_of_main_doc = lv_text3
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        ENDTRY.

      ENDIF.
      IF wa_head-flag = 'E'.

        TRY.
            "Initialize Template Store Client
            DATA(lo_store4) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util4) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSD_PATINV' ) .


            TRY.
                lo_store4->get_schema_by_name( iv_form_name = 'PATTERNINVOICE' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error4).
"" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
 "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error4->mv_http_status_code = 404 OR lo_tmpl_error4->mv_http_status_code = 403 .
*                  lo_store4->set_schema(
*                    iv_form_name = 'PATTERNINVOICE'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util4->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
"" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys4)     = lo_fdp_util4->get_keys( ).
            lt_keys4[ name = 'BILLINGDOCUMENT' ]-value = lt_head[ 1 ]-billingdoc.
*            lt_keys1[ name = 'REVISION' ]-value = lt_head[ 1 ]-REVISION.
            TRY.
                DATA(lv_xml4) = lo_fdp_util4->read_to_xml( lt_keys4 ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception4).
            ENDTRY.
            DATA(ls_template4) = lo_store4->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'PATTERNINVOICE'
              iv_template_name = 'PATTERNINVOICE'
            ).
*          cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml3
*                                                iv_xdp_layout   = ls_template3-xdp_template
*                                                iv_locale       = 'en_US'
*                                                is_options      = VALUE #(
*                                                            trace_level = 4 )
*                                      IMPORTING ev_pdf          = DATA(lv_pdf04)
*                                                ev_trace_string = DATA(lv_trace04)
*                                                 ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      = lv_printq "'INDIACUST_INV '
                iv_xml_data     = lv_xml4
                iv_xdp_layout   = ls_template4-xdp_template
                is_options      = VALUE #(
                  trace_level = 4 "Use 0 in production environment
            )
              IMPORTING
                ev_trace_string = DATA(lv_trace4)
                ev_pdl          = DATA(lv_pdf4)
            ).

            DATA: lv_text4 TYPE char120.
            lv_text4 = |Pattern Invoice | && lt_head[ 1 ]-billingdoc.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq "'INDIACUST_INV '
              iv_print_data       = lv_pdf4
              iv_name_of_main_doc = lv_text4
              iv_itemid           = cl_print_queue_utils=>create_queue_itemid( )
            ).

          CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error1 cx_fp_ads_util.
        ENDTRY.

      ENDIF.

      IF wa_head-flag = 'F'.

        TRY.
            "Initialize Template Store Client
            DATA(lo_store5) = NEW zcl_fp_tmpl_store_client1(
              iv_name                  = 'YY1_SHIPPING_NOTIFICATION'
              iv_service_instance_name = 'YY1_OS_ADOBE_REST_REST'
            ).

            DATA(lo_fdp_util5) = cl_fp_fdp_services=>get_instance( iv_service_definition =  'ZSD_SCSINV' ) .


            TRY.
                lo_store5->get_schema_by_name( iv_form_name = 'SAMPLECUSTINV' ).
              CATCH zcx_fp_tmpl_store_error1 INTO DATA(lo_tmpl_error5).
"" Commented by KJ 06.06.2025 because storage for schema was getting full on clicking print button
 "" multiple times and hence user was unable to generate print
*                IF lo_tmpl_error5->mv_http_status_code = 404 OR lo_tmpl_error5->mv_http_status_code = 403 .
*                  lo_store5->set_schema(
*                    iv_form_name = 'SAMPLECUSTINV'
*                    is_data      = VALUE #( note = '' schema_name = 'schema' xsd_schema = lo_fdp_util5->get_xsd( ) )
*                  ).
*                ELSE.
*                ENDIF.
"" End Of Comment KJ 06.06.2025
            ENDTRY.

            DATA(lt_keys5)     = lo_fdp_util5->get_keys( ).
            lt_keys5[ name = 'BILLINGDOCUMENT' ]-value = lt_head[ 1 ]-billingdoc.
*            lt_keys1[ name = 'REVISION' ]-value = lt_head[ 1 ]-REVISION.
            TRY.
                DATA(lv_xml5) = lo_fdp_util5->read_to_xml( lt_keys5 ).
              CATCH cx_fp_fdp_error INTO DATA(lo_exception5).
            ENDTRY.
            DATA(ls_template5) = lo_store5->get_template_by_name(
              iv_get_binary    = abap_true
              iv_form_name     = 'SAMPLECUSTINV'
              iv_template_name = 'SAMPLECUSTINV'
            ).
*          cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data     = lv_xml3
*                                                iv_xdp_layout   = ls_template3-xdp_template
*                                                iv_locale       = 'en_US'
*                                                is_options      = VALUE #(
*                                                            trace_level = 4 )
*                                      IMPORTING ev_pdf          = DATA(lv_pdf04)
*                                                ev_trace_string = DATA(lv_trace04)
*                                                 ).
            cl_fp_ads_util=>render_4_pq(
              EXPORTING
                iv_locale       = 'en_US'
                iv_pq_name      = lv_printq
                iv_xml_data     = lv_xml5
                iv_xdp_layout   = ls_template5-xdp_template
                is_options      = VALUE #(
                  trace_level = 4 "Use 0 in production environment
            )
              IMPORTING
                ev_trace_string = DATA(lv_trace5)
                ev_pdl          = DATA(lv_pdf5)
            ).

            DATA: lv_text5 TYPE char120.
            data: lv_bill1 type char120.

            lv_bill1 = lt_head[ 1 ]-billingdoc.

            SELECT SINGLE DocumentReferenceId FROM zcds_proinvhed
            WHERE billingdocument = @lv_bill1
            INTO @DATA(lv_proinv1).
            lv_text5 = |Sample Custom Invoice | && lv_proinv1.
            cl_print_queue_utils=>create_queue_item_by_data(
              iv_qname            = lv_printq
              iv_print_data       = lv_pdf5
              iv_name_of_main_doc = lv_text5
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
