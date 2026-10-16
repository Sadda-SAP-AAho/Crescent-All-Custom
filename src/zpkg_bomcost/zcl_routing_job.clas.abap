CLASS zcl_routing_job DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'ROUTING'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'ROuting'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DEMO_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_DEMO_ALOG_01'.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
    METHODS constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS add_text_to_app_log_or_console
      IMPORTING i_text TYPE cl_bali_free_text_setter=>ty_text
      RAISING   cx_bali_runtime.

    DATA out             TYPE REF TO if_oo_adt_classrun_out.
    DATA application_log TYPE REF TO if_bali_log.
ENDCLASS.



CLASS ZCL_ROUTING_JOB IMPLEMENTATION.


  METHOD add_text_to_app_log_or_console.
    IF sy-batch = abap_true.
      FINAL(application_log_free_text) = cl_bali_free_text_setter=>create(
        severity = if_bali_constants=>c_severity_status
        text     = i_text ).
      application_log_free_text->set_detail_level( detail_level = '1' ).
      application_log->add_item( item = application_log_free_text ).
      cl_bali_log_db=>get_instance( )->save_log( log = application_log
*                                                 assign_to_current_appl_job = abap_true
                                                 ).
    ELSE.
      out->write( |sy-batch = abap_false | ).
      out->write( i_text ).
    ENDIF.
  ENDMETHOD.


  METHOD constructor.
    TRY.
        application_log = cl_bali_log=>create_with_header(
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_ROUT_01_LOG'
                                                                      subobject   = 'ZAPP_ROUT_01_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

***  Comm arrangement in DEV - YY1_ROUTINGBOM, SAP_COM_0519

    DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).

    lo_factory->query_ca( EXPORTING is_query           = VALUE #(
                              cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'YY1_ROUTINGBOM' ) ) ) " Custom Communication Scenario
                          IMPORTING et_com_arrangement = DATA(lt_comm_arrang) ).

    DATA(lo_comm_arrang) = lt_comm_arrang[ 1 ].

    TRY.
        DATA(lo_destination1) = cl_http_destination_provider=>create_by_comm_arrangement(
                                    comm_scenario  = CONV #( 'YY1_ROUTINGBOM' ) " Use Custom Communicaiton Scenario, Not standard!
                                    comm_system_id = lo_comm_arrang->get_comm_system_id( )
                                    service_id     = CONV #( 'YY1_ROUTINGBOM_REST' ) ). " Outbound Service ID
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

    DATA(lv_path) = |/ProductionRoutingOperation(ProductionRoutingGroup='50000000',ProductionRouting='1',ProductionRoutingSequence='0',ProductionRoutingOpIntID='2',ProductionRoutingOpIntVersion='1')|.
    eo_request1->set_uri_path( i_uri_path = lv_path ).

    TRY.
        DATA(lo_response) = eo_client1->execute( i_method = if_web_http_client=>get ).
      CATCH cx_web_http_client_error.
    ENDTRY.

    " TODO: variable is assigned but never used (ABAP cleaner)
    TRY.
        DATA(lv_resp_satus) = lo_response->get_status( ).
        DATA(lv_resp_text) = lo_response->get_text( ).
      CATCH cx_root INTO FINAL(job_scheduling_exception1).
        " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
*        out->write( |Exception has occured: { job_scheduling_exception->get_text(  ) }| ).
    ENDTRY.


  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
      CATCH cx_root INTO FINAL(job_scheduling_exception).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
