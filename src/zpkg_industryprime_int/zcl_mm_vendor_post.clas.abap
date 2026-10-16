CLASS zcl_mm_vendor_post DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.
  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1 VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8 VALUE 'INVENT'.
    CONSTANTS selection_description         TYPE c LENGTH 255 VALUE 'Inventory data'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_VENDOR_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_VENDOR_ALOGS_01'.
    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
    METHODS constructor.
  PRIVATE SECTION.
    METHODS add_text_to_app_log_or_console
      IMPORTING i_text TYPE cl_bali_free_text_setter=>ty_text
      RAISING   cx_bali_runtime.
    METHODS post_vendors
      RAISING cx_bali_runtime.
    METHODS post_vendor_block_status
      RAISING cx_bali_runtime.
    DATA out             TYPE REF TO if_oo_adt_classrun_out.
    DATA application_log TYPE REF TO if_bali_log.
ENDCLASS.
CLASS zcl_mm_vendor_post IMPLEMENTATION.
  METHOD add_text_to_app_log_or_console.
    IF sy-batch = abap_true.
      FINAL(application_log_free_text) =
        cl_bali_free_text_setter=>create(
          severity = if_bali_constants=>c_severity_status
          text     = i_text ).
      application_log_free_text->set_detail_level( detail_level = '1' ).
      IF application_log IS BOUND.
        application_log->add_item( item = application_log_free_text ).
        cl_bali_log_db=>get_instance( )->save_log( log = application_log ).
      ENDIF.
    ELSE.
      IF out IS BOUND.
        out->write( i_text ).
      ENDIF.
    ENDIF.
  ENDMETHOD.
  METHOD constructor.
    TRY.
        application_log =
          cl_bali_log=>create_with_header(
            header = cl_bali_header_setter=>create(
              object      = 'ZAPP_VENDOR_01_LOG'
              subobject   = 'ZAPP_VENDOR_01_SUB'
              external_id = 'VENDOR IP' ) ).
      CATCH cx_bali_runtime.
    ENDTRY.
  ENDMETHOD.
  METHOD if_apj_dt_exec_object~get_parameters.
  ENDMETHOD.
  METHOD if_apj_rt_exec_object~execute.
    TRY.
        post_vendors( ).
        post_vendor_block_status( ).
      CATCH cx_bali_runtime.
    ENDTRY.
  ENDMETHOD.
  METHOD if_oo_adt_classrun~main.
    me->out = out.
    TRY.
        post_vendors( ).
        post_vendor_block_status( ).
      CATCH cx_bali_runtime INTO DATA(lx_bali).
        out->write( lx_bali->get_text( ) ).
    ENDTRY.
  ENDMETHOD.
  METHOD post_vendors.
    TYPES:
      BEGIN OF lty_vendor,
        cardcode    TYPE string,
        cardname    TYPE string,
        state       TYPE string,
        country     TYPE string,
        email       TYPE string,
        phone1      TYPE string,
        phone2      TYPE string,
        pincode     TYPE string,
        city        TYPE string,
        contactname TYPE string,
        address     TYPE string,
        street      TYPE string,
        block       TYPE string,
        bankacct    TYPE string,
        bankifsc    TYPE string,
        bankcode    TYPE string,
        pan         TYPE string,
        gst         TYPE string,
      END OF lty_vendor,
      lty_vendor_tab TYPE STANDARD TABLE OF lty_vendor WITH EMPTY KEY,
      BEGIN OF lty_request,
        vendors TYPE lty_vendor_tab,
      END OF lty_request.
    DATA:
      lv_date_start TYPE datum,
      lv_date_end   TYPE datum,
      lv_json       TYPE string,
      ls_request    TYPE lty_request.
    lv_date_start = cl_abap_context_info=>get_system_date( ).
    lv_date_end   = cl_abap_context_info=>get_system_date( ).
    SELECT businesspartner
      FROM i_businesspartnertp_3
      WHERE creationdate BETWEEN @lv_date_start AND @lv_date_end
      INTO TABLE @DATA(lt_bpmain).
    SELECT businesspartner
      FROM i_businesspartnertp_3
      WHERE lastchangedate BETWEEN @lv_date_start AND @lv_date_end
      APPENDING TABLE @lt_bpmain.
    IF lt_bpmain IS INITIAL.
      RETURN.
    ENDIF.
    SORT lt_bpmain BY businesspartner.
    DELETE ADJACENT DUPLICATES FROM lt_bpmain
      COMPARING businesspartner.
    SELECT supplier,
           bpsupplierfullname,
           region,
           country,
           phonenumber1,
           phonenumber2,
           postalcode,
           cityname,
           bpaddrstreetname,
           streetname,
           businesspartnerpannumber,
           taxnumber3,
           bankaccount,
           banknumber,
           bankname
      FROM z_supplier
      FOR ALL ENTRIES IN @lt_bpmain
      WHERE supplier = @lt_bpmain-businesspartner
      INTO TABLE @DATA(lt_zsupplier).
    IF lt_zsupplier IS INITIAL.
      RETURN.
    ENDIF.
    SORT lt_zsupplier BY supplier.
    SELECT businesspartner,
           addressnumber,
           ordinalnumber,
           emailaddress
      FROM i_buspartemailaddresstp_3
      FOR ALL ENTRIES IN @lt_bpmain
      WHERE businesspartner = @lt_bpmain-businesspartner
      INTO TABLE @DATA(lt_bpemail).
    SORT lt_bpemail BY businesspartner addressnumber ordinalnumber.
    SELECT country,
           region,
           regionname
      FROM i_regiontext
      WHERE language = @sy-langu
      INTO TABLE @DATA(lt_regiontext).
    SORT lt_regiontext BY country region.
    SELECT country,
           countryname
      FROM i_countrytext
      WHERE language = @sy-langu
      INTO TABLE @DATA(lt_countrytext).
    SORT lt_countrytext BY country.
    LOOP AT lt_zsupplier INTO DATA(ls_zsupplier).
      APPEND INITIAL LINE TO ls_request-vendors
        ASSIGNING FIELD-SYMBOL(<ls_vendor>).
      <ls_vendor>-cardcode = CONV string( ls_zsupplier-supplier ).
      <ls_vendor>-cardname = CONV string( ls_zsupplier-bpsupplierfullname ).
      <ls_vendor>-phone1 =
        CONV string( ls_zsupplier-phonenumber1 ).
      <ls_vendor>-phone2 =
        CONV string( ls_zsupplier-phonenumber2 ).
      <ls_vendor>-pincode =
        CONV string( ls_zsupplier-postalcode ).
      <ls_vendor>-city =
        CONV string( ls_zsupplier-cityname ).
      <ls_vendor>-address =
        CONV string( ls_zsupplier-bpaddrstreetname ).
      <ls_vendor>-street =
        CONV string( ls_zsupplier-streetname ).
      <ls_vendor>-pan =
        CONV string( ls_zsupplier-businesspartnerpannumber ).
      <ls_vendor>-gst =
        CONV string( ls_zsupplier-taxnumber3 ).
      <ls_vendor>-bankacct =
        CONV string( ls_zsupplier-bankaccount ).
      <ls_vendor>-bankifsc =
        CONV string( ls_zsupplier-banknumber ).
      DATA(lv_bank_number) =
        CONV string( ls_zsupplier-banknumber ).
      IF strlen( lv_bank_number ) >= 4.
        <ls_vendor>-bankcode =
          substring(
            val = lv_bank_number
            off = 0
            len = 4 ).
      ELSE.
        <ls_vendor>-bankcode = lv_bank_number.
      ENDIF.
      READ TABLE lt_regiontext
        INTO DATA(ls_regiontext)
        WITH KEY
          country = ls_zsupplier-country
          region  = ls_zsupplier-region
        BINARY SEARCH.
      IF sy-subrc = 0.
        <ls_vendor>-state =
          CONV string( ls_regiontext-regionname ).
      ELSE.
        CLEAR <ls_vendor>-state.
      ENDIF.
      READ TABLE lt_countrytext
        INTO DATA(ls_countrytext)
        WITH KEY country = ls_zsupplier-country
        BINARY SEARCH.
      IF sy-subrc = 0.
        <ls_vendor>-country =
          CONV string( ls_countrytext-countryname ).
      ELSE.
        CLEAR <ls_vendor>-country.
      ENDIF.
      READ TABLE lt_bpemail
        INTO DATA(ls_bpemail)
        WITH KEY businesspartner = ls_zsupplier-supplier
        BINARY SEARCH.
      IF sy-subrc = 0.
        <ls_vendor>-email =
          CONV string( ls_bpemail-emailaddress ).
      ELSE.
        CLEAR <ls_vendor>-email.
      ENDIF.
      CLEAR:
        <ls_vendor>-contactname,
        <ls_vendor>-block.
    ENDLOOP.
    IF ls_request-vendors IS INITIAL.
      RETURN.
    ENDIF.
    DATA(lt_name_mappings) =
      VALUE /ui2/cl_json=>name_mappings(
        ( abap = 'VENDORS'     json = 'vendors' )
        ( abap = 'CARDCODE'    json = 'CardCode' )
        ( abap = 'CARDNAME'    json = 'CardName' )
        ( abap = 'STATE'       json = 'State' )
        ( abap = 'COUNTRY'     json = 'Country' )
        ( abap = 'EMAIL'       json = 'Email' )
        ( abap = 'PHONE1'      json = 'Phone1' )
        ( abap = 'PHONE2'      json = 'Phone2' )
        ( abap = 'PINCODE'     json = 'PinCode' )
        ( abap = 'CITY'        json = 'City' )
        ( abap = 'CONTACTNAME' json = 'ContactName' )
        ( abap = 'ADDRESS'     json = 'Address' )
        ( abap = 'STREET'      json = 'Street' )
        ( abap = 'BLOCK'       json = 'Block' )
        ( abap = 'BANKACCT'    json = 'BankAcct' )
        ( abap = 'BANKIFSC'    json = 'BankIFSC' )
        ( abap = 'BANKCODE'    json = 'BankCode' )
        ( abap = 'PAN'         json = 'Pan' )
        ( abap = 'GST'         json = 'Gst' ) ).
    lv_json =
      /ui2/cl_json=>serialize(
        data          = ls_request
        name_mappings = lt_name_mappings ).
    add_text_to_app_log_or_console(
      |Vendor count prepared: { lines( ls_request-vendors ) }| ).
    IF sy-batch = abap_false AND out IS BOUND.
      out->write( lv_json ).
    ENDIF.
    TRY.
        FINAL(lo_destination) =
          cl_http_destination_provider=>create_by_comm_arrangement(
            comm_scenario = 'ZCS_VENDORIP'
            service_id    = 'ZOS_VENDORIP_REST' ).
        FINAL(lo_http_client) =
          cl_web_http_client_manager=>create_by_http_destination(
            lo_destination ).
        FINAL(lo_request) =
          lo_http_client->get_http_request( ).
        lo_request->set_content_type(
          content_type = |application/json| ).
        lo_request->set_text( lv_json ).
        FINAL(lo_response) =
          lo_http_client->execute(
            if_web_http_client=>post ).
        FINAL(lv_response_text) =
          lo_response->get_text( ).
        add_text_to_app_log_or_console(
          |Vendor API response: { lv_response_text }| ).
        lo_http_client->close( ).
      CATCH cx_http_dest_provider_error INTO FINAL(lx_destination).
        add_text_to_app_log_or_console(
          |Destination error: { lx_destination->get_text( ) }| ).
      CATCH cx_web_http_client_error INTO FINAL(lx_http).
        add_text_to_app_log_or_console(
          |HTTP error: { lx_http->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.
  METHOD post_vendor_block_status.
    TYPES:
      BEGIN OF lty_vendor_block,
        cardcode TYPE string,
        blocked  TYPE abap_bool,
      END OF lty_vendor_block,
      lty_vendor_block_tab TYPE STANDARD TABLE OF lty_vendor_block WITH EMPTY KEY,
      BEGIN OF lty_block_request,
        vendors TYPE lty_vendor_block_tab,
      END OF lty_block_request.
    DATA lv_date TYPE datum.
    DATA lv_json TYPE string.
    DATA ls_request TYPE lty_block_request.
    lv_date = cl_abap_context_info=>get_system_date( ).
    SELECT businesspartner,
           businesspartnerisblocked
      FROM i_businesspartner
      WHERE lastchangedate = @lv_date
      INTO TABLE @DATA(lt_changed_bp).
    IF lt_changed_bp IS INITIAL.
      RETURN.
    ENDIF.
    SELECT supplier
      FROM z_supplier
      FOR ALL ENTRIES IN @lt_changed_bp
      WHERE supplier = @lt_changed_bp-businesspartner
      INTO TABLE @DATA(lt_changed_suppliers).
    IF lt_changed_suppliers IS INITIAL.
      RETURN.
    ENDIF.
    SORT lt_changed_suppliers BY supplier.
    DELETE ADJACENT DUPLICATES FROM lt_changed_suppliers COMPARING supplier.
    SORT lt_changed_bp BY businesspartner.
    LOOP AT lt_changed_suppliers INTO DATA(ls_supplier).
      READ TABLE lt_changed_bp INTO DATA(ls_bp)
        WITH KEY businesspartner = ls_supplier-supplier
        BINARY SEARCH.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      APPEND INITIAL LINE TO ls_request-vendors ASSIGNING FIELD-SYMBOL(<ls_block>).
      <ls_block>-cardcode = CONV string( ls_supplier-supplier ).
      IF ls_bp-businesspartnerisblocked = abap_true.
        <ls_block>-blocked = abap_true.
      ELSE.
        <ls_block>-blocked = abap_false.
      ENDIF.
    ENDLOOP.
    IF ls_request-vendors IS INITIAL.
      RETURN.
    ENDIF.
    DATA(lt_name_mappings) =
      VALUE /ui2/cl_json=>name_mappings(
        ( abap = 'VENDORS'  json = 'vendors' )
        ( abap = 'CARDCODE' json = 'CardCode' )
        ( abap = 'BLOCKED'  json = 'blocked' ) ).
    lv_json =
      /ui2/cl_json=>serialize(
        data          = ls_request
        name_mappings = lt_name_mappings ).
    add_text_to_app_log_or_console(
      |Vendor block/unblock count prepared: { lines( ls_request-vendors ) }| ).
    IF sy-batch = abap_false AND out IS BOUND.
      out->write( lv_json ).
    ENDIF.
    TRY.
        FINAL(lo_destination) =
          cl_http_destination_provider=>create_by_comm_arrangement(
            comm_scenario = 'ZCS_VENDORIP_BLOCK'
            service_id    = 'ZOS_VENDORIP_BLOCK_REST' ).
        FINAL(lo_http_client) =
          cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        FINAL(lo_request) = lo_http_client->get_http_request( ).
*        lo_request->set_uri_path( i_uri_path = '/api/vendors/block' ).
        lo_request->set_content_type( content_type = |application/json| ).
        lo_request->set_text( lv_json ).
        FINAL(lo_response) = lo_http_client->execute( if_web_http_client=>post ).
        FINAL(lv_status) = lo_response->get_status( ).
        FINAL(lv_response_text) = lo_response->get_text( ).
        add_text_to_app_log_or_console(
          |Vendor Block API HTTP { lv_status-code }: { lv_response_text }| ).
        lo_http_client->close( ).
      CATCH cx_http_dest_provider_error INTO FINAL(lx_destination).
        add_text_to_app_log_or_console(
          |Vendor Block destination error: { lx_destination->get_text( ) }| ).
      CATCH cx_web_http_client_error INTO FINAL(lx_http).
        add_text_to_app_log_or_console(
          |Vendor Block HTTP error: { lx_http->get_text( ) }| ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.

