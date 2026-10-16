CLASS zcl_unit_price DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES: if_sadl_exit_calc_element_read.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_UNIT_PRICE IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.


    DATA: lt_data        TYPE STANDARD TABLE OF z_c_sls_dcnt WITH DEFAULT KEY, "
          lv_json        TYPE string,
          lo_destination TYPE REF TO if_http_destination,
          lo_client      TYPE REF TO if_web_http_client,
          lo_request     TYPE REF TO if_web_http_request,
          lo_response    TYPE REF TO if_web_http_response,
          lv_payload     TYPE string,
          lv_response    TYPE string.

    " Nested OData JSON Response Structure Definitions
    TYPES:
      BEGIN OF ty_condition,
        ConditionRecord            TYPE string,
        ConditionType              TYPE string,
        ConditionValidityEndDate   TYPE string,
        ConditionValidityStartDate TYPE string,
        ConditionRateValue         TYPE string,
        ConditionRateAmount        TYPE string,
      END OF ty_condition.

    TYPES:
      BEGIN OF ty_result,
        ConditionType             TYPE string,
        SalesOrganization         TYPE string,
        DistributionChannel       TYPE string,
        Customer                  TYPE string,
        Material                  TYPE string,
        to_slsprcgconditionrecord TYPE ty_condition,
      END OF ty_result.

    TYPES: ty_results TYPE STANDARD TABLE OF ty_result WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_d,
        results TYPE ty_results,
      END OF ty_d.

    TYPES:
      BEGIN OF ty_response,
        d TYPE ty_d,
      END OF ty_response.

    DATA: ls_response TYPE ty_response.

    FIELD-SYMBOLS: <fs_result> TYPE any,
                   <fs_cond>   TYPE any.



    lt_data = CORRESPONDING #( it_original_data ).
    data(lt_data_total)  = lt_data.



    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<ls_data>).

      TRY.

          lo_destination = cl_http_destination_provider=>create_by_comm_arrangement(
                                comm_scenario = 'ZCS_SALES_DISCOUNT'
                                service_id    = 'ZREST_SLS_DISC_REST'
                            ).
        CATCH cx_http_dest_provider_error INTO DATA(lx_dest).
          DATA(lv_dest_error) = lx_dest->get_text( ).
      ENDTRY.

      TRY.

          lo_client  = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          lo_request = lo_client->get_http_request( ).


          lo_request->set_uri_path( i_uri_path = 'A_SlsPrcgCndnRecdValidity' ).


          DATA(lv_date) = |{ <ls_data>-Cust_Reqd_Dt+0(4) }{ '-' }| &&
                          |{ <ls_data>-Cust_Reqd_Dt+4(2) }{ '-' }| &&
                          |{ <ls_data>-Cust_Reqd_Dt+6(2) }{ 'T00:00:00' }|.


          DATA(lv_query) = |$filter=ConditionType eq 'ZPR0' | &&
                            |and SalesOrganization eq '{ <ls_data>-Salesorg }' | &&
                            |and DistributionChannel eq '{ <ls_data>-Distchan }' | &&
                            |and Customer eq '{ <ls_data>-Customer }' | &&
                            |and Material eq '{ <ls_data>-Material }' | &&
                            |and ConditionValidityStartDate le datetime'{ lv_date }' | &&
                            |and ConditionValidityEndDate ge datetime'{ lv_date }' | &&
                            |&$expand=to_SlsPrcgConditionRecord| &&
                            |&$format=json|.

          lo_request->set_query( query = lv_query ).

          lo_request->set_header_field( i_name = 'Accept' i_value = 'application/json' ).
          lo_request->set_header_field( i_name = 'Connection' i_value = 'keep-alive' ).


          lo_response = lo_client->execute( i_method = if_web_http_client=>get ).
          lv_response = lo_response->get_text( ).


          /ui2/cl_json=>deserialize(
            EXPORTING
              json        = lv_response
              pretty_name = /ui2/cl_json=>pretty_mode-camel_case
            CHANGING
              data        = ls_response
          ).


          READ TABLE ls_response-d-results INTO DATA(ls_result) INDEX 1.
          IF sy-subrc = 0.
            <ls_data>-Unitprice    = ls_result-to_slsprcgconditionrecord-conditionratevalue.
            <ls_data>-Total_price  = ( <ls_data>-Unitprice * <ls_data>-Order_Quantity ).
          ENDIF.



          IF <ls_data>-total_price IS NOT INITIAL.
            <ls_data>-Value_Mt = ( <ls_data>-Total_price / <ls_data>-Total_Wt_Mt ).
          ENDIF.





          if <ls_data>-Total_Wt_Mt is NOT INITIAL.
          <ls_data>-Discount = ( <ls_data>-Value_Mt * (  <ls_data>-Total_Wt_Mt  - 1000 ) * <ls_data>-Discount_percent ).
          endif.

        CATCH cx_web_message_error INTO DATA(msg).
          DATA(lv_msg_text) = msg->get_text( ).
        CATCH cx_web_http_client_error INTO DATA(client_error).
          DATA(lv_client_error) = client_error->get_text( ).

      ENDTRY.

    ENDLOOP.


    data(lv_total_price) =  REDUCE wrbtr( INIT TOTAL = CONV #( 0 ) for  gs_data in lt_data next total = total + gs_data-total_price  ).
    data(lv_total_wt_mt) = reduce wrbtr( init total_mt_wt = conv #( 0 ) for ws_data in lt_data next total_mt_wt = total_mt_wt + ws_data-total_wt_mt ).
    data(lv_total_wt) = reduce wrbtr( init total_wt = conv #( 0 ) for ss_data in lt_data next total_wt = total_wt + ss_data-Total_Weight ).

LOOP AT lt_data ASSIGNING <ls_data>.
  <ls_data>-Grand_Total_price = lv_total_price.
  <ls_data>-Grand_Total_wt = lv_total_wt.
  <ls_data>-Total_Wt_Mt = lv_total_wt_mt.
ENDLOOP.

loop at lt_data ASSIGNING <ls_data>.

if <ls_data>-Total_Wt_Mt > 0.
      if <ls_data>-total_wt_mt >= 1100 and <ls_data>-total_wt_mt < 1200.
          <ls_data>-Discount_percent = '0.01'.
          <ls_data>-DiscountUnit     = '%'.
          elseif <ls_data>-Total_Wt_Mt >= 1200 and <ls_data>-total_wt_mt < 1300.
            <ls_data>-Discount_percent = '0.02'.
            <ls_data>-DiscountUnit     = '%'.
          elseif <ls_data>-Total_Wt_Mt >= 1300 and <ls_data>-total_wt_mt < 1400.
           <ls_data>-Discount_percent = '0.03'.
           <ls_data>-DiscountUnit     = '%'.
          elseif  <ls_data>-Total_Wt_Mt >= 1400.
           <ls_data>-Discount_percent = '0.04'.
           <ls_data>-DiscountUnit     = '%'.
           else.
           <ls_data>-Discount_percent = '0.00'.
              <ls_data>-DiscountUnit     = '%'.
          endif.
<ls_data>-Discount = ( ( <ls_data>-Grand_Total_price / <ls_data>-Total_Wt_Mt ) * ( <ls_data>-Total_Wt_Mt - 1000 ) * <ls_data>-Discount_percent ).
endif.

if <ls_data>-Total_Wt_Mt > 0.
      if <ls_data>-total_wt_mt >= 1100 and <ls_data>-total_wt_mt < 1200.
          <ls_data>-discount_per = '1.00'.
          <ls_data>-DiscountUnit = '%'.
          elseif <ls_data>-Total_Wt_Mt >= 1200 and <ls_data>-total_wt_mt < 1300.
            <ls_data>-Discount_per = '2.00'.
            <ls_data>-DiscountUnit = '%'.
          elseif <ls_data>-Total_Wt_Mt >= 1300 and <ls_data>-total_wt_mt < 1400.
           <ls_data>-Discount_per = '3.00'.
           <ls_data>-DiscountUnit = '%'.
          elseif  <ls_data>-Total_Wt_Mt >= 1400.
           <ls_data>-Discount_per = '4.00'.
           <ls_data>-DiscountUnit = '%'.
           else.
           <ls_data>-Discount_percent = '0.00'.
              <ls_data>-DiscountUnit     = '%'.
          endif.
endif.
endloop.

    ct_calculated_data = CORRESPONDING #( lt_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.


    IF line_exists(
         it_requested_calc_elements[ table_line = 'UNITPRICE' ]
       )
    OR line_exists(
         it_requested_calc_elements[ table_line = 'TOTAL_PRICE' ]
       )
    OR line_exists(
         it_requested_calc_elements[ table_line = 'VALUE_MT' ]
       )
         OR line_exists(
         it_requested_calc_elements[ table_line = 'DISCOUNT_PERCENT' ]
       )
        OR line_exists(
    it_requested_calc_elements[
        table_line = 'DISCOUNTUNIT'
    ]
)
            OR line_exists(
         it_requested_calc_elements[ table_line = 'GRAND_TOTAL_PRICE' ]
         )

        OR line_exists(
         it_requested_calc_elements[ table_line = 'GRAND_TOTAL_WT' ]
         )
         OR line_exists(
         it_requested_calc_elements[ table_line = 'DISCOUNT' ]
         )


         .



      INSERT CONV string( 'SALESORG' )
        INTO TABLE et_requested_orig_elements.

      INSERT CONV string( 'DISTCHAN' )
        INTO TABLE et_requested_orig_elements.

      INSERT CONV string( 'CUSTOMER' )
        INTO TABLE et_requested_orig_elements.

      INSERT CONV string( 'MATERIAL' )
        INTO TABLE et_requested_orig_elements.

      INSERT CONV string( 'CUST_REQD_DT' )
        INTO TABLE et_requested_orig_elements.

      INSERT CONV string( 'ORDER_QUANTITY' )
        INTO TABLE et_requested_orig_elements.

      INSERT CONV string( 'TOTAL_WT_MT' )
        INTO TABLE et_requested_orig_elements.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
