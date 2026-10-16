CLASS zcl_payment_icici_bjob DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'PAY'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'PAY DATA'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_ICICI_PAY_02'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_ICICI_PAY_02'.

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



CLASS ZCL_PAYMENT_ICICI_BJOB IMPLEMENTATION.


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
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_ICICIPAY_01_LOG'
                                                                      subobject   = 'ZAPP_ICICIPAY_01_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    TYPES: BEGIN OF ty_icici_hed,
             payid      TYPE    string,
             payind     TYPE    string,
             uniqueid   TYPE    string,
             name       TYPE    string,
             insamt     TYPE    string,
             paydate    TYPE    string,
             debitaccno TYPE    string,
             bnefiaccno TYPE    string,
             ifsccode   TYPE    string,
             email      TYPE    string,
             mobno      TYPE    string,
             adddtls1   TYPE    string,
             adddtls2   TYPE    string,
             remarks    TYPE    string,
           END OF ty_icici_hed,

           BEGIN OF ty_icici_itm,
             anexid    TYPE    string,
             uniqueid  TYPE    string,
             invno     TYPE    string,
             invdate   TYPE    string,
             grossamt  TYPE    string,
             advamt    TYPE    string,
             tdsamt    TYPE    string,
             deduction TYPE    string,
             netamt    TYPE    string,
             pono      TYPE    string,
           END OF ty_icici_itm.

types : begin of ty_invitem,
        AccountingDocument type belnr_d,
        SupplierInvoice type string,
        DocumentDate type bldat,
        AmountInCompanyCodeCurrency type dmbtr,
        WithholdingTaxAmount type dmbtr,
        NetAmount type dmbtr,
        end of ty_invitem.

    DATA: lt_icici_hed TYPE STANDARD TABLE OF ty_icici_hed,
          lt_icici_itm TYPE STANDARD TABLE OF ty_icici_itm,
          ls_icici_pay TYPE zdt_icici_pay,
          ls_file_log  TYPE zdt_file_log.
data : lt_inv_itm type table of ty_invitem,

        ls_inv_itm type ty_invitem.
    DATA: lr_icici TYPE RANGE OF hbkid.

    DATA: lv_hedamt TYPE dmbtr,
          lv_val    TYPE string,
          lv_line type string,
          lv_line1 type string.
    data : lv_doc type belnr_d.

    DATA: lv_json_post TYPE string VALUE ''.

    CLEAR :lr_icici[].
*-----------------------------------------------------------------------------------------------
    lr_icici = VALUE #( sign = 'I' option = 'CP' ( low = 'IC*'  ) ).

    SELECT * FROM zdt_payment_head
     WHERE approved = 'X' AND status = 'Approved' AND housebank IN @lr_icici
     INTO TABLE @DATA(lt_icici_payhdr).



    CHECK sy-subrc EQ 0 AND lt_icici_payhdr IS NOT INITIAL.

    SELECT a~* FROM zv_payment_item AS a
             INNER JOIN @lt_icici_payhdr AS b ON a~accountingdocument = b~accountingdoc AND
                                                 a~fiscalyear         = b~fiscalyear AND
                                                 a~companycode        = b~companycode
             INTO TABLE @DATA(lt_icict_payitm).



    select a~AccountingDocument, a~SupplierInvoice,a~DocumentDate,a~AmountInCompanyCodeCurrency,a~WithholdingTaxAmount from zi_invoice_item as a  inner join @lt_icici_payhdr  as b on     "Added by infocus on 9th April 2026
                                                                       a~AccountingDocument  = b~accountingdoc
                                                                       and a~FiscalYear = b~fiscalyear and
                                                                        a~CompanyCode = b~companycode into CORRESPONDING FIELDS OF TABLE @lt_inv_itm.

*//--get org mail id
    SELECT b~supplier,a~email
            FROM zdt_orgemail AS a
             INNER JOIN i_supplier AS b ON a~ktokk = b~supplieraccountgroup
             INNER JOIN @lt_icici_payhdr AS c ON b~supplier = c~supplier
           INTO TABLE @DATA(lt_orgmail)  .

    SELECT a~accountingdoc, a~fiscalyear, a~companycode, c~accountingdoccreatedbyuser,
           b~personfullname
      FROM @lt_icici_payhdr AS a
      INNER JOIN i_journalentry AS c ON  c~accountingdocument = a~accountingdoc
                                     AND c~companycode = a~companycode
                                     AND c~fiscalyear  = a~fiscalyear
      INNER JOIN i_businessuserbasic AS b ON b~userid = c~accountingdoccreatedbyuser
      GROUP BY a~accountingdoc, a~fiscalyear, a~companycode, c~accountingdoccreatedbyuser,
               b~personfullname
      INTO TABLE @DATA(lt_user).

    FREE:lt_icici_hed,lt_icici_itm.
    LOOP AT lt_icici_payhdr INTO DATA(ls_icici_payhdr) WHERE approved = 'X' AND
                                                             status    = 'Approved'.


      APPEND INITIAL LINE TO lt_icici_hed ASSIGNING FIELD-SYMBOL(<fs_icici_hed>).

**//---Payment Record Identifier
      <fs_icici_hed>-payid = 'I'.
*//--- Payment Indicator(N/R/I)
      SELECT SINGLE * FROM i_housebank WHERE housebank = @ls_icici_payhdr-housebank INTO @DATA(lv_ifscchouse).

      IF lv_ifscchouse CS ls_icici_payhdr-payeebankkey+0(4).
        <fs_icici_hed>-payind = 'I'.
      ENDIF.

*//---Unique Ref No(SAP Document No)
      <fs_icici_hed>-uniqueid = ls_icici_payhdr-accountingdoc &&
                                ls_icici_payhdr-fiscalyear &&
                                ls_icici_payhdr-companycode.
*//-- Name of Beneficiary
      <fs_icici_hed>-name = ls_icici_payhdr-suppliername.

*//-- Instrument Amount
      <fs_icici_hed>-insamt = ls_icici_payhdr-amountincompanycodecurrency * -1.
*//-- Payment Date
      "<fs_icici_hed>-paydate = sy-datlo+6(2) && '/' && sy-datlo+4(2) && '/' && sy-datlo+0(4).
      <fs_icici_hed>-paydate = ls_icici_payhdr-valuedate+6(2) && '/' && ls_icici_payhdr-valuedate+4(2) && '/' && ls_icici_payhdr-valuedate+0(4).
*//-- DebitAccountNo
      <fs_icici_hed>-debitaccno = ls_icici_payhdr-bankaccountnumber.
*//-- Beneficiary Bank A/c No
      <fs_icici_hed>-bnefiaccno = ls_icici_payhdr-payeebankaccount.
*//-- IFSC Code
      <fs_icici_hed>-ifsccode = ls_icici_payhdr-payeebankkey.
*//-- Email id
      "Changed by SP on 24.06.2025
      SELECT SINGLE emailaddress FROM i_buspartemailaddresstp_3 WHERE businesspartner = @ls_icici_payhdr-supplier INTO @DATA(lv_email).
      IF sy-subrc EQ 0 .
        <fs_icici_hed>-email = lv_email.
*        DATA(lt_orgmail_tmp) = lt_orgmail.
*        DELETE lt_orgmail_tmp WHERE supplier <> ls_icici_payhdr-supplier.
*        IF lt_orgmail_tmp IS NOT INITIAL.
*
*          DO 4 TIMES.
*            READ TABLE lt_orgmail_tmp INTO DATA(ls_orgmail_tmp) INDEX sy-index.
*            IF sy-subrc <> 0.
*              EXIT.
*            ELSE.
*              <fs_icici_hed>-email = <fs_icici_hed>-email && ';' && ls_orgmail_tmp-email.
*            ENDIF.
*          ENDDO.
*        ENDIF.
      ENDIF.

      SELECT SINGLE * FROM zdt_vend_mail WHERE lifnr = @ls_icici_payhdr-supplier INTO @DATA(ls_mail).
      IF ls_mail-mail1 IS NOT INITIAL.
        IF <fs_icici_hed>-email IS INITIAL.
          <fs_icici_hed>-email = ls_mail-mail1.
        ELSE.
          <fs_icici_hed>-email = <fs_icici_hed>-email && ';' && ls_mail-mail1.
        ENDIF.
      ENDIF.
      IF ls_mail-mail2 IS NOT INITIAL.
        IF <fs_icici_hed>-email IS INITIAL.
          <fs_icici_hed>-email = ls_mail-mail2.
        ELSE.
          <fs_icici_hed>-email = <fs_icici_hed>-email && ';' && ls_mail-mail2.
        ENDIF.
      ENDIF.
      IF ls_mail-mail3 IS NOT INITIAL.
        IF <fs_icici_hed>-email IS INITIAL.
          <fs_icici_hed>-email = ls_mail-mail3.
        ELSE.
          <fs_icici_hed>-email = <fs_icici_hed>-email && ';' && ls_mail-mail3.
        ENDIF.
      ENDIF.
      IF ls_mail-mail4 IS NOT INITIAL.
        IF <fs_icici_hed>-email IS INITIAL.
          <fs_icici_hed>-email = ls_mail-mail4.
        ELSE.
          <fs_icici_hed>-email = <fs_icici_hed>-email && ';' && ls_mail-mail4.
        ENDIF.
      ENDIF.
      IF ls_mail-mail5 IS NOT INITIAL.
        IF <fs_icici_hed>-email IS INITIAL.
          <fs_icici_hed>-email = ls_mail-mail5.
        ELSE.
          <fs_icici_hed>-email = <fs_icici_hed>-email && ';' && ls_mail-mail5.
        ENDIF.
      ENDIF.
      "Changed by SP on 24.06.2025
*//-- Beneficiary  Mobile No
      SELECT SINGLE phonenumber1 FROM  i_supplier  WHERE supplier = @ls_icici_payhdr-supplier INTO @DATA(lv_phone_no) .
      <fs_icici_hed>-mobno = lv_phone_no.
*//-- Additional details1
      READ TABLE lt_user INTO DATA(ls_user) WITH KEY accountingdoc = ls_icici_payhdr-accountingdoc
                                                     fiscalyear    = ls_icici_payhdr-fiscalyear
                                                     companycode   = ls_icici_payhdr-companycode.
      IF ls_user IS NOT INITIAL.
        <fs_icici_hed>-adddtls1 = ls_user-personfullname.
      ENDIF.
      CLEAR : ls_user.
*//-- Additional details2
*//-- Remarks

      LOOP AT lt_icict_payitm INTO DATA(ls_icict_payitm) WHERE accountingdocument = ls_icici_payhdr-accountingdoc AND
                                                               fiscalyear         = ls_icici_payhdr-fiscalyear AND
                                                               companycode        = ls_icici_payhdr-companycode .

        APPEND INITIAL LINE TO lt_icici_itm ASSIGNING FIELD-SYMBOL(<fs_icici_itm>).

*//-- Annexture Record Identifier
        <fs_icici_itm>-anexid = 'A'.
*//-- Document No.
        <fs_icici_itm>-uniqueid = <fs_icici_hed>-uniqueid.
*//-- Invoice No.
        <fs_icici_itm>-invno = ls_icict_payitm-supplierinvoice.
*//-- Invoice Date
*<fs_icici_itm>-invdate = lS_icict_payitm-.
        <fs_icici_itm>-invdate = sy-datlo+6(2) && '/' && sy-datlo+4(2) && '/' && sy-datlo+0(4).
*//-- Advanced Amount
*<fs_icici_itm>-advamt = lS_icict_payitm-.
*//-- TDS
        <fs_icici_itm>-tdsamt = ls_icict_payitm-withholdingtaxamount * -1.
***//-- Deduction
**<fs_icici_itm>-deduction = lS_icict_payitm-a-.
*//-- Net Amount
        <fs_icici_itm>-netamt = ls_icict_payitm-amountincompanycodecurrency * -1.
*//-- PO
        <fs_icici_itm>-pono = ls_icict_payitm-purchasingdocument.
*//-- Gross Amount
        <fs_icici_itm>-grossamt = <fs_icici_itm>-netamt + <fs_icici_itm>-tdsamt.

      ENDLOOP.

*//-- Update Header Payment Indicator
      IF <fs_icici_hed>-payind IS INITIAL .
        CLEAR lv_hedamt.
        lv_hedamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_icici_itm
                                  NEXT lv_amt = lv_amt + ls_itm-netamt ) .

        IF lv_hedamt > 200000.
          <fs_icici_hed>-payind = 'R'.
        ELSE.
          <fs_icici_hed>-payind = 'N'.
        ENDIF.
      ENDIF.

      FREE:lt_icici_itm.
    ENDLOOP.

LOOP AT lt_icici_hed ASSIGNING <fs_icici_hed> .
lv_doc = <fs_icici_hed>-uniqueid+0(10).

*      DO .
*        ASSIGN COMPONENT sy-index OF STRUCTURE <fs_icici_hed> TO FIELD-SYMBOL(<f_hed>).   "Commented 28th April
*        IF <f_hed> IS ASSIGNED AND sy-subrc EQ 0.
*          IF sy-index = 1 .
*            lv_val = lv_val && <f_hed>.
*          ELSE.
*            lv_val = lv_val && '|' && <f_hed>.
*          ENDIF.
*        ELSE.
*          lv_val = lv_val && '@/@'.
*          EXIT.
*        ENDIF.
*      ENDDO.

*      DATA(lt_itm_tmp) = lt_icici_itm.
*      DELETE lt_itm_tmp WHERE uniqueid <> <fs_icici_hed>-uniqueid.
*      DATA(lv_lines) = lines( lt_itm_tmp ).

data(tabix) = sy-tabix.

DO.
  ASSIGN COMPONENT sy-index OF STRUCTURE <fs_icici_hed> TO FIELD-SYMBOL(<f_hed>).
  IF <f_hed> IS ASSIGNED AND sy-subrc EQ 0.
  if tabix = 1.
    IF sy-index = 1 .
      lv_val = lv_val && <f_hed>.
    ELSE.
      lv_val = lv_val && '|' && <f_hed>.
    ENDIF.
  elseif tabix > 1.
      IF sy-index = 1 .
      lv_line1 = lv_line1 && <f_hed>.
    ELSE.
      lv_line1 = lv_line1 && '|' && <f_hed>.
    ENDIF.
  endif.
  ELSE.
    EXIT.
  ENDIF.
ENDDO.

if lv_line1 is NOT INITIAL.
lv_val = lv_val && cl_abap_char_utilities=>newline && lv_line1.
endif.
clear : lv_line1.

loop at lt_inv_itm ASSIGNING FIELD-SYMBOL(<fs_itm>) where accountingdocument  = lv_doc.
if <fs_itm>-withholdingtaxamount < 0.
<fs_itm>-withholdingtaxamount = abs( <fs_itm>-withholdingtaxamount ).
endif.
if <fs_itm>-amountincompanycodecurrency < 0.
<fs_itm>-amountincompanycodecurrency = abs( <fs_itm>-amountincompanycodecurrency ).
endif.
<fs_itm>-netamount = <fs_itm>-amountincompanycodecurrency.
<fs_itm>-amountincompanycodecurrency = <fs_itm>-netamount + <fs_itm>-withholdingtaxamount.
ENDLOOP.


  LOOP AT lt_inv_itm ASSIGNING <fs_itm> where accountingdocument = lv_doc.
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE <fs_itm> TO FIELD-SYMBOL(<s_itm>).
      IF <s_itm> IS ASSIGNED AND sy-subrc EQ 0.
      if sy-index = 1.
        lv_line =  'A|' && <s_itm>.
      else.
       lv_line = lv_line && '|' && <s_itm> .
      endif.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.
  lv_val = lv_val && cl_abap_char_utilities=>newline && lv_line.
  clear : lv_line.
  ENDLOOP.


clear : lv_doc.
    ENDLOOP.

*      /ui2/cl_json=>serialize( EXPORTING data = lv_val RECEIVING r_json = lv_json_post ).

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario = 'ZFI_SC_ICICIPAY'
                                                                                         service_id    = 'ZSB_ICICI_PAYMENT_REST' ).
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).
        lo_request->set_content_type( content_type = |text/plain| ).
        DATA : lv_value TYPE string,
               lv_cou   TYPE numc2,
               lv_date  TYPE datn,
               lv_time  TYPE timn.
        TRY.
            CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                    INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
          CATCH cx_abap_context_info_error.
        ENDTRY.

        CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
        SELECT SINGLE MAX( counter ) FROM zdt_file_log WHERE credt = @sy-datlo  INTO @lv_cou.
        lv_cou = lv_cou + 1.

        DATA : lv_date_1 TYPE char8.

        lv_date_1 = lv_date+6(2) && lv_date+4(2) && lv_date+0(4).

        lv_value = 'CRCPL_CRCPLAPIUPLDNEW_' && lv_date_1  && '_' && lv_cou && '.txt'.
        lo_request->set_header_field( i_name = |FileName| i_value = lv_value ).
        lo_request->set_text( lv_val ).
        DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
        lo_http_client->close(  ).

        IF ls_result CS 'File for Payment Modal Transferred'.
          CLEAR ls_icici_pay.

          ls_icici_pay-filename = lv_value.
          ls_icici_pay-filecontent = lv_val.
          ls_icici_pay-createdon = sy-datum.
          ls_icici_pay-createdat = sy-timlo.
          ls_icici_pay-response = ls_result.
          ls_icici_pay-processed = 'X'.
          MODIFY zdt_icici_pay FROM @ls_icici_pay.
          IF sy-subrc EQ 0.
            COMMIT WORK AND WAIT.
          ENDIF.

          LOOP AT lt_icici_payhdr INTO DATA(ls_hdr).
            UPDATE zdt_payment_head SET status = 'Sent to Bank' WHERE accountingdoc = @ls_hdr-accountingdoc
            AND fiscalyear = @ls_hdr-fiscalyear AND companycode = @ls_hdr-companycode.
            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.
          ENDLOOP.

          ls_file_log-filename = lv_value.
          ls_file_log-credt = sy-datum.
          ls_file_log-counter = lv_cou.
          MODIFY zdt_file_log FROM @ls_file_log.
          IF sy-subrc EQ 0.
            COMMIT WORK AND WAIT.
          ENDIF.
        ELSE.
          ls_icici_pay-filename = lv_value.
          ls_icici_pay-filecontent = lv_val.
          ls_icici_pay-createdon = sy-datum.
          ls_icici_pay-createdat = sy-timlo.
          ls_icici_pay-response = ls_result.
          MODIFY zdt_icici_pay FROM @ls_icici_pay.
          IF sy-subrc EQ 0.
            COMMIT WORK AND WAIT.
          ENDIF.

          ls_file_log-filename = lv_value.
          ls_file_log-credt = sy-datum.
          ls_file_log-counter = lv_cou.
          MODIFY zdt_file_log FROM @ls_file_log.
          IF sy-subrc EQ 0.
            COMMIT WORK AND WAIT.
          ENDIF.
        ENDIF.

        CLEAR lv_val.
      CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error).
      CATCH cx_web_http_client_error INTO DATA(web_http_client_error).
    ENDTRY.
*//-------------------------------------------------------------------------//

    SELECT *
    FROM zexim_lcim_bnk1
    INTO TABLE @DATA(lt_zexim_lcim_bnk1).
    IF lt_zexim_lcim_bnk1 IS NOT INITIAL.
      LOOP AT lt_zexim_lcim_bnk1 INTO DATA(ls_zexim_lcim_bnk1).
        SELECT SINGLE *
            FROM zr_bank_limit
            WHERE bukrs = @ls_zexim_lcim_bnk1-bukrs
              AND hktid = @ls_zexim_lcim_bnk1-hktid
              AND hbkid = @ls_zexim_lcim_bnk1-hbkid
              INTO @DATA(ls_banklimit).
        IF ls_banklimit IS NOT INITIAL.
          ls_zexim_lcim_bnk1-bgcleanutilised = ls_banklimit-bgutilised.
          ls_zexim_lcim_bnk1-bgcleanavailable = ls_zexim_lcim_bnk1-bglimit - ls_banklimit-bgutilised.
          MODIFY zexim_lcim_bnk1 FROM @ls_zexim_lcim_bnk1.
          COMMIT WORK AND WAIT.
        ENDIF.
      ENDLOOP.
    ENDIF.


  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
      CATCH cx_root INTO FINAL(job_scheduling_exception).
    ENDTRY.

***    TYPES: BEGIN OF ty_icici_hed,
***             payid      TYPE    string,
***             payind     TYPE    string,
***             uniqueid   TYPE    string,
***             name       TYPE    string,
***             insamt     TYPE    string,
***             paydate    TYPE    string,
***             debitaccno TYPE    string,
***             bnefiaccno TYPE    string,
***             ifsccode   TYPE    string,
***             email      TYPE    string,
***             mobno      TYPE    string,
***             adddtls1   TYPE    string,
***             adddtls2   TYPE    string,
***             remarks    TYPE    string,
***           END OF ty_icici_hed,
***
***           BEGIN OF ty_icici_itm,
***             anexid    TYPE    string,
***             uniqueid  TYPE    string,
***             invno     TYPE    string,
***             invdate   TYPE    string,
***             grossamt  TYPE    string,
***             advamt    TYPE    string,
***             tdsamt    TYPE    string,
***             deduction TYPE    string,
***             netamt    TYPE    string,
***             pono      TYPE    string,
***           END OF ty_icici_itm.
***    DATA: lt_icici_hed TYPE STANDARD TABLE OF ty_icici_hed,
***          lt_icici_itm TYPE STANDARD TABLE OF ty_icici_itm,
***          ls_icici_pay TYPE zdt_icici_pay,
***          ls_file_log  TYPE zdt_file_log.
***
***    DATA: lv_hedamt TYPE dmbtr,
***          lv_val    TYPE string.
***
***
***    DATA: lv_json_post TYPE string VALUE ''.
***
****-----------------------------------------------------------------------------------------------
***
***    SELECT * FROM zdt_payment_head
***     WHERE approved = 'X' AND ( status = 'Approved' ) "or status = 'Sent to Bank' )
***     INTO TABLE @DATA(lt_icici_payhdr).
***
***    CHECK sy-subrc EQ 0 AND lt_icici_payhdr IS NOT INITIAL.
***
***    SELECT a~* FROM zv_payment_item AS a
***             INNER JOIN @lt_icici_payhdr AS b ON a~accountingdocument = b~accountingdoc AND
***                                                 a~fiscalyear         = b~fiscalyear AND
***                                                 a~companycode        = b~companycode
***             INTO TABLE @DATA(lt_icict_payitm).
***
***    FREE:lt_icici_hed,lt_icici_itm.
***    LOOP AT lt_icici_payhdr INTO DATA(ls_icici_payhdr) WHERE approved = 'X' AND
***                   ( status = 'Approved' ). "or status = 'Sent to Bank' ).
***
***      APPEND INITIAL LINE TO lt_icici_hed ASSIGNING FIELD-SYMBOL(<fs_icici_hed>).
***
****//---Payment Record Identifier
***      <fs_icici_hed>-payid = 'I'.
****//--- Payment Indicator(N/R/I)
***      SELECT SINGLE * FROM i_housebank WHERE housebank = @ls_icici_payhdr-housebank INTO @DATA(lv_ifscchouse).
***
***      IF lv_ifscchouse CS ls_icici_payhdr-payeebankkey+0(4).
***        <fs_icici_hed>-payind = 'I'.
***      ENDIF.
****//---Unique Ref No(SAP Document No)
***      <fs_icici_hed>-uniqueid = ls_icici_payhdr-accountingdoc &&
***                                ls_icici_payhdr-fiscalyear &&
***                                ls_icici_payhdr-companycode.
****//-- Name of Beneficiary
***      <fs_icici_hed>-name = ls_icici_payhdr-suppliername.
***
****//-- Instrument Amount
***      <fs_icici_hed>-insamt = ls_icici_payhdr-amountincompanycodecurrency * -1.
****//-- Payment Date
***      <fs_icici_hed>-paydate = sy-datlo+6(2) && '/' && sy-datlo+4(2) && '/' && sy-datlo+0(4).
****//-- DebitAccountNo
***      <fs_icici_hed>-debitaccno = ls_icici_payhdr-bankaccountnumber.
****//-- Beneficiary Bank A/c No
***      <fs_icici_hed>-bnefiaccno = ls_icici_payhdr-payeebankaccount.
****//-- IFSC Code
***      <fs_icici_hed>-ifsccode = ls_icici_payhdr-payeebankkey.
****//-- Email id
****//-- Beneficiary  Mobile No
***      SELECT SINGLE phonenumber1 FROM  i_supplier  WHERE supplier = @ls_icici_payhdr-supplier INTO @DATA(lv_phone_no) .
***      <fs_icici_hed>-mobno = lv_phone_no.
****//-- Additional details1
****//-- Additional details2
****//-- Remarks
***
***      LOOP AT lt_icict_payitm INTO DATA(ls_icict_payitm) WHERE accountingdocument = ls_icici_payhdr-accountingdoc AND
***                                                               fiscalyear         = ls_icici_payhdr-fiscalyear AND
***                                                               companycode        = ls_icici_payhdr-companycode .
***
***        APPEND INITIAL LINE TO lt_icici_itm ASSIGNING FIELD-SYMBOL(<fs_icici_itm>).
***
****//-- Annexture Record Identifier
***        <fs_icici_itm>-anexid = 'A'.
****//-- Document No.
***        <fs_icici_itm>-uniqueid = <fs_icici_hed>-uniqueid.
****//-- Invoice No.
***        <fs_icici_itm>-invno = ls_icict_payitm-supplierinvoice.
****//-- Invoice Date
****<fs_icici_itm>-invdate = lS_icict_payitm-.
***        <fs_icici_itm>-invdate = sy-datlo+6(2) && '/' && sy-datlo+4(2) && '/' && sy-datlo+0(4).
****//-- Advanced Amount
****<fs_icici_itm>-advamt = lS_icict_payitm-.
****//-- TDS
***        <fs_icici_itm>-tdsamt = ls_icict_payitm-withholdingtaxamount * -1.
******//-- Deduction
*****<fs_icici_itm>-deduction = lS_icict_payitm-a-.
****//-- Net Amount
***        <fs_icici_itm>-netamt = ls_icict_payitm-amountincompanycodecurrency * -1.
****//-- PO
***        <fs_icici_itm>-pono = ls_icict_payitm-purchasingdocument.
****//-- Gross Amount
***        <fs_icici_itm>-grossamt = <fs_icici_itm>-netamt + <fs_icici_itm>-tdsamt.
***
***      ENDLOOP.
***
****//-- Update Header Payment Indicator
***      IF <fs_icici_hed>-payind IS INITIAL .
***        CLEAR lv_hedamt.
***        lv_hedamt = REDUCE dmbtr( INIT lv_amt TYPE dmbtr FOR ls_itm IN lt_icici_itm
***                                  NEXT lv_amt = lv_amt + ls_itm-netamt ) .
***        IF lv_hedamt > 200000.
***          <fs_icici_hed>-payind = 'R'.
***        ELSE.
***          <fs_icici_hed>-payind = 'N'.
***        ENDIF.
***      ENDIF.
***
***      FREE:lt_icici_itm.
***    ENDLOOP.
***
****//-------------------------------------------------------------------------//
***    LOOP AT lt_icici_hed ASSIGNING <fs_icici_hed> .
****      CLEAR :lv_val .
***
***      DO .
***        ASSIGN COMPONENT sy-index OF STRUCTURE <fs_icici_hed> TO FIELD-SYMBOL(<f_hed>).
***        IF <f_hed> IS ASSIGNED AND sy-subrc EQ 0.
***          IF sy-index = 1 .
***            lv_val = lv_val && <f_hed>.
***          ELSE.
***            lv_val = lv_val && '|' && <f_hed>.
***          ENDIF.
***        ELSE.
***          lv_val = lv_val && '@/@'.
***          EXIT.
***        ENDIF.
***      ENDDO.
***
****      DATA(lt_itm_tmp) = lt_icici_itm.
****      DELETE lt_itm_tmp WHERE uniqueid <> <fs_icici_hed>-uniqueid.
****      DATA(lv_lines) = lines( lt_itm_tmp ).
***
***    ENDLOOP.
***
***    LOOP AT lt_icici_itm ASSIGNING <fs_icici_itm>." WHERE uniqueid = <fs_icici_hed>-uniqueid.
***      DATA(l_index) = sy-tabix .
***
***      DO .
***        ASSIGN COMPONENT sy-index OF STRUCTURE <fs_icici_itm> TO FIELD-SYMBOL(<f_itm>).
***        IF <f_itm> IS ASSIGNED AND sy-subrc EQ 0.
***          IF sy-index = 1 .
***            lv_val = lv_val && <f_itm>.
***          ELSE.
***            lv_val = lv_val && '|' && <f_itm>.
***          ENDIF.
***        ELSE.
****          IF l_index < lv_lines .
***          lv_val = lv_val && '@/@'.
****          ENDIF.
***          EXIT.
***        ENDIF.
***      ENDDO.
***
***    ENDLOOP.
***
*****      /ui2/cl_json=>serialize( EXPORTING data = lv_val RECEIVING r_json = lv_json_post ).
***
***    TRY.
***        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario = 'ZFI_SC_ICICIPAY'
***                                                                                         service_id    = 'ZSB_ICICI_PAYMENT_REST' ).
***        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
***        DATA(lo_request) = lo_http_client->get_http_request( ).
***        lo_request->set_content_type( content_type = |text/plain| ).
***        DATA : lv_value TYPE string,
***               lv_cou   TYPE numc2,
***               lv_date  TYPE datn,
***               lv_time  TYPE timn.
***        TRY.
***            CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
***                    INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
***          CATCH cx_abap_context_info_error.
***        ENDTRY.
***
***        CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
***        SELECT SINGLE MAX( counter ) FROM zdt_file_log WHERE credt = @sy-datlo  INTO @lv_cou.
***        lv_cou = lv_cou + 1.
***
***        DATA : lv_date_1 TYPE char8.
***
***        lv_date_1 = lv_date+6(2) && lv_date+4(2) && lv_date+0(4).
***
***        lv_value = 'CRCPL_CRCPLAPIUPLD_' && lv_date_1  && '_' && lv_cou && '.txt'.
***        lo_request->set_header_field( i_name = |FileName| i_value = lv_value ).
***        lo_request->set_text( lv_val ).
***        DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
***        lo_http_client->close(  ).
***
***        IF ls_result CS 'File for Payment Modal Transferred'.
***          CLEAR ls_icici_pay.
***
***          ls_icici_pay-filename = lv_value.
***          ls_icici_pay-filecontent = lv_val.
***          ls_icici_pay-createdon = sy-datum.
***          ls_icici_pay-createdat = sy-timlo.
***          ls_icici_pay-response = ls_result.
***          ls_icici_pay-processed = 'X'.
***          MODIFY zdt_icici_pay FROM @ls_icici_pay.
***          IF sy-subrc EQ 0.
***            COMMIT WORK AND WAIT.
***          ENDIF.
***
***          LOOP AT lt_icici_payhdr INTO DATA(ls_hdr).
***            UPDATE zdt_payment_head SET status = 'Sent to Bank' WHERE accountingdoc = @ls_hdr-accountingdoc
***            AND fiscalyear = @ls_hdr-fiscalyear AND companycode = @ls_hdr-companycode.
***            IF sy-subrc EQ 0.
***              COMMIT WORK AND WAIT.
***            ENDIF.
***          ENDLOOP.
***
***          ls_file_log-filename = lv_value.
***          ls_file_log-credt = sy-datum.
***          ls_file_log-counter = lv_cou.
***          MODIFY zdt_file_log FROM @ls_file_log.
***          IF sy-subrc EQ 0.
***            COMMIT WORK AND WAIT.
***          ENDIF.
***        ELSE.
***          ls_icici_pay-filename = lv_value.
***          ls_icici_pay-filecontent = lv_val.
***          ls_icici_pay-createdon = sy-datum.
***          ls_icici_pay-createdat = sy-timlo.
***          ls_icici_pay-response = ls_result.
***          MODIFY zdt_icici_pay FROM @ls_icici_pay.
***          IF sy-subrc EQ 0.
***            COMMIT WORK AND WAIT.
***          ENDIF.
***
***          ls_file_log-filename = lv_value.
***          ls_file_log-credt = sy-datum.
***          ls_file_log-counter = lv_cou.
***          MODIFY zdt_file_log FROM @ls_file_log.
***          IF sy-subrc EQ 0.
***            COMMIT WORK AND WAIT.
***          ENDIF.
***        ENDIF.
***
***        CLEAR lv_val.
***      CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error).
***      CATCH cx_web_http_client_error INTO DATA(web_http_client_error).
***    ENDTRY.
***
****//-------------------------------------------------------------------------//

    SELECT *
    FROM zexim_lcim_bnk1
    INTO TABLE @DATA(lt_zexim_lcim_bnk1).
    IF lt_zexim_lcim_bnk1 IS NOT INITIAL.
      LOOP AT lt_zexim_lcim_bnk1 INTO DATA(ls_zexim_lcim_bnk1).
        SELECT SINGLE *
            FROM zr_bank_limit
            WHERE bukrs = @ls_zexim_lcim_bnk1-bukrs
              AND hktid = @ls_zexim_lcim_bnk1-hktid
              AND hbkid = @ls_zexim_lcim_bnk1-hbkid
              INTO @DATA(ls_banklimit).
        IF ls_banklimit IS NOT INITIAL.
          ls_zexim_lcim_bnk1-bgcleanutilised = ls_banklimit-bgutilised.
          ls_zexim_lcim_bnk1-bgcleanavailable = ls_zexim_lcim_bnk1-bglimit - ls_banklimit-bgutilised.
          MODIFY zexim_lcim_bnk1 FROM @ls_zexim_lcim_bnk1.
          COMMIT WORK AND WAIT.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
