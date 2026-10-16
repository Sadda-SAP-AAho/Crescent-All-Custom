CLASS zcl_contract_sync DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES if_oo_adt_classrun .
    METHODS: runjob,
        update_doc_status
        IMPORTING
          iv_doc_id      TYPE string
          iv_status      TYPE abap_boolean
          iv_error       TYPE string OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CONTRACT_SYNC IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    runjob( ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    runjob( ).
  ENDMETHOD.


  METHOD runjob.

*    TYPES tt_sc_sync_payload TYPE STANDARD TABLE OF ty_sc_payload WITH EMPTY KEY.

    DATA:  " lt_payload TYPE tt_sc_sync_payload,
      ls_payload      TYPE ty_sc_payload,
      lv_json         TYPE string,
      ls_existing_log TYPE zsync_logs,
      ls_log1         TYPE zsync_logs.

    DATA: lo_client TYPE REF TO if_web_http_client.

    TRY.
        DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
          comm_scenario  = 'ZCS_SALES_OCR'
          comm_system_id = 'SO_HUB_INT'
          service_id     = 'ZOS_SALES_CTRT_SYNC_REST'
        ).

        lo_client = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

      CATCH cx_static_check INTO DATA(lx_dest).
        DATA(err) = lx_dest->if_message~get_longtext(  ).
        RETURN.

    ENDTRY.

    SELECT FROM zr_schdr
        FIELDS docuuid, salescontract
        WHERE iscontractsent IS INITIAL AND salescontract IS NOT INITIAL and Docuuid is not INITIAL
        INTO TABLE @DATA(it_sc) PRIVILEGED ACCESS.

    CHECK it_sc IS NOT INITIAL.

    LOOP AT it_sc INTO DATA(wa_sc).

      CLEAR: ls_payload, lv_json.

      ls_payload = VALUE ty_sc_payload(
        docid             = wa_sc-docuuid
        salescontractno   = wa_sc-salescontract
      ).

      /ui2/cl_json=>serialize(
        EXPORTING
          data        = ls_payload
          pretty_name = /ui2/cl_json=>pretty_mode-none
        RECEIVING
          r_json      = lv_json
      ).

      REPLACE ALL OCCURRENCES OF '"DOCID"'            IN lv_json WITH '"docId"'.
      REPLACE ALL OCCURRENCES OF '"SALESCONTRACTNO"'  IN lv_json WITH '"salesContractNo"'.

      TRY.

          DATA(lo_request) = lo_client->get_http_request( ).

          lo_request->set_header_field( i_name  = 'Content-Type' i_value = 'application/json' ).
          lo_request->set_header_field( i_name  = 'Accept'       i_value = 'application/json' ).
          lo_request->set_text( i_text = lv_json ).

          DATA(lo_response) = lo_client->execute( i_method = if_web_http_client=>post ).
          DATA(lv_status_code) = lo_response->get_status( )-code.
          DATA(lv_response_body) = lo_response->get_text( ).

          DATA: response TYPE ty_response.
          xco_cp_json=>data->from_string( lv_response_body )->write_to( REF #( response ) ).
          IF response-status = 200 .
            update_doc_status(
              iv_doc_id = CONV string( wa_sc-docuuid )
              iv_status = abap_true
            ).
          ELSE.
            update_doc_status(
              iv_doc_id = CONV string( wa_sc-docuuid )
              iv_status = abap_false
              iv_error  = response-message
            ).
          ENDIF.
        CATCH cx_web_http_client_error INTO DATA(lx_http).
          update_doc_status(
            iv_doc_id = CONV string( wa_sc-docuuid )
            iv_status = ''
            iv_error  = lx_http->get_text( )
          ).
      ENDTRY.

    ENDLOOP.

    IF lo_client IS BOUND.
      TRY.
          lo_client->close( ).
        CATCH cx_web_http_client_error.
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD update_doc_status.

    MODIFY ENTITIES OF zr_schdr
      ENTITY ZrSchdr
        UPDATE FIELDS ( IsContractSent ErrorLog )
        WITH VALUE #(
          (
            %tky-Docuuid  = iv_doc_id
            IsContractSent = iv_status
            ErrorLog      = COND #( WHEN iv_error       IS SUPPLIED THEN iv_error  ELSE '' )
          )
        )
      REPORTED DATA(ls_reported)
      FAILED   DATA(ls_failed)
      MAPPED   DATA(ls_mapped).

    COMMIT ENTITIES
      RESPONSE OF zr_schdr
      FAILED DATA(ls_commit_failed)
      REPORTED DATA(ls_commit_reported).
  ENDMETHOD.
ENDCLASS.
