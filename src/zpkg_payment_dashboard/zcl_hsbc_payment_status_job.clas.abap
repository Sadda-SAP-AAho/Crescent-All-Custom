CLASS zcl_hsbc_payment_status_job DEFINITION
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



CLASS ZCL_HSBC_PAYMENT_STATUS_JOB IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.

   DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
      CATCH cx_root INTO FINAL(job_scheduling_exception).
    ENDTRY.


*DATA: lv_json TYPE string.
*
*
*TYPES: BEGIN OF ty_tx,
*         stsid        TYPE string,
*         orgnlinstrid TYPE string,
*         orgnlmsgid   TYPE string,
*       END OF ty_tx.
*
*TYPES: ty_t_tx TYPE STANDARD TABLE OF ty_tx WITH EMPTY KEY.
*
*TYPES: ty_t_info TYPE STANDARD TABLE OF string WITH EMPTY KEY.
*
*TYPES: BEGIN OF ty_root,
*         msgid        TYPE string,
*         status       TYPE string,
*         transactions TYPE ty_t_tx,
*         info         TYPE ty_t_info,
*         reason       TYPE string,
*       END OF ty_root.
*
*DATA: ls_data TYPE ty_root.
*
*
*select * from zdt_payment_head where status = 'Sent to Bank' and housebank like 'HSB%' into table @data(lt_hsbc_stat).
*
*loop at lt_hsbc_stat ASSIGNING FIELD-SYMBOL(<fs_stat>).
*
* do 2 TIMES.
*TRY.
*
*DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
*                  comm_scenario = 'ZFI_HSBC_STAT'
*                  service_id    = 'ZFI_HSBC_STAT_REST' ).
*
*DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).
*
*lv_json = lo_client->execute( if_web_http_client=>GET )->get_text( ).
*
*lo_client->close( ).
*
*
*CATCH cx_http_dest_provider_error INTO DATA(lx_dest).
*out->write( lx_dest->get_text( ) ).
*RETURN.
*
*CATCH cx_web_http_client_error INTO DATA(lx_http).
*out->write( lx_http->get_text( ) ).
*RETURN.
*
*ENDTRY.
*enddo.
*IF lv_json IS INITIAL.
*out->write( 'No response received from API' ).
*RETURN.
*ENDIF.
*
*
*TRY.
*
*
*/ui2/cl_json=>deserialize(
*  EXPORTING json = lv_json
*  CHANGING  data = ls_data ).
*
*
*CATCH cx_root INTO DATA(lx_json).
*out->write( |JSON Parse Error: { lx_json->get_text( ) }| ).
*RETURN.
*
*ENDTRY.
*
*
*if ls_data-status = 'ACCP'.
*
*UPDATE zdt_payment_head
*set status = 'Accepted by Bank',
*message = 'Payment Successfully Processed'
*where paymentrunid = @<fs_stat>-paymentrunid.
*if sy-subrc = 0.
* COMMIT WORK AND WAIT.
* ELSE.
*  ROLLBACK ENTITIES.
* endif.
*
*loop at ls_data-transactions into data(ls_trans).
*if <fs_stat>-paymentrunid = ls_trans-orgnlinstrid.
*UPDATE zdt_payment_head
*set status = 'Accepted by Bank',
*message = 'Payment Successfully Processed'
*where paymentrunid = @<fs_stat>-paymentrunid.
*if sy-subrc = 0.
* COMMIT WORK AND WAIT.
* ELSE.
*  ROLLBACK ENTITIES.
* endif.
*
*ENDIF.
*ENDLOOP.
*
*elseif ls_data-status = 'RJCT'.
*read table ls_data-info ASSIGNING FIELD-SYMBOL(<ls_info>) INDEX 1.
*data(info) = <ls_info>.
*
*loop at ls_data-transactions into ls_trans.
*data(id_tot_len) = strlen( ls_trans-orgnlmsgid  ).
*data(id_len) = id_tot_len - 4.
*data(payrunid) = ls_trans-orgnlmsgid+0(id_len).
*if <fs_stat>-paymentrunid = payrunid.
*UPDATE zdt_payment_head
*set status = 'Rejected by Bank',
*message = @info
*where paymentrunid = @<fs_stat>-paymentrunid.
*if sy-subrc = 0.
* COMMIT WORK AND WAIT.
* ELSE.
*  ROLLBACK ENTITIES.
* endif.
*endif.
*clear : id_tot_len,id_len,payrunid,info.
*ENDLOOP.
*endif.
*
*
*
*endloop.
ENDMETHOD.


  METHOD constructor.
    TRY.
        application_log = cl_bali_log=>create_with_header(
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_HSBCSTAT_02_LOG'
                                                                      subobject   = 'ZAPP_HSBCSTAT_02_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.
  ENDMETHOD.


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


  METHOD if_apj_dt_exec_object~get_parameters.

    " No parameters required
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.


DATA: lv_json TYPE string.


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


select * from zdt_payment_head where status = 'Sent to Bank' and housebank like 'HSB%' into table @data(lt_hsbc_stat).

loop at lt_hsbc_stat ASSIGNING FIELD-SYMBOL(<fs_stat>).

do 2 TIMES.

TRY.

DATA(lo_dest) = cl_http_destination_provider=>create_by_comm_arrangement(
                  comm_scenario = 'ZFI_HSBC_STAT'
                  service_id    = 'ZFI_HSBC_STAT_REST' ).

DATA(lo_client) = cl_web_http_client_manager=>create_by_http_destination( lo_dest ).

lv_json = lo_client->execute( if_web_http_client=>GET )->get_text( ).

lo_client->close( ).


CATCH cx_http_dest_provider_error INTO DATA(lx_dest).
*out->write( lx_dest->get_text( ) ).
RETURN.

CATCH cx_web_http_client_error INTO DATA(lx_http).
*out->write( lx_http->get_text( ) ).
RETURN.

ENDTRY.

IF lv_json IS INITIAL.
*out->write( 'No response received from API' ).
RETURN.
ENDIF.


TRY.


/ui2/cl_json=>deserialize(
  EXPORTING json = lv_json
  CHANGING  data = ls_data ).


CATCH cx_root INTO DATA(lx_json).
*out->write( |JSON Parse Error: { lx_json->get_text( ) }| ).
RETURN.

ENDTRY.

if ls_data-status = 'ACCP'.
exit.
endif.

enddo.





if ls_data-status = 'ACCP'.


loop at ls_data-transactions into data(ls_trans).
if <fs_stat>-paymentrunid = ls_trans-orgnlinstrid+0(5).
UPDATE zdt_payment_head
set status = 'Accepted by Bank',
message = 'Payment Successfully Processed'
where paymentrunid = @<fs_stat>-paymentrunid.
if sy-subrc = 0.
 COMMIT WORK AND WAIT.
 ELSE.
  ROLLBACK ENTITIES.
 endif.

ENDIF.
ENDLOOP.

elseif ls_data-status = 'RJCT'.
read table ls_data-info ASSIGNING FIELD-SYMBOL(<ls_info>) INDEX 1.
data(info) = <ls_info>.

loop at ls_data-transactions into ls_trans.
if <fs_stat>-paymentrunid = ls_trans-orgnlmsgid.
UPDATE zdt_payment_head
set status = 'Rejected by Bank',
message = @info
where paymentrunid = @<fs_stat>-paymentrunid.
if sy-subrc = 0.
 COMMIT WORK AND WAIT.
 ELSE.
  ROLLBACK ENTITIES.
 endif.
endif.
*clear : id_tot_len,id_len,payrunid,info.
clear :info.
ENDLOOP.
endif.



endloop.

  ENDMETHOD.
ENDCLASS.
