CLASS lhc_InspLotSerialResult DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ InspLotSerialResult
      RESULT result.

    METHODS rba_Charresult FOR READ
      IMPORTING keys_rba FOR READ InspLotSerialResult\_Charresult
                FULL result_requested
      RESULT result
      LINK association_links.

    METHODS cba_Charresult FOR MODIFY
      IMPORTING entities_cba
        FOR CREATE InspLotSerialResult\_Charresult.

    METHODS saveReportedResults FOR MODIFY
      IMPORTING keys
        FOR ACTION InspLotSerialResult~saveReportedResults.

ENDCLASS.


CLASS lhc_InspLotSerialResult IMPLEMENTATION.

  METHOD read.
  ENDMETHOD.


  METHOD rba_Charresult.
  ENDMETHOD.


  METHOD cba_Charresult.
  ENDMETHOD.


  METHOD saveReportedResults.

    TYPES:
      BEGIN OF ty_result_key,
        inspectionlot            TYPE i_inspectionresultvalue-inspectionlot,
        inspectioncharacteristic TYPE i_inspectionresultvalue-inspectioncharacteristic,
      END OF ty_result_key,

      BEGIN OF ty_max_value,
        inspectionlot               TYPE i_inspectionresultvalue-inspectionlot,
        inspplanoperationinternalid TYPE i_inspectionresultvalue-inspplanoperationinternalid,
        inspectioncharacteristic    TYPE i_inspectionresultvalue-inspectioncharacteristic,
        max_value_id                TYPE i_inspectionresultvalue-inspresultvalueinternalid,
      END OF ty_max_value.


    DATA:
      lo_destination TYPE REF TO if_http_destination,
      lo_client      TYPE REF TO if_web_http_client,
      lo_request     TYPE REF TO if_web_http_request,
      lo_response    TYPE REF TO if_web_http_response,

      lt_result_keys TYPE SORTED TABLE OF ty_result_key
        WITH UNIQUE KEY
          inspectionlot
          inspectioncharacteristic,

      lt_max_values TYPE HASHED TABLE OF ty_max_value
        WITH UNIQUE KEY
          inspectionlot
          inspplanoperationinternalid
          inspectioncharacteristic,

      lv_token    TYPE string,
      lv_payload  TYPE string,
      lv_response TYPE string,
      lv_uri      TYPE string,
      lv_status   TYPE i,
      lv_result   TYPE string,
      lv_valueid  TYPE i.

     data : ls_remarks type zinspc_srl_rmrks.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key_prepare>).

      LOOP AT <key_prepare>-%param-results
        ASSIGNING FIELD-SYMBOL(<result_prepare>).

        INSERT VALUE #(
          inspectionlot =
            <result_prepare>-inspection_lot
          inspectioncharacteristic =
            <result_prepare>-inspection_characteristic
        ) INTO TABLE lt_result_keys.

      ENDLOOP.

    ENDLOOP.


    IF lt_result_keys IS INITIAL.
      RETURN.
    ENDIF.


    SELECT
      resultvalue~inspectionlot,
      resultvalue~inspplanoperationinternalid,
      resultvalue~inspectioncharacteristic,
      MAX( resultvalue~inspresultvalueinternalid ) AS max_value_id
      FROM i_inspectionresultvalue AS resultvalue
      INNER JOIN @lt_result_keys AS requested
        ON requested~inspectionlot =
           resultvalue~inspectionlot
       AND requested~inspectioncharacteristic =
           resultvalue~inspectioncharacteristic
      WHERE resultvalue~inspplanoperationinternalid = '1'
      GROUP BY
        resultvalue~inspectionlot,
        resultvalue~inspplanoperationinternalid,
        resultvalue~inspectioncharacteristic
      INTO TABLE @DATA(lt_db_max_values).


    lt_max_values =
      CORRESPONDING #( lt_db_max_values ).


    TRY.

        lo_destination =
          cl_http_destination_provider=>create_by_comm_arrangement(
            comm_scenario = 'ZCS_INSP_RSLT_UPLD'
            service_id    = 'ZREST_INSP_RSLT_UPLD_REST'
          ).

      CATCH cx_http_dest_provider_error INTO DATA(lx_dest).

        DATA(lv_dest_error) =
          lx_dest->get_text( ).

        RETURN.

    ENDTRY.


    TRY.

        lo_client =
          cl_web_http_client_manager=>create_by_http_destination(
            lo_destination
          ).


        lo_client->accept_cookies(
          abap_true
        ).


        lo_request =
          lo_client->get_http_request( ).


        lo_request->set_uri_path(
          i_uri_path =
            '/sap/opu/odata/sap/API_INSPECTIONLOT_SRV/A_InspectionCharacteristic'
        ).


        lo_request->set_header_field(
          i_name  = 'X-CSRF-Token'
          i_value = 'Fetch'
        ).


        lo_request->set_header_field(
          i_name  = 'Accept'
          i_value = 'application/json'
        ).


        lo_request->set_header_field(
          i_name  = 'Connection'
          i_value = 'keep-alive'
        ).


        lo_response =
          lo_client->execute(
            i_method = if_web_http_client=>get
          ).


        lv_status =
          lo_response->get_status( )-code.


        IF lv_status >= 400.

          lv_response =
            lo_response->get_text( ).

          RETURN.

        ENDIF.


        lv_token =
          lo_response->get_header_field(
            'X-Csrf-Token'
          ).


        IF lv_token IS INITIAL.
          RETURN.
        ENDIF.


        LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).

          LOOP AT <key>-%param-results
            ASSIGNING FIELD-SYMBOL(<ls>).


            CLEAR:
              lv_payload,
              lv_response,
              lv_uri,
              lv_result,
              lv_valueid.


            ASSIGN lt_max_values[
              inspectionlot =
                <ls>-inspection_lot
              inspplanoperationinternalid =
                '1'
              inspectioncharacteristic =
                <ls>-inspection_characteristic
            ] TO FIELD-SYMBOL(<max_value>).


            IF sy-subrc = 0.

              IF <max_value>-max_value_id IS INITIAL.

                lv_valueid = 1.

              ELSE.

                lv_valueid =
                  CONV i( <max_value>-max_value_id ) + 1.

              ENDIF.


              <max_value>-max_value_id =
                CONV #( lv_valueid ).

            ELSE.

              lv_valueid = 1.


              INSERT VALUE #(
                inspectionlot =
                  <ls>-inspection_lot
                inspplanoperationinternalid =
                  '1'
                inspectioncharacteristic =
                  <ls>-inspection_characteristic
                max_value_id =
                  CONV #( lv_valueid )
              ) INTO TABLE lt_max_values.

            ENDIF.


            lv_uri =
              |/sap/opu/odata/sap/API_INSPECTIONLOT_SRV/| &&
              |A_InspectionCharacteristic(| &&
              |InspectionLot='{ <ls>-inspection_lot }',| &&
              |InspPlanOperationInternalID='1',| &&
              |InspectionCharacteristic='{ <ls>-inspection_characteristic }')| &&
              |/to_InspResultValue|.


            lv_result =
              CONV string( <ls>-reported_value ).


            CONDENSE lv_result.


            IF lv_result = 'OK'
               OR lv_result = 'NOK'.


              lv_payload =
                '{' &&
                '"InspectionLot":"' &&
                |{ <ls>-inspection_lot }| &&
                '",' &&
                '"InspPlanOperationInternalID":"1",' &&
                '"InspectionCharacteristic":"' &&
                |{ <ls>-inspection_characteristic }| &&
                '",' &&
                '"InspResultValueInternalID":"' &&
                |{ lv_valueid }| &&
                '",' &&
                '"InspectionResultAttribute":"",' &&
                '"InspectionResultItem":"' &&
                |{ <ls>-serial_number }| &&
                '",' &&
                '"CharacteristicAttributeCodeGrp":"OK/NOTOK",' &&
                '"CharacteristicAttributeCode":"' &&
                lv_result &&
                '",' &&
                '"CharacteristicAttributeCatalog":"1"' &&
                '}'.


            ELSEIF lv_result = 'PASS'
               OR lv_result = 'FAIL'.


              lv_payload =
                '{' &&
                '"InspectionLot":"' &&
                |{ <ls>-inspection_lot }| &&
                '",' &&
                '"InspPlanOperationInternalID":"1",' &&
                '"InspectionCharacteristic":"' &&
                |{ <ls>-inspection_characteristic }| &&
                '",' &&
                '"InspResultValueInternalID":"' &&
                |{ lv_valueid }| &&
                '",' &&
                '"InspectionResultAttribute":"",' &&
                '"InspectionResultItem":"' &&
                |{ <ls>-serial_number }| &&
                '",' &&
                '"CharacteristicAttributeCodeGrp":"PASSFAIL",' &&
                '"CharacteristicAttributeCode":"' &&
                lv_result &&
                '",' &&
                '"CharacteristicAttributeCatalog":"1"' &&
                '}'.


            ELSE.


              lv_payload =
                '{' &&
                '"InspectionLot":"' &&
                |{ <ls>-inspection_lot }| &&
                '",' &&
                '"InspPlanOperationInternalID":"1",' &&
                '"InspectionCharacteristic":"' &&
                |{ <ls>-inspection_characteristic }| &&
                '",' &&
                '"InspResultValueInternalID":"' &&
                |{ lv_valueid }| &&
                '",' &&
                '"InspectionResultAttribute":"",' &&
                '"InspectionResultItem":"' &&
                |{ <ls>-serial_number }| &&
                '",' &&
                '"InspResultFrmtdMeasuredValue":"' &&
                lv_result &&
                '"' &&
                '}'.


            ENDIF.


          ls_remarks-lot_number = <ls>-inspection_lot.
          ls_remarks-serial_number = <ls>-serial_number.
          ls_remarks-remarks = <ls>-remarks.
          modify zinspc_srl_rmrks from @ls_remarks.

            lo_request =
              lo_client->get_http_request( ).


            lo_request->set_uri_path(
              i_uri_path = lv_uri
            ).


            lo_request->set_header_field(
              i_name  = 'X-Csrf-Token'
              i_value = lv_token
            ).


            lo_request->set_header_field(
              i_name  = 'Content-Type'
              i_value = 'application/json'
            ).


            lo_request->set_header_field(
              i_name  = 'Accept'
              i_value = 'application/json'
            ).


            lo_request->set_text(
              lv_payload
            ).


            lo_response =
              lo_client->execute(
                i_method = if_web_http_client=>post
              ).


            lv_status =
              lo_response->get_status( )-code.


            IF lv_status >= 400.

              lv_response =
                lo_response->get_text( ).

              DATA(lv_error_response) =
                lv_response.

            ENDIF.

          clear : ls_remarks.
          ENDLOOP.

        ENDLOOP.


      CATCH cx_web_message_error INTO DATA(lx_message).

        DATA(lv_msg_text) =
          lx_message->get_text( ).


      CATCH cx_web_http_client_error INTO DATA(lx_client_error).

        DATA(lv_client_error) =
          lx_client_error->get_text( ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.


CLASS lsc_ZR_INSPLOTSERIALRESULT DEFINITION
  INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.


CLASS lsc_ZR_INSPLOTSERIALRESULT IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.


  METHOD check_before_save.
  ENDMETHOD.


  METHOD save.

  ENDMETHOD.


  METHOD cleanup.
  ENDMETHOD.


  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
