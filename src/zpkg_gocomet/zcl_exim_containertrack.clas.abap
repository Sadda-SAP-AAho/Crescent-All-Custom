CLASS zcl_exim_containertrack DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'INVENT'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'Container Track data'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_CONTRCK_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_COTRCK_ALOGS_01'.

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



CLASS ZCL_EXIM_CONTAINERTRACK IMPLEMENTATION.


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
                               header = cl_bali_header_setter=>create( object = 'ZAPP_CONTTRCK_01_LOG'
                                                                       subobject = 'ZAPP_CONTTRCK_01_SUB'
                                                                       external_id = 'VENDOR IP' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.

  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.


  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    TYPES : BEGIN OF ty_upd,
              containernumber                TYPE string,
              departureoriginalplanndatetime TYPE string,
              departure_actual_datetime      TYPE string,
              arrivaloriginalplanneddatetime TYPE string,
              arrival_actual_datetime        TYPE string,
              empty_actual_datetime          TYPE string,
            END OF ty_upd.
**********************************************************************
    DATA: lv_json        TYPE string,
          lv_headervalue TYPE string,
          lv_del         TYPE string,
          ls_upd         TYPE ty_upd,
          lv_date        TYPE char10.

    SELECT *
    FROM zdt_deldash_hdr
    WHERE empretdt IS INITIAL AND
          canind <> 'X' AND contno IS NOT INITIAL
    INTO TABLE @DATA(lt_deltrack).
    IF sy-subrc = 0.
      SORT lt_deltrack BY contno.
    ENDIF.

    LOOP AT lt_deltrack INTO DATA(ls_deltrack).
      lv_json = /ui2/cl_json=>serialize( EXPORTING data = ls_deltrack pretty_name = 'X' ).
      lv_headervalue = ls_deltrack-contno.
      lv_del = ls_deltrack-delivery.
      TRY.
          FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                      comm_scenario = 'ZCS_GOCOMET_GET'
                                      service_id    = 'ZOS_GOCOMET_GET_REST' ).
          FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          FINAL(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |application/json| ).
          TRY.
              lo_request->set_header_field(
                EXPORTING
                  i_name  = 'TrackID'
                  i_value = lv_headervalue
              ).
            CATCH cx_web_message_error.
          ENDTRY.
          TRY.
              lo_request->set_header_field(
                EXPORTING
                  i_name  = 'Delivery'
                  i_value = lv_del
              ).
            CATCH cx_web_message_error.
          ENDTRY.
          lo_request->set_text( lv_json ).
          FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          lo_http_client->close( ).
          /ui2/cl_json=>deserialize( EXPORTING json = ls_result CHANGING data = ls_upd  ).
          IF ls_upd-containernumber IS NOT INITIAL.
            IF ls_upd-arrivaloriginalplanneddatetime IS NOT INITIAL.
              CLEAR : lv_date.
              lv_date = ls_upd-arrivaloriginalplanneddatetime.
              ls_deltrack-etadt = lv_date+6(4) && lv_date+3(2) && lv_date+0(2).
            ENDIF.
            IF ls_upd-arrival_actual_datetime IS NOT INITIAL.
              CLEAR : lv_date.
              lv_date = ls_upd-arrival_actual_datetime. "Changed by SP on 3.7.25
              "ls_deltrack-etadt = lv_date+6(4) && lv_date+3(2) && lv_date+0(2). "Commented by SP on 3.7.25
              ls_deltrack-atadt = lv_date+6(4) && lv_date+3(2) && lv_date+0(2). "Added by SP on 3.7.25
            ENDIF.
            IF ls_upd-departureoriginalplanndatetime IS NOT INITIAL.
              CLEAR : lv_date.
              lv_date = ls_upd-departureoriginalplanndatetime.
              ls_deltrack-vessaildt = lv_date+6(4) && lv_date+3(2) && lv_date+0(2).
            ENDIF.
            IF ls_upd-departure_actual_datetime  IS NOT INITIAL.
              CLEAR : lv_date.
              lv_date = ls_upd-departure_actual_datetime.
              ls_deltrack-ordepdt = lv_date+6(4) && lv_date+3(2) && lv_date+0(2).
            ENDIF.
            IF ls_upd-empty_actual_datetime IS NOT INITIAL.
              CLEAR : lv_date.
              lv_date = ls_upd-empty_actual_datetime.
              ls_deltrack-empretdt = lv_date+6(4) && lv_date+3(2) && lv_date+0(2).
            ENDIF.
            MODIFY zdt_deldash_hdr FROM @ls_deltrack.
          ENDIF.
          CLEAR lv_json.
        CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error).
        CATCH cx_web_http_client_error INTO FINAL(web_http_client_error).
      ENDTRY.
      CLEAR: lv_headervalue, ls_deltrack.
    ENDLOOP.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    TYPES : BEGIN OF ty_upd,
              containernumber                TYPE string,
              departureoriginalplanndatetime TYPE string,
              departure_actual_datetime      TYPE string,
              arrivaloriginalplanneddatetime TYPE string,
              arrival_actual_datetime        TYPE string,
              empty_actual_datetime          TYPE string,
            END OF ty_upd.

    DATA: lv_json        TYPE string,
          lv_headervalue TYPE string,
          lv_del         TYPE string,
          ls_upd         TYPE ty_upd,
          lv_date        TYPE char10.

    SELECT *
    FROM zdt_deldash_hdr
    WHERE empretdt IS INITIAL AND
          canind <> 'X' AND contno IS NOT INITIAL
    INTO TABLE @DATA(lt_deltrack).
    IF sy-subrc = 0.
      SORT lt_deltrack BY contno.
    ENDIF.

    LOOP AT lt_deltrack INTO DATA(ls_deltrack).
      lv_json = /ui2/cl_json=>serialize( EXPORTING data = ls_deltrack pretty_name = 'X' ).
      lv_headervalue = ls_deltrack-contno.
      lv_del = ls_deltrack-delivery.
      TRY.
          FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                      comm_scenario = 'ZCS_GOCOMET_GET'
                                      service_id    = 'ZOS_GOCOMET_GET_REST' ).
          FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          FINAL(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |application/json| ).
          TRY.
              lo_request->set_header_field(
                EXPORTING
                  i_name  = 'TrackID'
                  i_value = lv_headervalue
              ).
            CATCH cx_web_message_error.
          ENDTRY.
          TRY.
              lo_request->set_header_field(
                EXPORTING
                  i_name  = 'Delivery'
                  i_value = lv_del
              ).
            CATCH cx_web_message_error.
          ENDTRY.
          lo_request->set_text( lv_json ).
          FINAL(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          lo_http_client->close( ).
          /ui2/cl_json=>deserialize( EXPORTING json = ls_result CHANGING data = ls_upd  ).
          IF ls_upd-containernumber IS NOT INITIAL.
            IF ls_upd-arrivaloriginalplanneddatetime IS NOT INITIAL.
              CLEAR : lv_date.
              lv_date = ls_upd-arrivaloriginalplanneddatetime.
              ls_deltrack-etadt = lv_date+6(4) && lv_date+3(2) && lv_date+0(2).
            ENDIF.
            IF ls_upd-arrival_actual_datetime IS NOT INITIAL.
              CLEAR : lv_date.
              lv_date = ls_upd-arrival_actual_datetime.
              ls_deltrack-atadt = lv_date+6(4) && lv_date+3(2) && lv_date+0(2).
            ENDIF.
            IF ls_upd-departureoriginalplanndatetime IS NOT INITIAL.
              CLEAR : lv_date.
              lv_date = ls_upd-departureoriginalplanndatetime.
              ls_deltrack-vessaildt = lv_date+6(4) && lv_date+3(2) && lv_date+0(2).
            ENDIF.
            IF ls_upd-departure_actual_datetime  IS NOT INITIAL.
              CLEAR : lv_date.
              lv_date = ls_upd-departure_actual_datetime.
              ls_deltrack-ordepdt = lv_date+6(4) && lv_date+3(2) && lv_date+0(2).
            ENDIF.
            IF ls_upd-empty_actual_datetime IS NOT INITIAL.
              CLEAR : lv_date.
              lv_date = ls_upd-empty_actual_datetime.
              ls_deltrack-empretdt = lv_date+6(4) && lv_date+3(2) && lv_date+0(2).
            ENDIF.
            MODIFY zdt_deldash_hdr FROM @ls_deltrack.
          ENDIF.
          CLEAR : lv_json, ls_upd.
        CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error).
        CATCH cx_web_http_client_error INTO FINAL(web_http_client_error).
      ENDTRY.
      CLEAR: lv_headervalue, ls_deltrack.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
