CLASS zcl_product_text DEFINITION
 PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'INVENT'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'Inventory data'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PRODTEXT_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PRODTEXT_ALOGS_01'.

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



CLASS ZCL_PRODUCT_TEXT IMPLEMENTATION.


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
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_PRODTEXT_01_LOG'
                                                                      subobject   = 'ZAPP_PRODTEXT_01_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    DATA : lv_date TYPE datum.
    lv_date = sy-datum - 2.

    DATA : lt_product_text TYPE TABLE OF zdt_product_text.
    DATA : ls_product_text LIKE LINE OF lt_product_text.

    SELECT SINGLE * FROM zdt_product_text
    INTO @DATA(ls_prod_text).
    IF ls_prod_text IS INITIAL.
      SELECT * FROM i_product
         INTO TABLE @DATA(lt_prodtext).
    ELSE.
      SELECT * FROM i_product
      WHERE lastchangedate >= @lv_date
          INTO TABLE @lt_prodtext.
    ENDIF.

    CONSTANTS: c_i TYPE char10 VALUE ''''.
    DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).

    lo_factory->query_ca(
      EXPORTING
        is_query = VALUE #( cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'YY1_SAP_COM_0009' ) ) ) " Custom Communication Scenario
      IMPORTING
        et_com_arrangement = DATA(lt_comm_arrang) ).

    DATA(lo_comm_arrang) = lt_comm_arrang[ 1 ].

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
          comm_scenario  = CONV #( 'YY1_SAP_COM_0009' )" Use Custom Communicaiton Scenario, Not standard!
          comm_system_id = lo_comm_arrang->get_comm_system_id( )
          service_id     = CONV #( 'YY1_PRODUCTINTEGRATION_REST' )" Outbound Service ID
        ).
      CATCH cx_http_dest_provider_error INTO DATA(lo_error).
        DATA(lv_message) = lo_error->get_longtext( ).
    ENDTRY.

    TRY.
        DATA(eo_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
      CATCH cx_web_http_client_error.
    ENDTRY.

    LOOP AT lt_prodtext ASSIGNING FIELD-SYMBOL(<fs_prodtext>).
      IF <fs_prodtext> IS ASSIGNED.
        DATA(eo_request) = eo_client->get_http_request( ).
        eo_request->set_content_type( content_type = |application/json| ).

        DATA: lv_matnr TYPE matnr.
        DATA : product TYPE matnr .
        product = <fs_prodtext>-product.
        lv_matnr = |{ product ALPHA = OUT }| .
        lv_matnr = |'{ lv_matnr }'|.

        DATA(lv_path) = |A_Product({ lv_matnr })/to_ProductBasicText|.
        eo_request->set_uri_path( i_uri_path = lv_path ).
        TRY.
            DATA(lo_response) = eo_client->execute( i_method = if_web_http_client=>get ).
          CATCH cx_web_http_client_error.
        ENDTRY.
        DATA(lv_resp_text) = lo_response->get_text( ).

        DATA: lv_atom_xml  TYPE string,
              lv_abap_xml  TYPE string,
              lt_final_xml TYPE TABLE OF string,
              lv_final_xml TYPE string,
              lt_entries   TYPE TABLE OF string,
              lv_entry1    TYPE string,
              lv_longtext  TYPE string,
              lv_start_pos TYPE i,                    " Start position for extracting values
              lv_end_pos   TYPE i,                      " End position for extracting values
              lv_substr    TYPE string,                  " Temp variable for extracted value
              lv_length    TYPE i.                       " Length for substring extraction

*input Atom XML as string (Example)
        lv_atom_xml = lv_resp_text.

        DATA: lt_atom_entries TYPE TABLE OF string.   " Internal table to store dynamic XML entries

* Transform XML using CALL TRANSFORMATION
        TRY.
            CALL TRANSFORMATION id
              SOURCE XML lv_atom_xml
              RESULT XML lv_abap_xml.
          CATCH cx_root INTO DATA(lx_error).
        ENDTRY.

* Split the XML into entries based on "<entry>" tag
        SPLIT lv_atom_xml AT '<entry>' INTO TABLE lt_atom_entries.

* Loop through the entries (dynamic data)
        LOOP AT lt_atom_entries INTO DATA(lv_entry).
          " Find and extract BillingDocument
          FIND '<d:LongText>' IN lv_entry MATCH OFFSET lv_start_pos.
          IF sy-subrc = 0.
            lv_start_pos = lv_start_pos + 12. " Length of <d:LongText> tag
            FIND '</d:LongText>' IN lv_entry MATCH OFFSET lv_end_pos.
            IF sy-subrc = 0.
              lv_length = lv_end_pos - lv_start_pos .
              lv_substr = lv_entry+lv_start_pos(lv_length).
              lv_longtext = lv_substr.
            ENDIF.
          ENDIF.
        ENDLOOP.
        ls_product_text-product = <fs_prodtext>-product.
        ls_product_text-text = lv_longtext.
        APPEND ls_product_text TO lt_product_text.
        CLEAR : ls_product_text.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.

    TRY.
        "
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
        "
      CATCH cx_root INTO FINAL(job_scheduling_exception). " TODO: variable is assigned but only used in commented-out code (ABAP cleaner) " TODO: variable is assigned but never used (ABAP cleaner)
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
