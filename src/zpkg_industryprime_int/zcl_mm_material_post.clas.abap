CLASS zcl_mm_material_post DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'MATERIAL'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'Material data'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_MATERIAL_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_MATERIAL_ALOGS_01'.

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



CLASS ZCL_MM_MATERIAL_POST IMPLEMENTATION.


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
                               header = cl_bali_header_setter=>create( object = 'ZAPP_MATERIAL_01_LOG'
                                                                       subobject = 'ZAPP_MATERIAL_01_SUB'
                                                                       external_id = 'MATERIAL IP' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.

  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.


  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

**********************************************************************
*--API Structure
    TYPES: BEGIN OF lty_material,
             description             TYPE zmm_ip_material-description,
             item_code               TYPE zmm_ip_material-item_code,
             itemgroup               TYPE zmm_ip_material-itemgroup,
             primary_uom             TYPE zmm_ip_material-primary_uom,
             primary_uom_shortform   TYPE zmm_ip_material-primary_uom_shortform,
             secondary_uom           TYPE zmm_ip_material-secondary_uom,
             secondary_uom_shortform TYPE zmm_ip_material-secondary_uom_shortform,
             hsn                     TYPE zmm_ip_material-hsn,
             leadtime                TYPE zmm_ip_material-leadtime,
           END OF lty_material.

    TYPES: BEGIN OF lty_material_op,
             id                      TYPE char72,
             description             TYPE char72,
             item_code               TYPE char72,
             itemgroup               TYPE char72,
             primary_uom             TYPE char72,
             secondary_uom           TYPE char72,
             hsn                     TYPE char72,
             leadtime                TYPE char72,
             created_at              TYPE char72,
             updated_at              TYPE char72,
           END OF lty_material_op.

    DATA: lv_date_start TYPE datum,
          lv_date_end   TYPE datum,
          lv_time_end   TYPE timn,
          lv_time_begin TYPE timn,
          lv_json       TYPE string,

          lt_material   TYPE STANDARD TABLE OF lty_material,
          ls_material   TYPE lty_material,
          ls_material_op TYPE lty_material_op,
          lt_ip_mat     TYPE STANDARD TABLE OF zdt_ip_material.


*Initialization
    lv_date_start = cl_abap_context_info=>get_system_date( ).
    lv_date_end = cl_abap_context_info=>get_system_date( ).
    lv_date_start = lv_date_start - 1.

    SELECT a~item_code,a~description,a~CreationDate,a~LastChangeDate,a~itemgroup,a~primary_uom_shortform,a~primary_uom,
        a~secondary_uom,a~secondary_uom_shortform,a~hsn,a~leadtime,b~item
        FROM zmm_ip_material AS a
        LEFT OUTER JOIN zdt_ip_material AS b
        ON ( b~material = a~item_code )
        WHERE a~creationdate BETWEEN @lv_date_start AND @lv_date_end
        INTO TABLE @DATA(lt_ipmaterial).

    SELECT a~item_code,a~description,a~CreationDate,a~LastChangeDate,a~itemgroup,a~primary_uom_shortform,a~primary_uom,
        a~secondary_uom,a~secondary_uom_shortform,a~hsn,a~leadtime,b~item
        FROM zmm_ip_material AS a
        LEFT OUTER JOIN zdt_ip_material AS b
        ON ( b~material = a~item_code )
        WHERE a~lastchangedate BETWEEN @lv_date_start AND @lv_date_end
        APPENDING TABLE @lt_ipmaterial.

    IF lt_ipmaterial IS NOT INITIAL.
      SORT lt_ipmaterial BY item_code.
      DELETE ADJACENT DUPLICATES FROM lt_ipmaterial COMPARING item_code.
    ENDIF.

    LOOP AT lt_ipmaterial ASSIGNING FIELD-SYMBOL(<lfs_ipmaterial>).
      ls_material = CORRESPONDING #( <lfs_ipmaterial> ).
      lv_json = /ui2/cl_json=>serialize( EXPORTING data = ls_material pretty_name = 'X' ).

      TRY.
          FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                      comm_scenario = 'ZCS_MATERIALIP'
                                      service_id    = 'ZOS_MATERIAL_REST' ).
          FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          FINAL(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |application/json| ).
          IF <lfs_ipmaterial>-item IS NOT INITIAL.
            lo_request->set_header_field(  i_name = 'Edit' i_value = 'X' ).
          ELSE.
            lo_request->set_header_field(  i_name = 'Edit' i_value = '' ).
          ENDIF.
          lo_request->set_text( lv_json ).
          FINAL(ls_text) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          IF ls_text CS 'id' AND <lfs_ipmaterial>-item IS INITIAL. "Success
            /ui2/cl_json=>deserialize( EXPORTING json = ls_text pretty_name = 'X'
                                       CHANGING  data  = ls_material_op ).
            IF ls_material_op-id IS NOT INITIAL.
                APPEND VALUE #( material = <lfs_ipmaterial>-item_code item = ls_material_op-id ) TO lt_ip_mat.
            ENDIF.
          ELSE. "Failure
            "Add Logs if required
          ENDIF.
          lo_http_client->close( ).
          CLEAR lv_json.
        CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error).
        CATCH cx_web_http_client_error INTO FINAL(web_http_client_error).
      ENDTRY.
    ENDLOOP.

    COMMIT ENTITIES BEGIN.
    IF lt_ip_mat[] IS NOT INITIAL.
        MODIFY zdt_ip_material FROM TABLE @lt_ip_mat[].
    ENDIF.
    COMMIT ENTITIES END.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

**********************************************************************
*--API Structure
    TYPES: BEGIN OF lty_material,
             description             TYPE zmm_ip_material-description,
             item_code               TYPE zmm_ip_material-item_code,
             itemgroup               TYPE zmm_ip_material-itemgroup,
             primary_uom             TYPE zmm_ip_material-primary_uom,
             primary_uom_shortform   TYPE zmm_ip_material-primary_uom_shortform,
             secondary_uom           TYPE zmm_ip_material-secondary_uom,
             secondary_uom_shortform TYPE zmm_ip_material-secondary_uom_shortform,
             hsn                     TYPE zmm_ip_material-hsn,
             leadtime                TYPE zmm_ip_material-leadtime,
           END OF lty_material.

    TYPES: BEGIN OF lty_material_op,
             id                      TYPE char72,
             description             TYPE char72,
             item_code               TYPE char72,
             itemgroup               TYPE char72,
             primary_uom             TYPE char72,
             secondary_uom           TYPE char72,
             hsn                     TYPE char72,
             leadtime                TYPE char72,
             created_at              TYPE char72,
             updated_at              TYPE char72,
           END OF lty_material_op.

    DATA: lv_date_start TYPE datum,
          lv_date_end   TYPE datum,
          lv_time_end   TYPE timn,
          lv_time_begin TYPE timn,
          lv_json       TYPE string,

          lt_material   TYPE STANDARD TABLE OF lty_material,
          ls_material   TYPE lty_material,
          ls_material_op TYPE lty_material_op,
          lt_ip_mat     TYPE STANDARD TABLE OF zdt_ip_material.


*Initialization
    lv_date_start = cl_abap_context_info=>get_system_date( ).
    lv_date_end = cl_abap_context_info=>get_system_date( ).
    lv_date_start = lv_date_start - 1.

    SELECT a~item_code,a~description,a~CreationDate,a~LastChangeDate,a~itemgroup,a~primary_uom_shortform,a~primary_uom,
        a~secondary_uom,a~secondary_uom_shortform,a~hsn,a~leadtime,b~item
        FROM zmm_ip_material AS a
        LEFT OUTER JOIN zdt_ip_material AS b
        ON ( b~material = a~item_code )
        WHERE a~creationdate BETWEEN @lv_date_start AND @lv_date_end
        INTO TABLE @DATA(lt_ipmaterial).

    SELECT a~item_code,a~description,a~CreationDate,a~LastChangeDate,a~itemgroup,a~primary_uom_shortform,a~primary_uom,
        a~secondary_uom,a~secondary_uom_shortform,a~hsn,a~leadtime,b~item
        FROM zmm_ip_material AS a
        LEFT OUTER JOIN zdt_ip_material AS b
        ON ( b~material = a~item_code )
        WHERE a~lastchangedate BETWEEN @lv_date_start AND @lv_date_end
        APPENDING TABLE @lt_ipmaterial.

    IF lt_ipmaterial IS NOT INITIAL.
      SORT lt_ipmaterial BY item_code.
      DELETE ADJACENT DUPLICATES FROM lt_ipmaterial COMPARING item_code.
    ENDIF.

    LOOP AT lt_ipmaterial ASSIGNING FIELD-SYMBOL(<lfs_ipmaterial>).
      ls_material = CORRESPONDING #( <lfs_ipmaterial> ).
      lv_json = /ui2/cl_json=>serialize( EXPORTING data = ls_material pretty_name = 'X' ).

      TRY.
          FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                      comm_scenario = 'ZCS_MATERIALIP'
                                      service_id    = 'ZOS_MATERIAL_REST' ).
          FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          FINAL(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |application/json| ).
          IF <lfs_ipmaterial>-item IS NOT INITIAL.
            lo_request->set_header_field(  i_name = 'Edit' i_value = 'X' ).
          ELSE.
            lo_request->set_header_field(  i_name = 'Edit' i_value = '' ).
          ENDIF.
          lo_request->set_text( lv_json ).
          FINAL(ls_text) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          IF ls_text CS 'id' AND <lfs_ipmaterial>-item IS INITIAL. "Success
            /ui2/cl_json=>deserialize( EXPORTING json = ls_text pretty_name = 'X'
                                       CHANGING  data  = ls_material_op ).
            IF ls_material_op-id IS NOT INITIAL.
                APPEND VALUE #( material = <lfs_ipmaterial>-item_code item = ls_material_op-id ) TO lt_ip_mat.
            ENDIF.
          ELSE. "Failure
            "Add Logs if required
          ENDIF.
          lo_http_client->close( ).
          CLEAR lv_json.
        CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error).
        CATCH cx_web_http_client_error INTO FINAL(web_http_client_error).
      ENDTRY.
    ENDLOOP.

    COMMIT ENTITIES BEGIN.
    IF lt_ip_mat[] IS NOT INITIAL.
        MODIFY zdt_ip_material FROM TABLE @lt_ip_mat[].
    ENDIF.
    COMMIT ENTITIES END.

  ENDMETHOD.
ENDCLASS.
