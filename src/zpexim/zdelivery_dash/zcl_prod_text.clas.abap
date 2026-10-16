CLASS zcl_prod_text DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PROD_TEXT IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.

   data: product TYPE matnr.
   DATA it_inventory_data TYPE STANDARD TABLE OF ZC_DELDASH_ITM WITH DEFAULT KEY.
   it_inventory_data  = CORRESPONDING #( it_original_data ).


  CONSTANTS: c_i TYPE char10 VALUE ''''.

   loop at it_inventory_data ASSIGNING FIELD-SYMBOL(<fs_inventory>).
   if <fs_inventory> is ASSIGNED.

   product = <fs_inventory>-matnr.
   DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).

    lo_factory->query_ca(
      EXPORTING
        is_query = VALUE #( cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZCS_SAP_COM_0009' ) ) ) " Custom Communication Scenario
      IMPORTING
        et_com_arrangement = DATA(lt_comm_arrang) ).

    DATA(lo_comm_arrang) = lt_comm_arrang[ 1 ].

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
          comm_scenario  = CONV #( 'ZCS_SAP_COM_0009' )" Use Custom Communicaiton Scenario, Not standard!
          comm_system_id = lo_comm_arrang->get_comm_system_id( )
          service_id     = CONV #( 'ZOS_PRODUCTINT_REST' )" Outbound Service ID
        ).
      CATCH cx_http_dest_provider_error INTO DATA(lo_error).
        DATA(lv_message) = lo_error->get_longtext( ).
    ENDTRY.

    TRY.
        DATA(eo_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
      CATCH cx_web_http_client_error.
    ENDTRY.

    DATA(eo_request) = eo_client->get_http_request( ).
    eo_request->set_content_type( content_type = |application/json| ).

    data: lv_matnr type matnr.
    data: lv_sales type i_salesorder-SalesOrganization,
          lv_dis   type i_salesorder-DistributionChannel.
     lv_matnr = |{ product ALPHA = OUT }| .
     lv_matnr = |'{ lv_matnr }'|.

  "  data(lv_path) = |A_Product({ lv_matnr })/to_ProductBasicText|.
    data(lv_path) = |/A_ProductSalesDelivery(Product= '{ lv_matnr }',ProductSalesOrg='{ lv_sales }',ProductDistributionChnl='{ lv_dis }')/to_SalesText|.
    eo_request->set_uri_path( i_uri_path = lv_path ).

    TRY.
        DATA(lo_response) = eo_client->execute( i_method = if_web_http_client=>get ).
      CATCH cx_web_http_client_error.
    ENDTRY.

    DATA(lv_resp_satus) = lo_response->get_status( ).
    DATA(lv_resp_text) = lo_response->get_text( ).


   DATA: lv_atom_xml TYPE string,
      lv_abap_xml TYPE string,
      lt_final_xml TYPE TABLE OF string,
      lv_final_xml TYPE string,
      lt_entries TYPE TABLE OF string,
      lv_entry1 TYPE string,
      lv_longtext TYPE string,
      lv_start_pos TYPE i,                    " Start position for extracting values
      lv_end_pos TYPE i,                      " End position for extracting values
      lv_substr TYPE string,                  " Temp variable for extracted value
      lv_length TYPE i.                       " Length for substring extraction

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
        lv_start_pos = lv_start_pos + 13. " Length of <d:LongText> tag
        FIND '</d:LongText>' IN lv_entry MATCH OFFSET lv_end_pos.
        if sy-subrc = 0.
         lv_length = lv_end_pos - lv_start_pos .
         lv_substr = lv_entry+lv_start_pos(lv_length).
         lv_longtext = lv_substr.
       ENDIF.
  ENDIF.
  ENDLOOP.
  <fs_inventory>-Itmpaiinfo = lv_longtext.

  clear : lv_longtext, lv_substr, lv_length ,lv_end_pos, lv_start_pos , lv_entry,
          lt_atom_entries ,  lv_atom_xml, lv_resp_text, lv_resp_satus.
  free : lo_response , eo_request ,lo_factory , lo_comm_arrang , eo_client , lo_destination , lo_error , lt_entries , lt_final_xml.
  ENDIF.
  ENDLOOP.
  sort it_inventory_data by Matnr.
  ct_calculated_data = CORRESPONDING #( it_inventory_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.
ENDCLASS.
