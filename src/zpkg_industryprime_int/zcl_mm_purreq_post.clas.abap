CLASS zcl_mm_purreq_post DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'INVENT'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'Inventory data'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PURREQ_ALOG_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_PURREQ_ALOGS_01'.

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



CLASS ZCL_MM_PURREQ_POST IMPLEMENTATION.


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
                               header = cl_bali_header_setter=>create( object = 'ZAPP_PURREQ_01_LOG'
                                                                       subobject = 'ZAPP_PURREQ_01_SUB'
                                                                       external_id = 'Pur. Req. IP' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.

  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.


  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.


**********************************************************************
*--API Structure
*    TYPES: BEGIN OF lty_lineitemindent,
*             item_check      TYPE i_supplier-supplierfullname,
*             name            TYPE i_supplier-supplierfullname,
*             hsn             TYPE i_supplier-supplierfullname,
*             lead            TYPE i_supplier-supplierfullname,
*             uom_i           TYPE i_supplier-supplierfullname,
*             uom_p           TYPE i_supplier-supplierfullname,
*             uom_s           TYPE i_supplier-supplierfullname,
*             itemgroup_code  TYPE i_supplier-supplierfullname,
*             itemgroup_name  TYPE i_supplier-supplierfullname,
*             costcentrename  TYPE i_supplier-supplierfullname,
*             costcentrecode  TYPE i_supplier-supplierfullname,
*             quantity        TYPE i_supplier-supplierfullname,
*             price           TYPE i_supplier-supplierfullname,
*             description     TYPE i_supplier-supplierfullname,
*             requirementdate TYPE i_supplier-supplierfullname,
*             acctcode        TYPE i_supplier-supplierfullname,
*             ocr2            TYPE i_supplier-supplierfullname,
*             ocr3            TYPE i_supplier-supplierfullname,
*             ocr4            TYPE i_supplier-supplierfullname,
*             project         TYPE i_supplier-supplierfullname,
*             u_itnewdes      TYPE i_supplier-supplierfullname,
*             u_rnohead       TYPE i_supplier-supplierfullname,
*             doc_itemno      TYPE i_supplier-supplierfullname,
*             pr_delete       TYPE i_supplier-supplierfullname,
*             pr_process      TYPE i_supplier-supplierfullname,
*             itemtext        TYPE string,
*           END OF lty_lineitemindent.
*
*    DATA: BEGIN OF ls_allindent,
*            warehousecode    TYPE i_supplier-supplierfullname,
*            warehousename    TYPE i_supplier-supplierfullname,
*            warehousestreet  TYPE i_supplier-supplierfullname,
*            warehouseblock   TYPE i_supplier-supplierfullname,
*            warehousecity    TYPE i_supplier-supplierfullname,
*            warehousezipcode TYPE i_supplier-supplierfullname,
*            doc              TYPE i_supplier-supplierfullname,
*            docdue           TYPE i_supplier-supplierfullname,
*            tax              TYPE i_supplier-supplierfullname,
*            create           TYPE i_supplier-supplierfullname,
*            update           TYPE i_supplier-supplierfullname,
*            req              TYPE i_supplier-supplierfullname,
*            remark           TYPE i_supplier-supplierfullname,
*            doc_num          TYPE i_supplier-supplierfullname,
*            sec              TYPE i_supplier-supplierfullname,
*            dep              TYPE i_supplier-supplierfullname,
*            branch           TYPE i_supplier-supplierfullname,
*            code             TYPE i_supplier-supplierfullname,
*            name             TYPE i_supplier-supplierfullname,
*            mobile           TYPE i_supplier-supplierfullname,
*            indents_length   TYPE i_supplier-supplierfullname,
*            item             TYPE TABLE OF lty_lineitemindent,
*          END OF ls_allindent.
*
*    TYPES : BEGIN OF ty_log,
*              purchaserequisition     TYPE i_supplier-supplierfullname,
*              purchaserequisitionitem TYPE i_supplier-supplierfullname,
*              textobjectcategory      TYPE i_supplier-supplierfullname,
*              textobjecttype          TYPE i_supplier-supplierfullname,
*              language                TYPE i_supplier-supplierfullname,
*              plainlongtext           TYPE i_supplier-supplierfullname,
*            END OF ty_log.
*
*    TYPES : BEGIN OF ty_id,
*              id TYPE i_supplier-supplierfullname,
*            END OF ty_id.
*    DATA: log   TYPE TABLE OF ty_log,
*          ls_id TYPE ty_id.
*
*    DATA: lv_date_start TYPE datum, "datum,
*          lv_date_end   TYPE datum,
*          lv_time_end   TYPE timn,
*          lv_time_begin TYPE timn,
*          lv_json       TYPE string,
*          lt_pr         TYPE TABLE OF zdt_ip_pr.
*
*    DATA: lv_atom_xml     TYPE string,
*          lv_abap_xml     TYPE string,
*          lt_final_xml    TYPE TABLE OF string,
*          lv_final_xml    TYPE string,
*          lt_entries      TYPE TABLE OF string,
*          lv_entry1       TYPE string,
*          lv_longtext     TYPE string,
*          lv_start_pos    TYPE i,                    " Start position for extracting values
*          lv_end_pos      TYPE i,                      " End position for extracting values
*          lv_substr       TYPE string,                  " Temp variable for extracted value
*          lv_length       TYPE i,
*          lt_atom_entries TYPE TABLE OF string,
*          lt_pr_logs      TYPE TABLE OF zdt_ip_pr_logs,
*          l_length        TYPE string,
*          l_docnum        TYPE string,
*          lv_minutes      TYPE f,
*          gt_params       TYPE REF TO cl_scal_api.
*
***********************************************************************
**Initialization
*    lv_date_end = cl_abap_context_info=>get_system_date( ) .
*    lv_time_end = cl_abap_context_info=>get_system_time( ) .
*    lv_minutes  = 180.
*
*
*    CREATE OBJECT gt_params. " Create instance of CL_SCAL_API
*
*    gt_params->start_time_determine(
*      EXPORTING
*        iv_duration = lv_minutes
*        iv_unit     = 'MIN'
*      IMPORTING
*        ev_start_date = lv_date_start
*        ev_start_time = lv_time_begin
*      CHANGING
*       cv_end_date = lv_date_end
*       cv_end_time = lv_time_end   ).
*
*
**    SELECT *
**    FROM zmm_ip_pr
**    WHERE ( ( datesdoc BETWEEN @lv_date_start AND @lv_date_end )
**    OR ( lastchangedate BETWEEN @lv_date_start AND @lv_date_end ) )
**    INTO TABLE @DATA(lt_prdata).
*
*    SELECT *
*    FROM zmm_ip_pr
*    WHERE ( lastchangedate BETWEEN @lv_date_start AND @lv_date_end )
*    INTO TABLE @DATA(lt_prdata).
*
*    IF sy-subrc = 0.
*
*      DELETE lt_prdata WHERE lastchangedate = lv_date_start AND lastchangetime LT lv_time_begin.
*      DELETE lt_prdata WHERE lastchangedate = lv_date_end AND lastchangetime GT lv_time_end.
*      SORT lt_prdata BY doc_num.
*      IF lt_prdata IS NOT INITIAL.
**Fetch Business Partner Address
*        SELECT businesspartner,
*               addressnumber,
*               streetname,
*               streetsuffixname,
*               additionalstreetsuffixname
*            FROM i_businesspartneraddresstp_3
*            FOR ALL ENTRIES IN @lt_prdata
*            WHERE businesspartner = @lt_prdata-customer
*            INTO TABLE @DATA(lt_bpaddr).
*        IF sy-subrc = 0.
*          SORT lt_bpaddr BY businesspartner.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
*    SELECT a~purreq FROM zdt_ip_pr AS a
*    INNER JOIN @lt_prdata AS b ON b~doc_num = a~purreq
*    INTO TABLE @DATA(lt_req).
*
*
*    DATA(lt_prdata_h) = lt_prdata.
*    SORT lt_prdata_h BY doc_num.
*    DELETE ADJACENT DUPLICATES FROM lt_prdata_h COMPARING doc_num.
*
*    LOOP AT lt_prdata_h ASSIGNING FIELD-SYMBOL(<lfs_prdata>).
*
*      ls_allindent-warehousecode = <lfs_prdata>-warehousecode.
*      ls_allindent-warehousename = <lfs_prdata>-warehousename.
*      ls_allindent-warehousestreet = <lfs_prdata>-warehousestreet.
*      ls_allindent-warehousecity = <lfs_prdata>-warehousecity.
*      ls_allindent-warehousezipcode = <lfs_prdata>-warehousezipcode.
*      ls_allindent-warehouseblock = 'Block'.
*      ls_allindent-doc = COND #( WHEN <lfs_prdata>-datesdoc IS NOT INITIAL
*      THEN <lfs_prdata>-datesdoc+0(4) && '-' && <lfs_prdata>-datesdoc+4(2) && '-' && <lfs_prdata>-datesdoc+6(2) ELSE '' ).
*      ls_allindent-req = COND #( WHEN <lfs_prdata>-datesreq IS NOT INITIAL
*      THEN <lfs_prdata>-datesreq+0(4) && '-' && <lfs_prdata>-datesreq+4(2) && '-' && <lfs_prdata>-datesreq+6(2) ELSE '' ).
*      ls_allindent-remark = <lfs_prdata>-remark.
*      ls_allindent-doc_num = <lfs_prdata>-doc_num.
*      l_docnum = ls_allindent-doc_num.
*      ls_allindent-code = <lfs_prdata>-bycode.
*      ls_allindent-name = COND #( WHEN <lfs_prdata>-byname IS NOT INITIAL THEN <lfs_prdata>-byname ELSE 'Dummy' ).
*
*      DATA(lt_prdata_i) = lt_prdata.
*      DELETE lt_prdata_i WHERE doc_num <> <lfs_prdata>-doc_num.
*      ls_allindent-indents_length = lines( lt_prdata_i ).
*      CONDENSE: ls_allindent-indents_length.
*      l_length = ls_allindent-indents_length.
*      CLEAR: lt_prdata_i.
*
*      DATA(ls_bpaddr) = VALUE #( lt_bpaddr[ businesspartner = <lfs_prdata>-customer ] OPTIONAL ).
*      IF ls_bpaddr IS NOT INITIAL.
*        ls_allindent-warehouseblock = ls_bpaddr-streetsuffixname.
*      ENDIF.
*      CLEAR: ls_bpaddr.
*      "Get Item Text
*      DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).
*
*      lo_factory->query_ca(
*        EXPORTING
*          is_query = VALUE #( cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZCS_SAP_COM_0102' ) ) ) " Custom Communication Scenario
*        IMPORTING
*          et_com_arrangement = DATA(lt_comm_arrang) ).
*
*      DATA(lo_comm_arrang) = lt_comm_arrang[ 1 ].
*
*      TRY.
*          DATA(lo_destination1) = cl_http_destination_provider=>create_by_comm_arrangement(
*            comm_scenario  = CONV #( 'ZCS_SAP_COM_0102' )" Use Custom Communicaiton Scenario, Not standard!
*            comm_system_id = lo_comm_arrang->get_comm_system_id( )
*            service_id     = CONV #( 'ZOS_PURREQ_REST' )" Outbound Service ID
*          ).
*        CATCH cx_http_dest_provider_error INTO DATA(lo_error).
*          DATA(lv_message) = lo_error->get_longtext( ).
*      ENDTRY.
*
*      TRY.
*          DATA(eo_client1) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination1 ).
*        CATCH cx_web_http_client_error.
*      ENDTRY.
*
*      DATA(eo_request1) = eo_client1->get_http_request( ).
*      eo_request1->set_content_type( content_type = |application/json| ).
*
*      "DATA(lv_path) = |/PurchaseReqnItem/{ ls_prdata-doc_num }/{ ls_prdata-doc_num_item }/_PurchaseReqnItemText|.
*      DATA(lv_path) = |/PurchaseReqnItemText?$filter=PurchaseRequisition eq '{ <lfs_prdata>-doc_num }'|.
*      eo_request1->set_uri_path( i_uri_path = lv_path ).
*
*      TRY.
*          DATA(lo_response) = eo_client1->execute( i_method = if_web_http_client=>get ).
*        CATCH cx_web_http_client_error.
*      ENDTRY.
*
*      DATA(lv_resp_satus) = lo_response->get_status( ).
*      DATA(lv_resp_text) = lo_response->get_text( ).
*
*      SPLIT lv_resp_text AT '"value":' INTO DATA(l_a) DATA(l_b).
*      DATA(l_len) = strlen(  l_b ).
*      l_len = l_len - 1.
*      DATA(l_final) = l_b+0(l_len).
*      /ui2/cl_json=>deserialize( EXPORTING json = l_final CHANGING data = log  ).
*
*      LOOP AT lt_prdata INTO DATA(ls_prdata) WHERE doc_num = <lfs_prdata>-doc_num.
*        APPEND INITIAL LINE TO ls_allindent-item ASSIGNING FIELD-SYMBOL(<lfs_item>).
*        <lfs_item>-item_check = ls_prdata-item_check.
*        <lfs_item>-name = ls_prdata-item_name.
*        <lfs_item>-hsn = ls_prdata-hsn.
*        <lfs_item>-lead = COND #( WHEN ls_prdata-datesreq IS NOT INITIAL
*        THEN ls_prdata-datesreq+0(4) && '-' && ls_prdata-datesreq+4(2) && '-' && ls_prdata-datesreq+6(2) ELSE '' ).
*        <lfs_item>-uom_i = ls_prdata-uom_i.
*        <lfs_item>-itemgroup_code = ls_prdata-itemgroup_code.
*        <lfs_item>-itemgroup_name = ls_prdata-itemgroup_name.
*        <lfs_item>-costcentrecode = ls_prdata-costcentercode.
*        <lfs_item>-costcentrename = ls_prdata-costcentername.
*        <lfs_item>-quantity = ls_prdata-quantity.
*        <lfs_item>-price = ls_prdata-price.
*        CONDENSE: <lfs_item>-quantity,<lfs_item>-price.
*        <lfs_item>-description = ls_prdata-description.
*        <lfs_item>-requirementdate = COND #( WHEN ls_prdata-datesreq IS NOT INITIAL
*        THEN ls_prdata-datesreq+0(4) && '-' && ls_prdata-datesreq+4(2) && '-' && ls_prdata-datesreq+6(2) ELSE '' ).
*        <lfs_item>-doc_itemno      = ls_prdata-doc_num_item.
*        <lfs_item>-pr_delete       = ls_prdata-deleted.
*        <lfs_item>-pr_process      = ls_prdata-process.
*
*        DATA(lv_pritem) = |{ ls_prdata-doc_num_item ALPHA = OUT }|.
*        READ TABLE log INTO DATA(ls_log) WITH KEY purchaserequisitionitem = lv_pritem "ls_prdata-doc_num_item
*                                                  textobjectcategory = 'EBAN' textobjecttype = 'B01' language = 'EN'.
*        IF ls_log IS NOT INITIAL.
*          <lfs_item>-itemtext = ls_log-plainlongtext.
*        ENDIF.
*        CLEAR : ls_log, lv_pritem.
*
*        "End o Item Text
*      ENDLOOP.
*
*      lv_json = /ui2/cl_json=>serialize( EXPORTING data = ls_allindent pretty_name = 'X' ).
*      TRY.
*          FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                      comm_scenario = 'ZCS_INDENTIP'
*                                      service_id    = 'ZOS_PR_REST' ).
*          FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
*          FINAL(lo_request) = lo_http_client->get_http_request( ).
*          lo_request->set_content_type( content_type = |application/json| ).
*          READ TABLE lt_req INTO DATA(ls_req) WITH KEY purreq = <lfs_prdata>-doc_num.
*          IF ls_req-purreq IS NOT INITIAL.
*            lo_request->set_header_field(  i_name = 'Edit' i_value = 'X' ).
*          ELSE.
*            lo_request->set_header_field(  i_name = 'Edit' i_value = '' ).
*          ENDIF.
*          lo_request->set_header_field(  i_name = 'Length' i_value = l_length ).
*          lo_request->set_header_field(  i_name = 'PR' i_value = l_docnum ).
*          lo_request->set_text( lv_json ).
*          FINAL(ls_text) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
*          IF ls_text CS '"id"'. "Success
*            /ui2/cl_json=>deserialize( EXPORTING json = ls_text CHANGING data = ls_id  ).
*            APPEND VALUE #( purreq = <lfs_prdata>-doc_num createdon = sy-datlo prip = ls_id-id ) TO lt_pr.
*            APPEND VALUE #( purreq = <lfs_prdata>-doc_num createdon = sy-datlo createdat = sy-timlo
*                            payload = lv_json response = ls_text ) TO lt_pr_logs.
*          ELSE.
*            APPEND VALUE #( purreq = <lfs_prdata>-doc_num createdon = sy-datlo createdat = sy-timlo
*                            payload = lv_json response = ls_text ) TO lt_pr_logs.
*          ENDIF.
*          lo_http_client->close( ).
*          CLEAR lv_json.
*          CLEAR : ls_req.
*        CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error).
*        CATCH cx_web_http_client_error INTO FINAL(web_http_client_error).
*      ENDTRY.
*
*      CLEAR: ls_allindent,ls_allindent-item[].
*      CLEAR : lo_factory, lt_comm_arrang[], lo_comm_arrang, lv_message, eo_client1, lv_resp_satus, lv_resp_text,
*                lv_atom_xml, lv_abap_xml, lt_final_xml[], lv_final_xml, lt_entries[], lv_entry1, lv_longtext, lv_start_pos,
*                lv_end_pos, lv_substr, lv_length, lt_atom_entries[].
*    ENDLOOP.
*
*    IF lt_pr[] IS NOT INITIAL.
*      MODIFY zdt_ip_pr FROM TABLE @lt_pr[].
*      COMMIT WORK AND WAIT.
*    ENDIF.
*
*    IF lt_pr_logs[] IS NOT INITIAL.
*      MODIFY zdt_ip_pr_logs FROM TABLE @lt_pr_logs[].
*      COMMIT WORK AND WAIT.
*    ENDIF.


 TYPES: BEGIN OF lty_lineitemindent,
             item_check      TYPE i_supplier-supplierfullname,
             name            TYPE i_supplier-supplierfullname,
             hsn             TYPE i_supplier-supplierfullname,
             lead            TYPE i_supplier-supplierfullname,
             uom_i           TYPE i_supplier-supplierfullname,
             uom_p           TYPE i_supplier-supplierfullname,
             uom_s           TYPE i_supplier-supplierfullname,
             itemgroup_code  TYPE i_supplier-supplierfullname,
             itemgroup_name  TYPE i_supplier-supplierfullname,
             costcentrename  TYPE i_supplier-supplierfullname,
             costcentrecode  TYPE i_supplier-supplierfullname,
             quantity        TYPE i_supplier-supplierfullname,
             price           TYPE i_supplier-supplierfullname,
             description     TYPE i_supplier-supplierfullname,
             requirementdate TYPE i_supplier-supplierfullname,
             acctcode        TYPE i_supplier-supplierfullname,
             ocr2            TYPE i_supplier-supplierfullname,
             ocr3            TYPE i_supplier-supplierfullname,
             ocr4            TYPE i_supplier-supplierfullname,
             project         TYPE i_supplier-supplierfullname,
             u_itnewdes      TYPE i_supplier-supplierfullname,
             u_rnohead       TYPE i_supplier-supplierfullname,
             doc_itemno      TYPE i_supplier-supplierfullname,
             pr_delete       TYPE i_supplier-supplierfullname,
             pr_process      TYPE i_supplier-supplierfullname,
             itemtext        TYPE string,
           END OF lty_lineitemindent.

    DATA: BEGIN OF ls_allindent,
            warehousecode    TYPE i_supplier-supplierfullname,
            warehousename    TYPE i_supplier-supplierfullname,
            warehousestreet  TYPE i_supplier-supplierfullname,
            warehouseblock   TYPE i_supplier-supplierfullname,
            warehousecity    TYPE i_supplier-supplierfullname,
            warehousezipcode TYPE i_supplier-supplierfullname,
            doc              TYPE i_supplier-supplierfullname,
            docdue           TYPE i_supplier-supplierfullname,
            tax              TYPE i_supplier-supplierfullname,
            create           TYPE i_supplier-supplierfullname,
            update           TYPE i_supplier-supplierfullname,
            req              TYPE i_supplier-supplierfullname,
            remark           TYPE i_supplier-supplierfullname,
            doc_num          TYPE i_supplier-supplierfullname,
            sec              TYPE i_supplier-supplierfullname,
            dep              TYPE i_supplier-supplierfullname,
            branch           TYPE i_supplier-supplierfullname,
            code             TYPE i_supplier-supplierfullname,
            name             TYPE i_supplier-supplierfullname,
            mobile           TYPE i_supplier-supplierfullname,
            indents_length   TYPE i_supplier-supplierfullname,
            item             TYPE TABLE OF lty_lineitemindent,
          END OF ls_allindent.

    TYPES : BEGIN OF ty_log,
              purchaserequisition     TYPE i_supplier-supplierfullname,
              purchaserequisitionitem TYPE i_supplier-supplierfullname,
              textobjectcategory      TYPE i_supplier-supplierfullname,
              textobjecttype          TYPE i_supplier-supplierfullname,
              language                TYPE i_supplier-supplierfullname,
              plainlongtext           TYPE i_supplier-supplierfullname,
            END OF ty_log.

    TYPES : BEGIN OF ty_id,
              id TYPE i_supplier-supplierfullname,
            END OF ty_id.
    DATA: log   TYPE TABLE OF ty_log,
          ls_id TYPE ty_id.

    DATA: lv_date_start TYPE datum,
          lv_date_end   TYPE datum,
          lv_time_end   TYPE timn,
          lv_time_begin TYPE timn,
          lv_json       TYPE string,
          lt_pr         TYPE TABLE OF zdt_ip_pr.

    DATA: lv_atom_xml     TYPE string,
          lv_abap_xml     TYPE string,
          lt_final_xml    TYPE TABLE OF string,
          lv_final_xml    TYPE string,
          lt_entries      TYPE TABLE OF string,
          lv_entry1       TYPE string,
          lv_longtext     TYPE string,
          lv_start_pos    TYPE i,                    " Start position for extracting values
          lv_end_pos      TYPE i,                      " End position for extracting values
          lv_substr       TYPE string,                  " Temp variable for extracted value
          lv_length       TYPE i,
          lt_atom_entries TYPE TABLE OF string,
          lt_pr_logs      TYPE TABLE OF zdt_ip_pr_logs,
          l_length        TYPE string,
          l_docnum        TYPE string,
          lv_minutes      TYPE f,
          gt_params       TYPE REF TO cl_scal_api.

**********************************************************************
*Initialization
    lv_date_end = cl_abap_context_info=>get_system_date( ) .
    lv_time_end = cl_abap_context_info=>get_system_time( ) .
    lv_minutes  = 180.


    CREATE OBJECT gt_params. " Create instance of CL_SCAL_API

    gt_params->start_time_determine(
      EXPORTING
        iv_duration = lv_minutes
        iv_unit     = 'MIN'
      IMPORTING
        ev_start_date = lv_date_start
        ev_start_time = lv_time_begin
      CHANGING
       cv_end_date = lv_date_end
       cv_end_time = lv_time_end   ).


*    SELECT *
*    FROM zmm_ip_pr
*    WHERE ( ( datesdoc BETWEEN @lv_date_start AND @lv_date_end )
*    OR ( lastchangedate BETWEEN @lv_date_start AND @lv_date_end ) )
*    INTO TABLE @DATA(lt_prdata).

    SELECT *
    FROM zmm_ip_pr
    WHERE ( lastchangedate BETWEEN @lv_date_start AND @lv_date_end )
    INTO TABLE @DATA(lt_prdata).

    IF sy-subrc = 0.


      DELETE lt_prdata WHERE lastchangedate = lv_date_start AND lastchangetime LT lv_time_begin.
      DELETE lt_prdata WHERE lastchangedate = lv_date_end AND lastchangetime GT lv_time_end.
      SORT lt_prdata BY doc_num.

      IF lt_prdata[] IS NOT INITIAL.

*Fetch Business Partner Address
        SELECT businesspartner,
               addressnumber,
               streetname,
               streetsuffixname,
               additionalstreetsuffixname
            FROM i_businesspartneraddresstp_3
            FOR ALL ENTRIES IN @lt_prdata
            WHERE businesspartner = @lt_prdata-customer
            INTO TABLE @DATA(lt_bpaddr).
        IF sy-subrc = 0.
          SORT lt_bpaddr BY businesspartner.
        ENDIF.
      ENDIF.
    ENDIF.

    SELECT a~purreq FROM zdt_ip_pr AS a
    INNER JOIN @lt_prdata AS b ON b~doc_num = a~purreq
    INTO TABLE @DATA(lt_req).


    DATA(lt_prdata_h) = lt_prdata.
    SORT lt_prdata_h BY doc_num.
    DELETE ADJACENT DUPLICATES FROM lt_prdata_h COMPARING doc_num.

    LOOP AT lt_prdata_h ASSIGNING FIELD-SYMBOL(<lfs_prdata>).

      ls_allindent-warehousecode = <lfs_prdata>-warehousecode.
      ls_allindent-warehousename = <lfs_prdata>-warehousename.
      ls_allindent-warehousestreet = <lfs_prdata>-warehousestreet.
      ls_allindent-warehousecity = <lfs_prdata>-warehousecity.
      ls_allindent-warehousezipcode = <lfs_prdata>-warehousezipcode.
      ls_allindent-warehouseblock = 'Block'.
      ls_allindent-doc = COND #( WHEN <lfs_prdata>-datesdoc IS NOT INITIAL
      THEN <lfs_prdata>-datesdoc+0(4) && '-' && <lfs_prdata>-datesdoc+4(2) && '-' && <lfs_prdata>-datesdoc+6(2) ELSE '' ).
      ls_allindent-req = COND #( WHEN <lfs_prdata>-datesreq IS NOT INITIAL
      THEN <lfs_prdata>-datesreq+0(4) && '-' && <lfs_prdata>-datesreq+4(2) && '-' && <lfs_prdata>-datesreq+6(2) ELSE '' ).
      ls_allindent-remark = <lfs_prdata>-remark.
      ls_allindent-doc_num = <lfs_prdata>-doc_num.
      l_docnum = ls_allindent-doc_num.
      ls_allindent-code = <lfs_prdata>-bycode.
      ls_allindent-name = COND #( WHEN <lfs_prdata>-byname IS NOT INITIAL THEN <lfs_prdata>-byname ELSE 'Dummy' ).

      DATA(lt_prdata_i) = lt_prdata.
      DELETE lt_prdata_i WHERE doc_num <> <lfs_prdata>-doc_num.
      ls_allindent-indents_length = lines( lt_prdata_i ).
      CONDENSE: ls_allindent-indents_length.
      l_length = ls_allindent-indents_length.
      CLEAR: lt_prdata_i.

      DATA(ls_bpaddr) = VALUE #( lt_bpaddr[ businesspartner = <lfs_prdata>-customer ] OPTIONAL ).
      IF ls_bpaddr IS NOT INITIAL.
        ls_allindent-warehouseblock = ls_bpaddr-streetsuffixname.
      ENDIF.
      CLEAR: ls_bpaddr.
      "Get Item Text
*      DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).
*
*      lo_factory->query_ca(
*        EXPORTING
*          is_query = VALUE #( cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZCS_SAP_COM_0102' ) ) ) " Custom Communication Scenario
*        IMPORTING
*          et_com_arrangement = DATA(lt_comm_arrang) ).
*
*      DATA(lo_comm_arrang) = lt_comm_arrang[ 1 ].
*
*      TRY.
*          DATA(lo_destination1) = cl_http_destination_provider=>create_by_comm_arrangement(
*            comm_scenario  = CONV #( 'ZCS_SAP_COM_0102' )" Use Custom Communicaiton Scenario, Not standard!
*            comm_system_id = lo_comm_arrang->get_comm_system_id( )
*            service_id     = CONV #( 'ZOS_PURREQ_REST' )" Outbound Service ID
*          ).
*        CATCH cx_http_dest_provider_error INTO DATA(lo_error).
*          DATA(lv_message) = lo_error->get_longtext( ).
*      ENDTRY.
*
*      TRY.
*          DATA(eo_client1) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination1 ).
*        CATCH cx_web_http_client_error.
*      ENDTRY.
*
*      DATA(eo_request1) = eo_client1->get_http_request( ).
*      eo_request1->set_content_type( content_type = |application/json| ).
*
*      "DATA(lv_path) = |/PurchaseReqnItem/{ ls_prdata-doc_num }/{ ls_prdata-doc_num_item }/_PurchaseReqnItemText|.
*      DATA(lv_path) = |/PurchaseReqnItemText?$filter=PurchaseRequisition eq '{ <lfs_prdata>-doc_num }'|.
*      eo_request1->set_uri_path( i_uri_path = lv_path ).
*
*      TRY.
*          DATA(lo_response) = eo_client1->execute( i_method = if_web_http_client=>get ).
*        CATCH cx_web_http_client_error.
*      ENDTRY.
*
*      DATA(lv_resp_satus) = lo_response->get_status( ).
*      DATA(lv_resp_text) = lo_response->get_text( ).
*
*      SPLIT lv_resp_text AT '"value":' INTO DATA(l_a) DATA(l_b).
*      DATA(l_len) = strlen(  l_b ).
*      l_len = l_len - 1.
*      DATA(l_final) = l_b+0(l_len).
*      /ui2/cl_json=>deserialize( EXPORTING json = l_final CHANGING data = log  ).

      LOOP AT lt_prdata INTO DATA(ls_prdata) WHERE doc_num = <lfs_prdata>-doc_num.
        APPEND INITIAL LINE TO ls_allindent-item ASSIGNING FIELD-SYMBOL(<lfs_item>).
        <lfs_item>-item_check = ls_prdata-item_check.
        <lfs_item>-name = ls_prdata-item_name.
        <lfs_item>-hsn = ls_prdata-hsn.
        <lfs_item>-lead = COND #( WHEN ls_prdata-datesreq IS NOT INITIAL
        THEN ls_prdata-datesreq+0(4) && '-' && ls_prdata-datesreq+4(2) && '-' && ls_prdata-datesreq+6(2) ELSE '' ).
        <lfs_item>-uom_i = ls_prdata-uom_i.
        <lfs_item>-itemgroup_code = ls_prdata-itemgroup_code.
        <lfs_item>-itemgroup_name = ls_prdata-itemgroup_name.
        <lfs_item>-costcentrecode = ls_prdata-costcentercode.
        <lfs_item>-costcentrename = ls_prdata-costcentername.
        <lfs_item>-quantity = ls_prdata-quantity.
        <lfs_item>-price = ls_prdata-price.
        CONDENSE: <lfs_item>-quantity,<lfs_item>-price.
        <lfs_item>-description = ls_prdata-description.
        <lfs_item>-requirementdate = COND #( WHEN ls_prdata-datesreq IS NOT INITIAL
        THEN ls_prdata-datesreq+0(4) && '-' && ls_prdata-datesreq+4(2) && '-' && ls_prdata-datesreq+6(2) ELSE '' ).
        <lfs_item>-doc_itemno      = ls_prdata-doc_num_item.
        <lfs_item>-pr_delete       = ls_prdata-deleted.
        <lfs_item>-pr_process      = ls_prdata-process.

        DATA(lv_pritem) = |{ ls_prdata-doc_num_item ALPHA = OUT }|.
*        READ TABLE log INTO DATA(ls_log) WITH KEY purchaserequisitionitem = lv_pritem "ls_prdata-doc_num_item
*                                                  textobjectcategory = 'EBAN' textobjecttype = 'B01' language = 'EN'.
*        IF ls_log IS NOT INITIAL.
*          <lfs_item>-itemtext = ls_log-plainlongtext.
*        ENDIF.
        CLEAR :  lv_pritem.

        "End o Item Text
      ENDLOOP.

      lv_json = /ui2/cl_json=>serialize( EXPORTING data = ls_allindent pretty_name = 'X' ).
      TRY.
          FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                      comm_scenario = 'ZCS_INDENTIP'
                                      service_id    = 'ZOS_PR_REST' ).
          FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          FINAL(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |application/json| ).
          READ TABLE lt_req INTO DATA(ls_req) WITH KEY purreq = <lfs_prdata>-doc_num.
          IF ls_req-purreq IS NOT INITIAL.
            lo_request->set_header_field(  i_name = 'Edit' i_value = 'X' ).
          ELSE.
            lo_request->set_header_field(  i_name = 'Edit' i_value = '' ).
          ENDIF.
          lo_request->set_header_field(  i_name = 'Length' i_value = l_length ).
          lo_request->set_header_field(  i_name = 'PR' i_value = l_docnum ).
          lo_request->set_text( lv_json ).
          FINAL(ls_text) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          IF ls_text CS '"id"'. "Success
            /ui2/cl_json=>deserialize( EXPORTING json = ls_text CHANGING data = ls_id  ).
            APPEND VALUE #( purreq = <lfs_prdata>-doc_num createdon = sy-datlo prip = ls_id-id ) TO lt_pr.
            APPEND VALUE #( purreq = <lfs_prdata>-doc_num createdon = sy-datlo createdat = sy-timlo
                            payload = lv_json response = ls_text ) TO lt_pr_logs.
          ELSE.
            APPEND VALUE #( purreq = <lfs_prdata>-doc_num createdon = sy-datlo createdat = sy-timlo
                            payload = lv_json response = ls_text ) TO lt_pr_logs.
          ENDIF.
          lo_http_client->close( ).
          CLEAR lv_json.
          CLEAR : ls_req.
        CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error).
        CATCH cx_web_http_client_error INTO FINAL(web_http_client_error).
      ENDTRY.

      CLEAR: ls_allindent,ls_allindent-item[].
      CLEAR :
                lv_atom_xml, lv_abap_xml, lt_final_xml[], lv_final_xml, lt_entries[], lv_entry1, lv_longtext, lv_start_pos,
                lv_end_pos, lv_substr, lv_length, lt_atom_entries[].
                 "lo_factory, lt_comm_arrang[], lo_comm_arrang, lv_message, eo_client1, lv_resp_satus, lv_resp_text,
    ENDLOOP.

    IF lt_pr[] IS NOT INITIAL.
      MODIFY zdt_ip_pr FROM TABLE @lt_pr[].
      COMMIT WORK AND WAIT.
    ENDIF.

    IF lt_pr_logs[] IS NOT INITIAL.
      MODIFY zdt_ip_pr_logs FROM TABLE @lt_pr_logs[].
      COMMIT WORK AND WAIT.
    ENDIF.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

**********************************************************************
*--API Structure
    TYPES: BEGIN OF lty_lineitemindent,
             item_check      TYPE i_supplier-supplierfullname,
             name            TYPE i_supplier-supplierfullname,
             hsn             TYPE i_supplier-supplierfullname,
             lead            TYPE i_supplier-supplierfullname,
             uom_i           TYPE i_supplier-supplierfullname,
             uom_p           TYPE i_supplier-supplierfullname,
             uom_s           TYPE i_supplier-supplierfullname,
             itemgroup_code  TYPE i_supplier-supplierfullname,
             itemgroup_name  TYPE i_supplier-supplierfullname,
             costcentrename  TYPE i_supplier-supplierfullname,
             costcentrecode  TYPE i_supplier-supplierfullname,
             quantity        TYPE i_supplier-supplierfullname,
             price           TYPE i_supplier-supplierfullname,
             description     TYPE i_supplier-supplierfullname,
             requirementdate TYPE i_supplier-supplierfullname,
             acctcode        TYPE i_supplier-supplierfullname,
             ocr2            TYPE i_supplier-supplierfullname,
             ocr3            TYPE i_supplier-supplierfullname,
             ocr4            TYPE i_supplier-supplierfullname,
             project         TYPE i_supplier-supplierfullname,
             u_itnewdes      TYPE i_supplier-supplierfullname,
             u_rnohead       TYPE i_supplier-supplierfullname,
             doc_itemno      TYPE i_supplier-supplierfullname,
             pr_delete       TYPE i_supplier-supplierfullname,
             pr_process      TYPE i_supplier-supplierfullname,
             itemtext        TYPE string,
           END OF lty_lineitemindent.

    DATA: BEGIN OF ls_allindent,
            warehousecode    TYPE i_supplier-supplierfullname,
            warehousename    TYPE i_supplier-supplierfullname,
            warehousestreet  TYPE i_supplier-supplierfullname,
            warehouseblock   TYPE i_supplier-supplierfullname,
            warehousecity    TYPE i_supplier-supplierfullname,
            warehousezipcode TYPE i_supplier-supplierfullname,
            doc              TYPE i_supplier-supplierfullname,
            docdue           TYPE i_supplier-supplierfullname,
            tax              TYPE i_supplier-supplierfullname,
            create           TYPE i_supplier-supplierfullname,
            update           TYPE i_supplier-supplierfullname,
            req              TYPE i_supplier-supplierfullname,
            remark           TYPE i_supplier-supplierfullname,
            doc_num          TYPE i_supplier-supplierfullname,
            sec              TYPE i_supplier-supplierfullname,
            dep              TYPE i_supplier-supplierfullname,
            branch           TYPE i_supplier-supplierfullname,
            code             TYPE i_supplier-supplierfullname,
            name             TYPE i_supplier-supplierfullname,
            mobile           TYPE i_supplier-supplierfullname,
            indents_length   TYPE i_supplier-supplierfullname,
            item             TYPE TABLE OF lty_lineitemindent,
          END OF ls_allindent.

    TYPES : BEGIN OF ty_log,
              purchaserequisition     TYPE i_supplier-supplierfullname,
              purchaserequisitionitem TYPE i_supplier-supplierfullname,
              textobjectcategory      TYPE i_supplier-supplierfullname,
              textobjecttype          TYPE i_supplier-supplierfullname,
              language                TYPE i_supplier-supplierfullname,
              plainlongtext           TYPE i_supplier-supplierfullname,
            END OF ty_log.

    TYPES : BEGIN OF ty_id,
              id TYPE i_supplier-supplierfullname,
            END OF ty_id.
    DATA: log   TYPE TABLE OF ty_log,
          ls_id TYPE ty_id.

    DATA: lv_date_start TYPE datum,
          lv_date_end   TYPE datum,
          lv_time_end   TYPE timn,
          lv_time_begin TYPE timn,
          lv_json       TYPE string,
          lt_pr         TYPE TABLE OF zdt_ip_pr.

    DATA: lv_atom_xml     TYPE string,
          lv_abap_xml     TYPE string,
          lt_final_xml    TYPE TABLE OF string,
          lv_final_xml    TYPE string,
          lt_entries      TYPE TABLE OF string,
          lv_entry1       TYPE string,
          lv_longtext     TYPE string,
          lv_start_pos    TYPE i,                    " Start position for extracting values
          lv_end_pos      TYPE i,                      " End position for extracting values
          lv_substr       TYPE string,                  " Temp variable for extracted value
          lv_length       TYPE i,
          lt_atom_entries TYPE TABLE OF string,
          lt_pr_logs      TYPE TABLE OF zdt_ip_pr_logs,
          l_length        TYPE string,
          l_docnum        TYPE string,
          lv_minutes      TYPE f,
          gt_params       TYPE REF TO cl_scal_api.

**********************************************************************
*Initialization
    lv_date_end = cl_abap_context_info=>get_system_date( ) .
    lv_time_end = cl_abap_context_info=>get_system_time( ) .
    lv_minutes  = 180.


    CREATE OBJECT gt_params. " Create instance of CL_SCAL_API

    gt_params->start_time_determine(
      EXPORTING
        iv_duration = lv_minutes
        iv_unit     = 'MIN'
      IMPORTING
        ev_start_date = lv_date_start
        ev_start_time = lv_time_begin
      CHANGING
       cv_end_date = lv_date_end
       cv_end_time = lv_time_end   ).


*    SELECT *
*    FROM zmm_ip_pr
*    WHERE ( ( datesdoc BETWEEN @lv_date_start AND @lv_date_end )
*    OR ( lastchangedate BETWEEN @lv_date_start AND @lv_date_end ) )
*    INTO TABLE @DATA(lt_prdata).

    SELECT *
    FROM zmm_ip_pr
    WHERE ( lastchangedate BETWEEN @lv_date_start AND @lv_date_end )
    INTO TABLE @DATA(lt_prdata).

    IF sy-subrc = 0.


      DELETE lt_prdata WHERE lastchangedate = lv_date_start AND lastchangetime LT lv_time_begin.
      DELETE lt_prdata WHERE lastchangedate = lv_date_end AND lastchangetime GT lv_time_end.
      SORT lt_prdata BY doc_num.

      IF lt_prdata[] IS NOT INITIAL.

*Fetch Business Partner Address
        SELECT businesspartner,
               addressnumber,
               streetname,
               streetsuffixname,
               additionalstreetsuffixname
            FROM i_businesspartneraddresstp_3
            FOR ALL ENTRIES IN @lt_prdata
            WHERE businesspartner = @lt_prdata-customer
            INTO TABLE @DATA(lt_bpaddr).
        IF sy-subrc = 0.
          SORT lt_bpaddr BY businesspartner.
        ENDIF.
      ENDIF.
    ENDIF.

    SELECT a~purreq FROM zdt_ip_pr AS a
    INNER JOIN @lt_prdata AS b ON b~doc_num = a~purreq
    INTO TABLE @DATA(lt_req).


    DATA(lt_prdata_h) = lt_prdata.
    SORT lt_prdata_h BY doc_num.
    DELETE ADJACENT DUPLICATES FROM lt_prdata_h COMPARING doc_num.

    LOOP AT lt_prdata_h ASSIGNING FIELD-SYMBOL(<lfs_prdata>).

      ls_allindent-warehousecode = <lfs_prdata>-warehousecode.
      ls_allindent-warehousename = <lfs_prdata>-warehousename.
      ls_allindent-warehousestreet = <lfs_prdata>-warehousestreet.
      ls_allindent-warehousecity = <lfs_prdata>-warehousecity.
      ls_allindent-warehousezipcode = <lfs_prdata>-warehousezipcode.
      ls_allindent-warehouseblock = 'Block'.
      ls_allindent-doc = COND #( WHEN <lfs_prdata>-datesdoc IS NOT INITIAL
      THEN <lfs_prdata>-datesdoc+0(4) && '-' && <lfs_prdata>-datesdoc+4(2) && '-' && <lfs_prdata>-datesdoc+6(2) ELSE '' ).
      ls_allindent-req = COND #( WHEN <lfs_prdata>-datesreq IS NOT INITIAL
      THEN <lfs_prdata>-datesreq+0(4) && '-' && <lfs_prdata>-datesreq+4(2) && '-' && <lfs_prdata>-datesreq+6(2) ELSE '' ).
      ls_allindent-remark = <lfs_prdata>-remark.
      ls_allindent-doc_num = <lfs_prdata>-doc_num.
      l_docnum = ls_allindent-doc_num.
      ls_allindent-code = <lfs_prdata>-bycode.
      ls_allindent-name = COND #( WHEN <lfs_prdata>-byname IS NOT INITIAL THEN <lfs_prdata>-byname ELSE 'Dummy' ).

      DATA(lt_prdata_i) = lt_prdata.
      DELETE lt_prdata_i WHERE doc_num <> <lfs_prdata>-doc_num.
      ls_allindent-indents_length = lines( lt_prdata_i ).
      CONDENSE: ls_allindent-indents_length.
      l_length = ls_allindent-indents_length.
      CLEAR: lt_prdata_i.

      DATA(ls_bpaddr) = VALUE #( lt_bpaddr[ businesspartner = <lfs_prdata>-customer ] OPTIONAL ).
      IF ls_bpaddr IS NOT INITIAL.
        ls_allindent-warehouseblock = ls_bpaddr-streetsuffixname.
      ENDIF.
      CLEAR: ls_bpaddr.
      "Get Item Text
*      DATA(lo_factory) = cl_com_arrangement_factory=>create_instance( ).
*
*      lo_factory->query_ca(
*        EXPORTING
*          is_query = VALUE #( cscn_id_range = VALUE #( ( sign = 'I' option = 'EQ' low = 'ZCS_SAP_COM_0102' ) ) ) " Custom Communication Scenario
*        IMPORTING
*          et_com_arrangement = DATA(lt_comm_arrang) ).
*
*      DATA(lo_comm_arrang) = lt_comm_arrang[ 1 ].
*
*      TRY.
*          DATA(lo_destination1) = cl_http_destination_provider=>create_by_comm_arrangement(
*            comm_scenario  = CONV #( 'ZCS_SAP_COM_0102' )" Use Custom Communicaiton Scenario, Not standard!
*            comm_system_id = lo_comm_arrang->get_comm_system_id( )
*            service_id     = CONV #( 'ZOS_PURREQ_REST' )" Outbound Service ID
*          ).
*        CATCH cx_http_dest_provider_error INTO DATA(lo_error).
*          DATA(lv_message) = lo_error->get_longtext( ).
*      ENDTRY.
*
*      TRY.
*          DATA(eo_client1) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination1 ).
*        CATCH cx_web_http_client_error.
*      ENDTRY.
*
*      DATA(eo_request1) = eo_client1->get_http_request( ).
*      eo_request1->set_content_type( content_type = |application/json| ).
*
*      "DATA(lv_path) = |/PurchaseReqnItem/{ ls_prdata-doc_num }/{ ls_prdata-doc_num_item }/_PurchaseReqnItemText|.
*      DATA(lv_path) = |/PurchaseReqnItemText?$filter=PurchaseRequisition eq '{ <lfs_prdata>-doc_num }'|.
*      eo_request1->set_uri_path( i_uri_path = lv_path ).
*
*      TRY.
*          DATA(lo_response) = eo_client1->execute( i_method = if_web_http_client=>get ).
*        CATCH cx_web_http_client_error.
*      ENDTRY.
*
*      DATA(lv_resp_satus) = lo_response->get_status( ).
*      DATA(lv_resp_text) = lo_response->get_text( ).
*
*      SPLIT lv_resp_text AT '"value":' INTO DATA(l_a) DATA(l_b).
*      DATA(l_len) = strlen(  l_b ).
*      l_len = l_len - 1.
*      DATA(l_final) = l_b+0(l_len).
*      /ui2/cl_json=>deserialize( EXPORTING json = l_final CHANGING data = log  ).

      LOOP AT lt_prdata INTO DATA(ls_prdata) WHERE doc_num = <lfs_prdata>-doc_num.
        APPEND INITIAL LINE TO ls_allindent-item ASSIGNING FIELD-SYMBOL(<lfs_item>).
        <lfs_item>-item_check = ls_prdata-item_check.
        <lfs_item>-name = ls_prdata-item_name.
        <lfs_item>-hsn = ls_prdata-hsn.
        <lfs_item>-lead = COND #( WHEN ls_prdata-datesreq IS NOT INITIAL
        THEN ls_prdata-datesreq+0(4) && '-' && ls_prdata-datesreq+4(2) && '-' && ls_prdata-datesreq+6(2) ELSE '' ).
        <lfs_item>-uom_i = ls_prdata-uom_i.
        <lfs_item>-itemgroup_code = ls_prdata-itemgroup_code.
        <lfs_item>-itemgroup_name = ls_prdata-itemgroup_name.
        <lfs_item>-costcentrecode = ls_prdata-costcentercode.
        <lfs_item>-costcentrename = ls_prdata-costcentername.
        <lfs_item>-quantity = ls_prdata-quantity.
        <lfs_item>-price = ls_prdata-price.
        CONDENSE: <lfs_item>-quantity,<lfs_item>-price.
        <lfs_item>-description = ls_prdata-description.
        <lfs_item>-requirementdate = COND #( WHEN ls_prdata-datesreq IS NOT INITIAL
        THEN ls_prdata-datesreq+0(4) && '-' && ls_prdata-datesreq+4(2) && '-' && ls_prdata-datesreq+6(2) ELSE '' ).
        <lfs_item>-doc_itemno      = ls_prdata-doc_num_item.
        <lfs_item>-pr_delete       = ls_prdata-deleted.
        <lfs_item>-pr_process      = ls_prdata-process.

        DATA(lv_pritem) = |{ ls_prdata-doc_num_item ALPHA = OUT }|.
*        READ TABLE log INTO DATA(ls_log) WITH KEY purchaserequisitionitem = lv_pritem "ls_prdata-doc_num_item
*                                                  textobjectcategory = 'EBAN' textobjecttype = 'B01' language = 'EN'.
*        IF ls_log IS NOT INITIAL.
*          <lfs_item>-itemtext = ls_log-plainlongtext.
*        ENDIF.
        CLEAR :  lv_pritem.

        "End o Item Text
      ENDLOOP.

      lv_json = /ui2/cl_json=>serialize( EXPORTING data = ls_allindent pretty_name = 'X' ).
      TRY.
          FINAL(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                      comm_scenario = 'ZCS_INDENTIP'
                                      service_id    = 'ZOS_PR_REST' ).
          FINAL(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          FINAL(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |application/json| ).
          READ TABLE lt_req INTO DATA(ls_req) WITH KEY purreq = <lfs_prdata>-doc_num.
          IF ls_req-purreq IS NOT INITIAL.
            lo_request->set_header_field(  i_name = 'Edit' i_value = 'X' ).
          ELSE.
            lo_request->set_header_field(  i_name = 'Edit' i_value = '' ).
          ENDIF.
          lo_request->set_header_field(  i_name = 'Length' i_value = l_length ).
          lo_request->set_header_field(  i_name = 'PR' i_value = l_docnum ).
          lo_request->set_text( lv_json ).
          FINAL(ls_text) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          IF ls_text CS '"id"'. "Success
            /ui2/cl_json=>deserialize( EXPORTING json = ls_text CHANGING data = ls_id  ).
            APPEND VALUE #( purreq = <lfs_prdata>-doc_num createdon = sy-datlo prip = ls_id-id ) TO lt_pr.
            APPEND VALUE #( purreq = <lfs_prdata>-doc_num createdon = sy-datlo createdat = sy-timlo
                            payload = lv_json response = ls_text ) TO lt_pr_logs.
          ELSE.
            APPEND VALUE #( purreq = <lfs_prdata>-doc_num createdon = sy-datlo createdat = sy-timlo
                            payload = lv_json response = ls_text ) TO lt_pr_logs.
          ENDIF.
          lo_http_client->close( ).
          CLEAR lv_json.
          CLEAR : ls_req.
        CATCH cx_http_dest_provider_error INTO FINAL(http_dest_provider_error).
        CATCH cx_web_http_client_error INTO FINAL(web_http_client_error).
      ENDTRY.

      CLEAR: ls_allindent,ls_allindent-item[].
      CLEAR :
                lv_atom_xml, lv_abap_xml, lt_final_xml[], lv_final_xml, lt_entries[], lv_entry1, lv_longtext, lv_start_pos,
                lv_end_pos, lv_substr, lv_length, lt_atom_entries[].
                "lo_factory, lt_comm_arrang[], lo_comm_arrang, lv_message, eo_client1, lv_resp_satus, lv_resp_text,
    ENDLOOP.

    IF lt_pr[] IS NOT INITIAL.
      MODIFY zdt_ip_pr FROM TABLE @lt_pr[].
      COMMIT WORK AND WAIT.
    ENDIF.

    IF lt_pr_logs[] IS NOT INITIAL.
      MODIFY zdt_ip_pr_logs FROM TABLE @lt_pr_logs[].
      COMMIT WORK AND WAIT.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
