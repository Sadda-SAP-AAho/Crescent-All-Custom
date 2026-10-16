CLASS zcl_payment_citi_status DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'STATUS'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'STATUS DATA'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_CITI_STAT_01'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_CITI_STAT_01'.

    INTERFACES if_apj_dt_exec_object.
    INTERFACES if_apj_rt_exec_object.
    INTERFACES if_oo_adt_classrun.
    METHODS constructor.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS add_text_to_app_log_or_console
      IMPORTING i_text TYPE cl_bali_free_text_setter=>ty_text
      RAISING   cx_bali_runtime.

    DATA out             TYPE REF TO if_oo_adt_classrun_out.
    DATA application_log TYPE REF TO if_bali_log.
ENDCLASS.



CLASS ZCL_PAYMENT_CITI_STATUS IMPLEMENTATION.


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
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_CITISTAT_01_LOG'
                                                                      subobject   = 'ZAPP_CITISTAT_01_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

*    TYPES: BEGIN OF ty_citi_hed,
*             accountingdoc TYPE belnr_d,
*             fiscalyear    TYPE gjahr,
*             companycode   TYPE bukrs,
*             msgid         TYPE string,
*             credttm       TYPE string,
*             ctrlsum       TYPE string,
*             cname         TYPE string,
*             reqdexctndt   TYPE string,
*             housebank     TYPE string,
*             payamt        TYPE string,
*             vifsc         TYPE string,
*             vname         TYPE string,
*             vadd          TYPE string,
*             vadd1         TYPE string,
*             vacc          TYPE string,
*             remarks       TYPE string,
*             xmlval        TYPE string,
*           END OF ty_citi_hed .
*
*    DATA: lt_citi_hed     TYPE STANDARD TABLE OF ty_citi_hed,
*          ls_file_logciti TYPE zdt_file_logciti.

    DATA: lv_val   TYPE string,
          lv_msgid TYPE string.

    DATA: lr_citi TYPE RANGE OF hbkid.

    CLEAR: lr_citi[].
*-----------------------------------------------------------------------------------------------
    lr_citi = VALUE #( sign = 'I' option = 'CP' ( low = 'CTB*'  ) ).

    SELECT * FROM zdt_payment_head
     WHERE utr = '' AND status = 'Sent to Bank' AND housebank IN @lr_citi
     INTO TABLE @DATA(lt_citi_payhdr).

    CHECK sy-subrc EQ 0 AND lt_citi_payhdr IS NOT INITIAL.

    SELECT a~* FROM zv_payment_item AS a
             INNER JOIN @lt_citi_payhdr AS b ON a~accountingdocument = b~accountingdoc AND
                                                a~fiscalyear         = b~fiscalyear AND
                                                a~companycode        = b~companycode
             INTO TABLE @DATA(lt_citi_payitm).

    LOOP AT lt_citi_payhdr ASSIGNING FIELD-SYMBOL(<fs_citi_payhdr>) WHERE utr = '' AND status = 'Sent to Bank'.

      CLEAR lv_val .
*//---Message ID
      lv_msgid = <fs_citi_payhdr>-accountingdoc && <fs_citi_payhdr>-fiscalyear+2(2) && <fs_citi_payhdr>-companycode.

*//---- XML format
      lv_val = |<?xml version = '1.0' encoding = 'UTF-8'?>| &&
               |<paymentInquiryRequest xmlns="http://com.citi.citiconnect/services/types/inquiries/payment/v1">| &&
               |<EndToEndId>| && lv_msgid && |</EndToEndId></paymentInquiryRequest>| .
      CONDENSE lv_val .


      TRY.
          DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario = 'ZFI_SC_CITIPAY'
                                                                                           service_id    = 'ZSB_CITI_PAYMENT_STATUS_REST' ).
          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          DATA(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |text/plain| ).

          lo_request->set_text( lv_val ).
          DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          lo_http_client->close(  ).

          IF ls_result IS NOT INITIAL .
            IF ( ls_result CS 'ACSP' OR ls_result CS 'ACSC' ).

              SPLIT ls_result AT '<Ustrd>' INTO DATA(lv_utr_l) DATA(lv_utr_r).
              SPLIT lv_utr_r AT '</Ustrd>' INTO lv_utr_l lv_utr_r.

              IF 'UTR-' CS lv_utr_l.
                SPLIT lv_utr_l AT 'UTR-' INTO lv_utr_l lv_utr_r.
                CONDENSE lv_utr_l .
              ELSE.
                CONDENSE lv_utr_l .
              ENDIF.

***              SPLIT ls_result AT 'UTR-' INTO DATA(lv_utr_l) DATA(lv_utr_r).
***              SPLIT lv_utr_r AT '<' INTO lv_utr_l lv_utr_r.
***              CONDENSE lv_utr_l .

              UPDATE zdt_payment_head SET status = 'UTR Generated',
                                          utr    = @lv_utr_l
                                      WHERE accountingdoc = @<fs_citi_payhdr>-accountingdoc
                                        AND fiscalyear    = @<fs_citi_payhdr>-fiscalyear
                                        AND companycode   = @<fs_citi_payhdr>-companycode.
              IF sy-subrc EQ 0.
                COMMIT WORK AND WAIT.
              ENDIF.
            ELSEIF ls_result CS 'RJCT'.
              UPDATE zdt_payment_head SET status = 'Failed'
                                      WHERE accountingdoc = @<fs_citi_payhdr>-accountingdoc
                                        AND fiscalyear    = @<fs_citi_payhdr>-fiscalyear
                                        AND companycode   = @<fs_citi_payhdr>-companycode.
              IF sy-subrc EQ 0.
                COMMIT WORK AND WAIT.
              ENDIF.
            ENDIF.

          ENDIF.


        CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error).
        CATCH cx_web_http_client_error INTO DATA(web_http_client_error).
          CLEAR lv_val.
      ENDTRY.

    ENDLOOP.


*//-------------------------------------------------------------------------//

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.


    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.

    DATA: lv_val   TYPE string,
          lv_msgid TYPE string.

    DATA: lr_citi TYPE RANGE OF hbkid.

    CLEAR: lr_citi[].
*-----------------------------------------------------------------------------------------------
    lr_citi = VALUE #( sign = 'I' option = 'CP' ( low = 'CTB*'  ) ).

    SELECT * FROM zdt_payment_head
     WHERE utr = '' AND status = 'Sent to Bank' AND housebank IN @lr_citi
     INTO TABLE @DATA(lt_citi_payhdr).

    CHECK sy-subrc EQ 0 AND lt_citi_payhdr IS NOT INITIAL.

    SELECT a~* FROM zv_payment_item AS a
             INNER JOIN @lt_citi_payhdr AS b ON a~accountingdocument = b~accountingdoc AND
                                                a~fiscalyear         = b~fiscalyear AND
                                                a~companycode        = b~companycode
             INTO TABLE @DATA(lt_citi_payitm).

    LOOP AT lt_citi_payhdr ASSIGNING FIELD-SYMBOL(<fs_citi_payhdr>) WHERE utr = '' AND status = 'Sent to Bank'.

      CLEAR lv_val .
*//---Message ID
      lv_msgid = <fs_citi_payhdr>-accountingdoc && <fs_citi_payhdr>-fiscalyear+2(2) && <fs_citi_payhdr>-companycode.

*//---- XML format
      lv_val = |<?xml version = '1.0' encoding = 'UTF-8'?>| &&
               |<paymentInquiryRequest xmlns="http://com.citi.citiconnect/services/types/inquiries/payment/v1">| &&
               |<EndToEndId>| && lv_msgid && |</EndToEndId></paymentInquiryRequest>| .
      CONDENSE lv_val .


      TRY.
          DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario = 'ZFI_SC_CITIPAY'
                                                                                           service_id    = 'ZSB_CITI_PAYMENT_STATUS_REST' ).
          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          DATA(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |text/plain| ).

          lo_request->set_text( lv_val ).
          DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          lo_http_client->close(  ).

          IF ls_result IS NOT INITIAL .
            IF ( ls_result CS 'ACSP' OR ls_result CS 'ACSC' ).

              SPLIT ls_result AT '<Ustrd>' INTO DATA(lv_utr_l) DATA(lv_utr_r).
              SPLIT lv_utr_r AT '</Ustrd>' INTO lv_utr_l lv_utr_r.

              IF 'UTR-' CS lv_utr_l.
                SPLIT lv_utr_l AT 'UTR-' INTO lv_utr_l lv_utr_r.
                CONDENSE lv_utr_l .
              ELSE.
                CONDENSE lv_utr_l .
              ENDIF.

***              SPLIT ls_result AT 'UTR-' INTO DATA(lv_utr_l) DATA(lv_utr_r).
***              SPLIT lv_utr_r AT '<' INTO lv_utr_l lv_utr_r.
***              CONDENSE lv_utr_l .

              UPDATE zdt_payment_head SET status = 'UTR Generated',
                                          utr    = @lv_utr_l
                                      WHERE accountingdoc = @<fs_citi_payhdr>-accountingdoc
                                        AND fiscalyear    = @<fs_citi_payhdr>-fiscalyear
                                        AND companycode   = @<fs_citi_payhdr>-companycode.
              IF sy-subrc EQ 0.
                COMMIT WORK AND WAIT.
              ENDIF.
            ELSEIF ls_result CS 'RJCT'.
              UPDATE zdt_payment_head SET status = 'Failed'
                                      WHERE accountingdoc = @<fs_citi_payhdr>-accountingdoc
                                        AND fiscalyear    = @<fs_citi_payhdr>-fiscalyear
                                        AND companycode   = @<fs_citi_payhdr>-companycode.
              IF sy-subrc EQ 0.
                COMMIT WORK AND WAIT.
              ENDIF.
            ENDIF.

          ENDIF.


        CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error).
        CATCH cx_web_http_client_error INTO DATA(web_http_client_error).
          CLEAR lv_val.
      ENDTRY.

    ENDLOOP.

    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
      CATCH cx_root INTO FINAL(job_scheduling_exception).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
