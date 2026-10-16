CLASS zcl_salestext DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'Sales Paint'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'Sales Paint Info'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_SALES_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_SALES_ALOGS_01'.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.

    METHODS constructor.
  PRIVATE SECTION.
    METHODS add_text_to_app_log_or_console
      IMPORTING i_text TYPE cl_bali_free_text_setter=>ty_text
      RAISING   cx_bali_runtime.

    DATA out             TYPE REF TO if_oo_adt_classrun_out.
    DATA application_log TYPE REF TO if_bali_log.
ENDCLASS.



CLASS ZCL_SALESTEXT IMPLEMENTATION.


  METHOD add_text_to_app_log_or_console.
    IF sy-batch = abap_true.
      FINAL(application_log_free_text) = cl_bali_free_text_setter=>create(
        severity = if_bali_constants=>c_severity_status
        text     = i_text ).
      application_log_free_text->set_detail_level( detail_level = '1' ).
      application_log->add_item( item = application_log_free_text ).
      cl_bali_log_db=>get_instance( )->save_log( log = application_log ).
    ELSE.
      out->write( |sy-batch = abap_false | ).
      out->write( i_text ).
    ENDIF.
  ENDMETHOD.


  METHOD constructor.

    TRY.
        application_log = cl_bali_log=>create_with_header(
                               header = cl_bali_header_setter=>create( object = 'ZAPP_SALES_01_LOG'
                                                                       subobject = 'ZAPP_SALES_01_SUB'
                                                                       external_id = 'Material Paint Desc.' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.

  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

  " Sales Order Paint Info "

    DATA: BEGIN OF ls_log,
            product   TYPE char40,
            language  TYPE char2,
            long_text TYPE string,
          END OF ls_log.

    DATA: lv_raw TYPE c VALUE 'ZRAW' LENGTH 4,
          lv_fgp TYPE c VALUE 'ZFGP' LENGTH 4,
          lv_com TYPE c VALUE 'ZCOM' LENGTH 4.
    DATA: ls_matdesc TYPE zdt_matdesc.

    DATA: l_a TYPE string,
          l_b TYPE string,
          l_c TYPE string,
          l_d TYPE string.

    DATA: lv_date_l TYPE datn,
          lv_date_h TYPE datn,
          lv_time_l TYPE timn,
          lv_time_h TYPE timn.
    DATA: lv_timestamp_l TYPE timestamp.


    CLEAR: lv_timestamp_l,lv_date_h,lv_date_l,lv_time_h,lv_time_l.

    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                INTO TIME STAMP DATA(lv_timestamp) TIME ZONE '' ."cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
    ENDTRY.

    CONVERT TIME STAMP lv_timestamp TIME ZONE '' INTO DATE lv_date_h TIME lv_time_h.

    IF lv_date_h IS NOT INITIAL .

      lv_timestamp_l = lv_timestamp - 1000000 .

    ENDIF.

    CHECK lv_timestamp_l IS NOT INITIAL AND
          lv_timestamp IS NOT INITIAL .

    SELECT a~salesorder , a~salesorderitem
    FROM i_salesorderitem AS a
    INNER JOIN i_salesorder  AS b ON a~salesorder = b~salesorder AND
                                     b~lastchangedatetime BETWEEN @lv_timestamp_l AND @lv_timestamp
    INTO TABLE @DATA(lt_data).

    IF sy-subrc IS INITIAL.

      LOOP AT lt_data INTO DATA(ls_data).
        DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).

        lo_factory->query_ca( EXPORTING is_query           = VALUE #(
                                  cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'YY1_COMM_SALESTEXT' ) ) ) " Custom Communication Scenario
                              IMPORTING et_com_arrangement = DATA(lt_comm_arrang) ).

        DATA(lo_comm_arrang) = lt_comm_arrang[ 1 ].

        TRY.
            DATA(lo_destination1) = cl_http_destination_provider=>create_by_comm_arrangement(
                                        comm_scenario  = CONV #( 'YY1_COMM_SALESTEXT' ) " Use Custom Communicaiton Scenario, Not standard!
                                        comm_system_id = lo_comm_arrang->get_comm_system_id( )
                                        service_id     = CONV #( 'YY1_OS_SALESREADTEXT_REST' ) ). " Outbound Service ID
          CATCH cx_http_dest_provider_error INTO DATA(lo_error).
            " TODO: variable is assigned but never used (ABAP cleaner)
            DATA(lv_message) = lo_error->get_longtext( ).
        ENDTRY.

        TRY.
            DATA(eo_client1) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination1 ).
          CATCH cx_web_http_client_error.
        ENDTRY.

        DATA(eo_request1) = eo_client1->get_http_request( ).
        eo_request1->set_content_type( content_type = |application/json| ).
        eo_request1->set_header_field( i_name = 'ACCEPT'
                                       i_value = |application/json| ).


* DATA(lv_path) = |/SalesOrderItem/{ ls_data-salesorder }/{ ls_data-salesorderitem }/Language= 'EN'/LongTextId= '0001'/_Item|.
        DATA(lv_path) = |/SalesOrderItem/{ ls_data-salesorder }/{ ls_data-salesorderitem }/_ItemText|.
*        DATA(lv_path) = |/A_ProductSalesText(Product='{ ls_data-product }',ProductSalesOrg='{ ls_data-salesorganization }',ProductDistributionChnl='{ ls_data-distributionchannel }',Language='EN')|.

        "|/PurchaseReqnItem/{ ls_prdata-doc_num }/{ ls_prdata-doc_num_item }/_PurchaseReqnItemText|.
        eo_request1->set_uri_path( i_uri_path = lv_path ).

        TRY.
            DATA(lo_response) = eo_client1->execute( i_method = if_web_http_client=>get ).
          CATCH cx_web_http_client_error.
        ENDTRY.

        " TODO: variable is assigned but never used (ABAP cleaner)
        TRY.
            DATA(lv_resp_satus) = lo_response->get_status( ).
            DATA(lv_resp_text) = lo_response->get_text( ).
          CATCH cx_root INTO FINAL(job_scheduling_exception). " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
*        out->write( |Exception has occured: { job_scheduling_exception->get_text(  ) }| ).
        ENDTRY.
        SPLIT lv_resp_text AT '"LongText":"' INTO l_a  l_b.
        SPLIT l_b AT '"' INTO l_c  l_d.
        REPLACE all OCCURRENCES OF '\n' IN l_c WITH ' '.
        IF l_c IS NOT INITIAL.
          ls_matdesc = VALUE #( salesorder = ls_data-salesorder salesorderitem = ls_data-salesorderitem longtext = l_c ).
          IF ls_matdesc IS NOT INITIAL.
            COMMIT ENTITIES BEGIN.
            MODIFY zdt_matdesc FROM  @ls_matdesc.
            COMMIT WORK AND WAIT.
            COMMIT ENTITIES END.
          ENDIF.
        ENDIF.
        CLEAR: ls_matdesc, l_a, l_b, l_c, l_d, lo_comm_arrang, lo_destination1, lo_error, lo_factory,
               lo_factory, lo_response, lv_message, lv_path, lt_comm_arrang, lv_resp_text, eo_client1, eo_request1, ls_log.
      ENDLOOP.

    ENDIF.

    " Material Long Text & Sales Text "

    DATA: ls_zmm_materialtext TYPE zmm_materialtext,
          l_a_1                 TYPE string,
          l_b_1                 TYPE string,
          l_c_1                 TYPE string,
          l_d_1                 TYPE string.

    SELECT product FROM i_product
      INTO TABLE @DATA(lt_product).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    " TODO: variable is assigned but never used (ABAP cleaner)
    LOOP AT lt_product INTO DATA(ls_product_1).

      DATA(lo_factory_1) = cl_com_arrangement_factory=>create_instance( ).

      lo_factory_1->query_ca( EXPORTING is_query           = VALUE #(
                                cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'YY1_COMM_MATERIALTEXT' ) ) ) " Custom Communication Scenario
                            IMPORTING et_com_arrangement = DATA(lt_comm_arrang_1) ).

      DATA(lo_comm_arrang_1) = lt_comm_arrang[ 1 ].

      TRY.
          DATA(lo_destination1_1) = cl_http_destination_provider=>create_by_comm_arrangement(
                                      comm_scenario  = CONV #( 'YY1_COMM_MATERIALTEXT' ) " Use Custom Communicaiton Scenario, Not standard!
                                      comm_system_id = lo_comm_arrang_1->get_comm_system_id( )
                                      service_id     = CONV #( 'YY1_COMM_MATERIALTEXT_REST' ) ). " Outbound Service ID
        CATCH cx_http_dest_provider_error INTO DATA(lo_error_1).
          " TODO: variable is assigned but never used (ABAP cleaner)
          DATA(lv_message_1) = lo_error_1->get_longtext( ).
      ENDTRY.

      TRY.
          DATA(eo_client1_1) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination1_1 ).
        CATCH cx_web_http_client_error.
      ENDTRY.

      DATA(eo_request1_1) = eo_client1_1->get_http_request( ).
      eo_request1_1->set_content_type( content_type = |application/json| ).
      eo_request1_1->set_header_field( i_name  = 'ACCEPT'
                                     i_value = |application/json| ).

      DATA(lv_path_1) = |/A_ProductSalesText?$filter=Language eq 'EN' and Product eq '| && ls_product_1-product && |'|.
      eo_request1->set_uri_path( i_uri_path = lv_path_1 ).

      TRY.
          DATA(lo_response_1) = eo_client1_1->execute( i_method = if_web_http_client=>get ).
        CATCH cx_web_http_client_error.
      ENDTRY.

      TRY.
          DATA(ls_resp_satus_1) = lo_response_1->get_status( ).
          IF ls_resp_satus_1-code = 200.
            " TODO: variable is assigned but never used (ABAP cleaner)
            DATA(lv_resp_text_1) = lo_response_1->get_text( ).
            SPLIT lv_resp_text_1 AT '"LongText":"' INTO l_a_1  l_b_1.
            SPLIT l_b_1 AT '"' INTO l_c_1  l_d_1.
            REPLACE ALL OCCURRENCES OF '\n' IN l_c_1 WITH ' '.
            IF l_c_1 IS NOT INITIAL.
              ls_zmm_materialtext-product = ls_product_1-product.
              ls_zmm_materialtext-salestext = l_c_1.
              IF ls_zmm_materialtext IS NOT INITIAL.
                COMMIT ENTITIES BEGIN.
                MODIFY zmm_materialtext FROM  @ls_zmm_materialtext.
                COMMIT WORK AND WAIT.
                COMMIT ENTITIES END.
              ENDIF.
            ENDIF.
          ENDIF.
          CLEAR: lv_resp_text_1,
                 ls_resp_satus_1,
                 lo_response_1,
                 eo_request1_1,
                 lv_path_1,
                 eo_client1_1,
                 lv_message_1,
                 lo_destination1_1,
                 lo_comm_arrang_1,
                 lo_factory_1,
                 ls_zmm_materialtext,
                 l_a_1, l_b_1, l_c_1, l_d_1.

        CATCH cx_root INTO DATA(job_scheduling_exception_1). " TODO: variable is assigned but never used (ABAP cleaner)
      ENDTRY.

      lo_factory_1 = cl_com_arrangement_factory=>create_instance( ).

      lo_factory_1->query_ca( EXPORTING is_query           = VALUE #(
                                cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'YY1_COMM_MATERIALTEXT' ) ) ) " Custom Communication Scenario
                            IMPORTING et_com_arrangement = lt_comm_arrang_1 ).

      lo_comm_arrang_1 = lt_comm_arrang[ 1 ].

      TRY.
          lo_destination1_1 = cl_http_destination_provider=>create_by_comm_arrangement(
                                comm_scenario  = CONV #( 'YY1_COMM_MATERIALTEXT' ) " Use Custom Communicaiton Scenario, Not standard!
                                comm_system_id = lo_comm_arrang_1->get_comm_system_id( )
                                service_id     = CONV #( 'YY1_COMM_MATERIALTEXT_REST' ) ). " Outbound Service ID
        CATCH cx_http_dest_provider_error INTO lo_error_1.
          lv_message_1 = lo_error_1->get_longtext( ).
      ENDTRY.

      TRY.
          eo_client1_1 = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination1_1 ).
        CATCH cx_web_http_client_error.
      ENDTRY.

      eo_request1_1 = eo_client1_1->get_http_request( ).
      eo_request1_1->set_content_type( content_type = |application/json| ).
      eo_request1_1->set_header_field( i_name  = 'ACCEPT'
                                     i_value = |application/json| ).

      lv_path_1 = |/A_ProductBasicText?$filter=Language eq 'EN' and Product eq '| && ls_product_1-product && |'|.
      eo_request1_1->set_uri_path( i_uri_path = lv_path_1 ).

      TRY.
          lo_response_1 = eo_client1_1->execute( i_method = if_web_http_client=>get ).
        CATCH cx_web_http_client_error.
      ENDTRY.

      TRY.
          ls_resp_satus_1 = lo_response_1->get_status( ).
          IF ls_resp_satus_1-code = 200.
            lv_resp_text_1 = lo_response_1->get_text( ).
            SPLIT lv_resp_text_1 AT '"LongText":"' INTO l_a_1  l_b_1.
            SPLIT l_b_1 AT '"' INTO l_c_1  l_d_1.
            REPLACE ALL OCCURRENCES OF '\n' IN l_c_1 WITH ' '.
            IF l_c_1 IS NOT INITIAL.
              ls_zmm_materialtext-product = ls_product_1-product.
              ls_zmm_materialtext-basictext = l_c_1.
              IF ls_zmm_materialtext IS NOT INITIAL.
                COMMIT ENTITIES BEGIN.
                MODIFY zmm_materialtext FROM  @ls_zmm_materialtext.
                COMMIT WORK AND WAIT.
                COMMIT ENTITIES END.
              ENDIF.
            ENDIF.
          ENDIF.

          CLEAR: lv_resp_text_1,
                 ls_resp_satus_1,
                 lo_response_1,
                 eo_request1_1,
                 lv_path_1,
                 eo_client1_1,
                 lv_message_1,
                 lo_destination1_1,
                 lo_comm_arrang_1,
                 lo_factory_1,
                 ls_zmm_materialtext,
                 l_a_1, l_b_1, l_c_1, l_d_1.

        CATCH cx_root INTO job_scheduling_exception_1.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        "
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
        "
      CATCH cx_root INTO FINAL(job_scheduling_exception). " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
*        out->write( |Exception has occured: { job_scheduling_exception->get_text(  ) }| ).
    ENDTRY.
*
  ENDMETHOD.
ENDCLASS.
