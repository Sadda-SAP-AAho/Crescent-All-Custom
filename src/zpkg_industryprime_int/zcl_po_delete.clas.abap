CLASS zcl_po_delete DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'PO'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'PO data'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PO_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PO_ALOGS_01'.

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



CLASS ZCL_PO_DELETE IMPLEMENTATION.


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
                               header = cl_bali_header_setter=>create( object = 'ZAPP_PO_01_LOG'
                                                                       subobject = 'ZAPP_PO_01_SUB'
                                                                       external_id = 'MATERIAL IP' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.

  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.


  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    SELECT *
     FROM zdt_po_head
     WHERE uuid IS NOT INITIAL
     INTO TABLE @DATA(lt_po_head).
    IF sy-subrc = 0.
      SORT lt_po_head BY uuid.
      DELETE zdt_po_head FROM TABLE @lt_po_head.
    ENDIF.

    SELECT *
     FROM zdt_po_item
     WHERE uuid IS NOT INITIAL
     INTO TABLE @DATA(lt_po_item).
    IF sy-subrc = 0.
      DELETE zdt_po_item FROM TABLE @lt_po_item.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
