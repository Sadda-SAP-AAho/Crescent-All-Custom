CLASS zcl_hsbc_payment_status_utr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.



  PUBLIC SECTION.
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



CLASS ZCL_HSBC_PAYMENT_STATUS_UTR IMPLEMENTATION.


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
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_HSBCUTR_02_LOG'
                                                                      subobject   = 'ZAPP_HSBCUTR_02_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.
    " No parameters required
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.


DATA: lv_json TYPE string.
data :  lv_utr      TYPE char30.


TYPES: BEGIN OF ty_tx,
         stsid        TYPE string,
         orgnlinstrid TYPE string,
         orgnlmsgid   TYPE string,
       END OF ty_tx.

TYPES: ty_t_tx TYPE STANDARD TABLE OF ty_tx WITH EMPTY KEY.


TYPES: ty_t_info TYPE STANDARD TABLE OF string WITH EMPTY KEY.

TYPES: BEGIN OF ty_root,
         msgid        TYPE string,
         status       TYPE string,
         transactions TYPE ty_t_tx,
         info         TYPE ty_t_info,
         reason       TYPE string,
       END OF ty_root.

DATA: ls_data TYPE ty_root.
data : lv_id type string.
data : lv_payid type string.
data : lv_payid2 type string.
data : lv_payrunid type string.
data : lv_nonreqid type string.

select * from zdt_payment_head where status = 'Accepted by Bank' and housebank like 'HSB%' and  utr = '' into table @data(lt_hsbc_stat).

loop at lt_hsbc_stat ASSIGNING FIELD-SYMBOL(<fs_stat>).


TRY.

DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
                  comm_scenario = 'ZFI_HSBC_UTR'
                  service_id    = 'ZFI_HSBC_UTR_REST' ).

DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

lv_json = lo_client->execute( if_web_http_client=>GET )->get_text( ).

lo_client->close( ).


CATCH cx_http_dest_provider_error INTO DATA(lx_dest).
RETURN.

CATCH cx_web_http_client_error INTO DATA(lx_http).
RETURN.

ENDTRY.

IF lv_json IS INITIAL.
RETURN.
ENDIF.

DATA: lt_lines TYPE TABLE OF string,
      lv_value TYPE string.

FIND REGEX ':61:(.+)' IN lv_json
     SUBMATCHES lv_id.

SPLIT lv_id AT cl_abap_char_utilities=>newline INTO TABLE lt_lines.

READ TABLE lt_lines INTO lv_value INDEX 1.
split lv_value at ',' into lv_payid lv_payid2.
split lv_payid2 at '//' into lv_payrunid lv_nonreqid.

lv_payrunid = substring( val = lv_payrunid off = 6 ).


clear : lv_value.
read table lt_lines into lv_value index 2.
lv_utr = lv_value.
free : lt_lines.
clear : lv_value.


if lv_utr is NOT INITIAL.
if lv_payrunid = <fs_stat>-paymentrunid.
UPDATE zdt_payment_head
set status = 'UTR Generated',
utr = @lv_utr
where paymentrunid = @<fs_stat>-paymentrunid.
if sy-subrc = 0.
 COMMIT WORK AND WAIT.
 ELSE.
  ROLLBACK ENTITIES.
 endif.
 endif.
endif.

clear : lv_utr.
endloop.
  ENDMETHOD.


METHOD if_oo_adt_classrun~main.

   DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
      CATCH cx_root INTO FINAL(job_scheduling_exception).
    ENDTRY.

ENDMETHOD.
ENDCLASS.
