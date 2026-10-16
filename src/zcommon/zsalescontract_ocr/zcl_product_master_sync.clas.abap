CLASS zcl_product_master_sync DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES if_oo_adt_classrun .


    TYPES:
      BEGIN OF ty_product_payload,
        product                   TYPE zi_product_sync-product,
        plant                     TYPE zi_product_sync-plant,
        product_description       TYPE zi_product_sync-productdescription,
        plant_name                TYPE zi_product_sync-plantname,
        product_type              TYPE zi_product_sync-producttype,
        product_type_description  TYPE zi_product_sync-producttypename,
        product_group             TYPE zi_product_sync-productgroup,
        product_group_description TYPE zi_product_sync-productgrouptext,
        base_unit_of_measure      TYPE zi_product_sync-baseunit,
        meas_unit_text            TYPE zi_product_sync-unitofmeasurename,
        mrp_type                  TYPE zi_product_sync-mrptype,
        valuation_class           TYPE zi_product_sync-valuationclass,
        price_control             TYPE zi_product_sync-pricedeterminationcontrol,
        inventory_price           TYPE zi_product_sync-standardprice,
        currency                  TYPE zi_product_sync-currency,
      END OF ty_product_payload.

    TYPES: BEGIN OF ty_sub_response,
             error TYPE STANDARD TABLE OF string WITH DEFAULT KEY,
           END OF ty_sub_response.

    TYPES: BEGIN OF ty_response,
             status  TYPE i,
             message TYPE string,
             data    TYPE ty_sub_response,
           END OF ty_response.

    TYPES: BEGIN OF ty_result,
             key   TYPE string,
             ok    TYPE abap_bool,
             error TYPE string,
           END OF ty_result,
           tt_result TYPE STANDARD TABLE OF ty_result WITH EMPTY KEY.

    TYPES: tt_product TYPE STANDARD TABLE OF zi_product_sync WITH EMPTY KEY,
           tt_payload TYPE STANDARD TABLE OF ty_product_payload WITH EMPTY KEY.

    TYPES: BEGIN OF ty_open_error,
             uuid         TYPE zi_sync_logs-uuid,
             refobjectkey TYPE zi_sync_logs-refobjectkey,
           END OF ty_open_error.

    DATA mo_client      TYPE REF TO if_web_http_client.
    DATA mo_log         TYPE REF TO if_bali_log.
    DATA mt_open_errors TYPE SORTED TABLE OF ty_open_error WITH NON-UNIQUE KEY refobjectkey.
    DATA mv_ok          TYPE i.
    DATA mv_failed      TYPE i.

    METHODS run_job.
    METHODS get_watermark   RETURNING VALUE(rv_since) TYPE utclong.
    METHODS set_watermark   IMPORTING iv_ts TYPE utclong.
    METHODS load_open_errors.
    METHODS select_work     IMPORTING iv_since           TYPE utclong
                            RETURNING VALUE(rt_products) TYPE tt_product.
    METHODS send_batch      IMPORTING it_batch          TYPE tt_product
                            RETURNING VALUE(rt_results) TYPE tt_result.
    METHODS persist_results IMPORTING it_results TYPE tt_result.
    METHODS add_msg         IMPORTING iv_severity TYPE c DEFAULT 'I'
                                      iv_text     TYPE string.
    METHODS fail_all IMPORTING iv_error   TYPE string
                     CHANGING  ct_results TYPE tt_result.
    METHODS save_appl_log.
  ENDCLASS.



CLASS zcl_product_master_sync IMPLEMENTATION.

  METHOD if_apj_dt_exec_object~get_parameters.
  ENDMETHOD.

  METHOD if_apj_rt_exec_object~execute.
    run_job( ).
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    run_job( ).
    out->write( |Sent OK: { mv_ok }, failed: { mv_failed }| ).
  ENDMETHOD.


  METHOD run_job.
    DATA lt_batch TYPE tt_product.
    DATA lv_to    TYPE i.

    DATA(lv_run_start) = utclong_current( ).   " UTC, captured before selecting
    DATA(lv_since)     = get_watermark( ).

    load_open_errors( ).
    DATA(lt_products) = select_work( lv_since ).

    IF lt_products IS INITIAL.
      set_watermark( lv_run_start ).
      RETURN.
    ENDIF.

    TRY.
        mo_client = cl_web_http_client_manager=>create_by_http_destination(
                      cl_http_destination_provider=>create_by_comm_arrangement(
                        comm_scenario  = 'ZCS_SALES_OCR'
                        comm_system_id = 'SO_HUB_INT'
                        service_id     = 'ZOS_PRODUCT_SYNC_REST' ) ).
      CATCH cx_http_dest_provider_error cx_web_http_client_error INTO DATA(lx_dest).
        add_msg( iv_severity = 'E' iv_text = |Destination error: { lx_dest->get_text( ) }| ).
        save_appl_log( ).
        RETURN.
    ENDTRY.

    DATA(lv_total) = lines( lt_products ).
    DATA(lv_from)  = 1.

    WHILE lv_from <= lv_total.
      lv_to    = nmin( val1 = lv_from + c_batch_size - 1 val2 = lv_total ).
      lt_batch = VALUE #( FOR ls IN lt_products FROM lv_from TO lv_to ( ls ) ).

      persist_results( send_batch( lt_batch ) ).

      lv_from = lv_to + 1.
    ENDWHILE.

    TRY.
        mo_client->close( ).
      CATCH cx_web_http_client_error ##NO_HANDLER.
    ENDTRY.

    set_watermark( lv_run_start ).
    add_msg( iv_text = |Products processed: { lv_total }, OK: { mv_ok }, failed: { mv_failed }| ).
    save_appl_log( ).
  ENDMETHOD.


  METHOD select_work.
    " 1) Delta since last successful run (first run = full load)
    IF iv_since IS INITIAL.
      SELECT FROM zi_product_sync FIELDS * INTO TABLE @rt_products.
    ELSE.
      SELECT FROM zi_product_sync FIELDS *
        WHERE updatedat >= @iv_since
           OR createdat >= @iv_since
        INTO TABLE @rt_products.
    ENDIF.

    " 2) Everything that failed earlier (retry queue)
    SELECT FROM zi_product_sync AS p
      INNER JOIN zi_sync_logs AS l
        ON  l~refobjectkey  = p~synckey
        AND l~refobjecttype = @c_obj_product
      FIELDS p~*
      APPENDING TABLE @rt_products.

    SORT rt_products BY product plant.
    DELETE ADJACENT DUPLICATES FROM rt_products COMPARING product plant.
  ENDMETHOD.

  METHOD send_batch.

    rt_results = VALUE #( FOR ls_1 IN it_batch ( key = ls_1-synckey ok = abap_true ) ).

    DATA(lt_payload) = VALUE tt_payload( FOR ls IN it_batch (
        product                   = ls-product
        plant                     = ls-plant
        product_description       = ls-productdescription
        plant_name                = ls-plantname
        product_type              = ls-producttype
        product_type_description  = ls-producttypename
        product_group             = ls-productgroup
        product_group_description = ls-productgrouptext
        base_unit_of_measure      = ls-baseunit
        meas_unit_text            = ls-unitofmeasurename
        mrp_type                  = ls-mrptype
        valuation_class           = ls-valuationclass
        price_control             = ls-pricedeterminationcontrol
        inventory_price           = ls-standardprice
        currency                  = ls-currency
         ) ).

    DATA(lv_json) = xco_cp_json=>data->from_abap( lt_payload )->apply( VALUE #(
                      ( xco_cp_json=>transformation->underscore_to_pascal_case ) ) )->to_string( ).


    TRY.
        DATA(lo_req) = mo_client->get_http_request( ).
        lo_req->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
        lo_req->set_header_field( i_name = 'Accept'       i_value = 'application/json' ).
        lo_req->set_text( lv_json ).

        DATA(lo_resp)   = mo_client->execute( i_method = if_web_http_client=>post ).
        DATA(lv_status) = lo_resp->get_status( )-code.
        DATA(lv_body)   = lo_resp->get_text( ).
      CATCH cx_web_http_client_error cx_web_message_error INTO DATA(lx_http).
        fail_all( EXPORTING iv_error = |HTTP error: { lx_http->get_text( ) }|
                  CHANGING  ct_results = rt_results ).
        RETURN.
    ENDTRY.


    DATA ls_response TYPE ty_response.
    TRY.
        xco_cp_json=>data->from_string( lv_body )->write_to( REF #( ls_response ) ).
      CATCH cx_root INTO DATA(lx_json).
        fail_all( EXPORTING iv_error = |HTTP { lv_status } / invalid JSON: { lx_json->get_text( ) }|
                  CHANGING  ct_results = rt_results ).
        RETURN.
    ENDTRY.

    DATA(lt_errors) = ls_response-data-error.
    DATA(lv_ok_status) = xsdbool( ls_response-status = c_status_ok
                                  AND lv_status BETWEEN 200 AND 299 ).

    " ---- Case 1: error[] aligned 1:1 with request ('' = success) ----
    IF lines( lt_errors ) = lines( rt_results ).
      LOOP AT lt_errors INTO DATA(lv_item_err).
        DATA(lv_idx) = sy-tabix.
        rt_results[ lv_idx ]-ok    = xsdbool( lv_item_err IS INITIAL ).
        rt_results[ lv_idx ]-error = lv_item_err.
      ENDLOOP.
      RETURN.
    ENDIF.

    " ---- Case 2: no item errors -> decide on status/message ----
    IF lt_errors IS INITIAL.
      IF lv_ok_status = abap_false.
        fail_all( EXPORTING iv_error = |HTTP { lv_status } { ls_response-status }: { ls_response-message }|
                  CHANGING  ct_results = rt_results ).
      ENDIF.
      RETURN.                              " otherwise all rows stay OK
    ENDIF.

    " ---- Case 3: only failed items listed -> match error text to rows ----
    DATA lt_unmatched TYPE STANDARD TABLE OF string WITH EMPTY KEY.

    LOOP AT lt_errors INTO lv_item_err WHERE table_line IS NOT INITIAL.
      DATA(lv_matched) = abap_false.
      LOOP AT it_batch INTO DATA(ls_row).
        DATA(lv_row) = sy-tabix.
        IF lv_item_err CS ls_row-product AND lv_item_err CS ls_row-plant.
          ASSIGN rt_results[ lv_row ] TO FIELD-SYMBOL(<ls_res>).
          <ls_res>-ok    = abap_false.
          <ls_res>-error = COND #( WHEN <ls_res>-error IS INITIAL THEN lv_item_err
                                   ELSE |{ <ls_res>-error }; { lv_item_err }| ).
          lv_matched = abap_true.
        ENDIF.
      ENDLOOP.
      IF lv_matched = abap_false.
        APPEND lv_item_err TO lt_unmatched.
      ENDIF.
    ENDLOOP.

    " Errors we couldn't attribute -> don't trust the "OK" rows, retry them next run
    IF lt_unmatched IS NOT INITIAL.
      DATA(lv_unmatched_txt) = concat_lines_of( table = lt_unmatched sep = '; ' ).
      LOOP AT rt_results ASSIGNING <ls_res> WHERE ok = abap_true.
        <ls_res>-ok    = abap_false.
        <ls_res>-error = |Unattributed batch error: { lv_unmatched_txt }|.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD fail_all.
    LOOP AT ct_results ASSIGNING FIELD-SYMBOL(<ls_res>).
      <ls_res>-ok    = abap_false.
      <ls_res>-error = iv_error.
    ENDLOOP.
  ENDMETHOD.

  METHOD persist_results.
    DATA lt_create TYPE TABLE FOR CREATE zi_sync_logs.
    DATA lt_update TYPE TABLE FOR UPDATE zi_sync_logs.
    DATA lt_delete TYPE TABLE FOR DELETE zi_sync_logs.

    LOOP AT it_results INTO DATA(ls_res).
      IF ls_res-ok = abap_true.
        mv_ok += 1.
        " success -> clear any old error entries for this key
        LOOP AT mt_open_errors INTO DATA(ls_err) WHERE refobjectkey = ls_res-key.
          APPEND VALUE #( uuid = ls_err-uuid ) TO lt_delete.
        ENDLOOP.
      ELSE.
        mv_failed += 1.
        READ TABLE mt_open_errors INTO ls_err WITH TABLE KEY refobjectkey = ls_res-key.
        IF sy-subrc = 0.
          APPEND VALUE #( uuid = ls_err-uuid errorlog = ls_res-error ) TO lt_update.
        ELSE.
          APPEND VALUE #( refobjecttype = c_obj_product
                          refobjectkey  = ls_res-key
                          errorlog      = ls_res-error ) TO lt_create.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lt_create IS INITIAL AND lt_update IS INITIAL AND lt_delete IS INITIAL.
      RETURN.
    ENDIF.

    MODIFY ENTITIES OF zi_sync_logs
      ENTITY zrsynclogs
        CREATE FIELDS ( refobjecttype refobjectkey errorlog ) AUTO FILL CID WITH lt_create
        UPDATE FIELDS ( errorlog ) WITH lt_update
        DELETE FROM lt_delete
      FAILED   DATA(ls_failed)
      REPORTED DATA(ls_reported).

    COMMIT ENTITIES RESPONSE OF zi_sync_logs
      FAILED   DATA(ls_failed_c)
      REPORTED DATA(ls_reported_c).

    IF ls_failed IS NOT INITIAL OR ls_failed_c IS NOT INITIAL.
      add_msg( iv_severity = 'E' iv_text = |Could not save sync logs for a batch| ).
    ENDIF.
  ENDMETHOD.


  METHOD load_open_errors.
    SELECT FROM zi_sync_logs
      FIELDS uuid, refobjectkey
      WHERE refobjecttype = @c_obj_product
      INTO CORRESPONDING FIELDS OF TABLE @mt_open_errors.
  ENDMETHOD.


  METHOD get_watermark.
    SELECT SINGLE FROM zi_sync_logs
      FIELDS MAX( synctimestamp )
      WHERE refobjecttype = @c_obj_lastsync
        AND refobjectkey  = @c_key_lastsync
      INTO @rv_since.
  ENDMETHOD.


  METHOD set_watermark.

    SELECT SINGLE FROM zi_sync_logs FIELDS uuid
      WHERE refobjecttype = @c_obj_lastsync
        AND refobjectkey  = @c_key_lastsync
      INTO @DATA(lv_uuid).

    IF lv_uuid IS INITIAL.
      MODIFY ENTITIES OF zi_sync_logs ENTITY zrsynclogs
        CREATE FIELDS ( refobjecttype refobjectkey synctimestamp ) AUTO FILL CID
        WITH VALUE #( ( refobjecttype = c_obj_lastsync
                        refobjectkey  = c_key_lastsync
                        synctimestamp = iv_ts ) ).
    ELSE.
      MODIFY ENTITIES OF zi_sync_logs ENTITY zrsynclogs
        UPDATE FIELDS ( synctimestamp )
        WITH VALUE #( ( uuid = lv_uuid synctimestamp = iv_ts ) ).
    ENDIF.

    COMMIT ENTITIES.
  ENDMETHOD.


  METHOD add_msg.
    TRY.
        IF mo_log IS NOT BOUND.
          mo_log = cl_bali_log=>create_with_header(
                     cl_bali_header_setter=>create( object    = 'ZPRODUCT_SYNC'
                                                    subobject = 'OUTBOUND' ) ).
        ENDIF.
        mo_log->add_item( cl_bali_free_text_setter=>create( severity = iv_severity
                                                            text     = CONV #( iv_text ) ) ).
      CATCH cx_bali_runtime ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.


  METHOD save_appl_log.
    CHECK mo_log IS BOUND.
    TRY.
        cl_bali_log_db=>get_instance( )->save_log( log                        = mo_log
                                                   assign_to_current_appl_job = abap_true ).
        COMMIT WORK.
      CATCH cx_bali_runtime ##NO_HANDLER.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
