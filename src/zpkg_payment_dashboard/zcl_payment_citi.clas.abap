CLASS zcl_payment_citi DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS default_inventory_id          TYPE c LENGTH 1                        VALUE '1'.
    CONSTANTS wait_time_in_seconds          TYPE i                                 VALUE 5.
    CONSTANTS selection_name                TYPE c LENGTH 8                        VALUE 'PAY'.
    CONSTANTS selection_description         TYPE c LENGTH 255                      VALUE 'PAY DATA'.
    CONSTANTS application_log_object_name   TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_CITIPAY_01_LOG'.
    CONSTANTS application_log_sub_obj1_name TYPE if_bali_object_handler=>ty_object VALUE 'ZAPP_CITIPAY_01_SUB'.

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



CLASS ZCL_PAYMENT_CITI IMPLEMENTATION.


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
                              header = cl_bali_header_setter=>create( object      = 'ZAPP_CITIPAY_01_LOG'
                                                                      subobject   = 'ZAPP_CITIPAY_01_SUB'
                                                                      external_id = 'External ID' ) ).
      CATCH cx_bali_runtime.
        "handle exception
    ENDTRY.
  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    TYPES: BEGIN OF ty_citi_hed,
             accountingdoc TYPE belnr_d,
             fiscalyear    TYPE gjahr,
             companycode   TYPE bukrs,
             msgid         TYPE string,
             credttm       TYPE string,
             ctrlsum       TYPE string,
             cname         TYPE string,
             reqdexctndt   TYPE string,
             housebank     TYPE string,
             payamt        TYPE string,
             vifsc         TYPE string,
             vname         TYPE string,
             vadd          TYPE string,
             vadd1         TYPE string,
             vacc          TYPE string,
             remarks       TYPE string,
             xmlval        TYPE string,
           END OF ty_citi_hed ,
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
           END OF ty_icici_itm..

    DATA: lt_citi_hed     TYPE STANDARD TABLE OF ty_citi_hed,
          lt_citi_itm     TYPE STANDARD TABLE OF ty_icici_itm,
          ls_citi_pay     TYPE zdt_citi_pay,
          ls_file_logciti TYPE zdt_file_logciti.

    DATA: lv_date_h      TYPE datn,
          lv_time_h      TYPE timn,
          lv_val         TYPE string,
          lv_timestamp_l TYPE timestamp,
          lv_len         TYPE i,
          lv_string      TYPE string.
    DATA: lv_inv     TYPE char10,
          lv_invdate TYPE char10,
          lv_invamnt TYPE char12,
          lv_tdsamnt TYPE char12,
          lv_netamnt TYPE char12.

    CONSTANTS: lc_val TYPE char3 VALUE '@/@'.

    DATA: lr_citi TYPE RANGE OF hbkid.

    CLEAR: lr_citi[].
*---------------------------------------------------------------------------------------------------
    lr_citi = VALUE #( sign = 'I' option = 'CP' ( low = 'CTB*'  ) ).

    SELECT * FROM zdt_payment_head
     WHERE approved = 'X' AND status = 'Approved' AND housebank IN @lr_citi
     INTO TABLE @DATA(lt_citi_payhdr).

    CHECK sy-subrc EQ 0 AND lt_citi_payhdr IS NOT INITIAL.

    SELECT a~* FROM zv_payment_item_citi_1 AS a
             INNER JOIN @lt_citi_payhdr AS b ON a~accountingdocument = b~accountingdoc AND
                                                 a~fiscalyear         = b~fiscalyear AND
                                                 a~companycode        = b~companycode
             INTO TABLE @DATA(lt_citit_payitm).

*//--get org mail id
    SELECT b~supplier,a~email
            FROM zdt_orgemail AS a
             INNER JOIN i_supplier AS b ON a~ktokk = b~supplieraccountgroup
             INNER JOIN @lt_citi_payhdr AS c ON b~supplier = c~supplier
           INTO TABLE @DATA(lt_orgmail)  .

    SELECT a~accountingdoc, a~fiscalyear, a~companycode, c~accountingdoccreatedbyuser,
          b~personfullname
     FROM @lt_citi_payhdr AS a
     INNER JOIN i_journalentry AS c ON  c~accountingdocument = a~accountingdoc
                                    AND c~companycode = a~companycode
                                    AND c~fiscalyear  = a~fiscalyear
     INNER JOIN i_businessuserbasic AS b ON b~userid = c~accountingdoccreatedbyuser
     GROUP BY a~accountingdoc, a~fiscalyear, a~companycode, c~accountingdoccreatedbyuser,
              b~personfullname
     INTO TABLE @DATA(lt_user).


    FREE:lt_citi_hed, lt_citi_itm.

    LOOP AT lt_citi_payhdr INTO DATA(ls_citi_payhdr) WHERE approved = 'X' AND status    = 'Approved'.

      APPEND INITIAL LINE TO lt_citi_hed ASSIGNING FIELD-SYMBOL(<fs_citi_hed>).

      <fs_citi_hed>-accountingdoc = ls_citi_payhdr-accountingdoc.
      <fs_citi_hed>-fiscalyear    = ls_citi_payhdr-fiscalyear .
      <fs_citi_hed>-companycode   = ls_citi_payhdr-companycode.

*//---Message ID
      <fs_citi_hed>-msgid = ls_citi_payhdr-accountingdoc && ls_citi_payhdr-fiscalyear+2(2) && ls_citi_payhdr-companycode.


*//------------------Get Date Time from Time Stamp -----------//
      TRY.
          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
                  INTO TIME STAMP DATA(lv_timestamp) TIME ZONE '' ."cl_abap_context_info=>get_user_time_zone( ).
        CATCH cx_abap_context_info_error.
      ENDTRY.

      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date_h TIME lv_time_h.

      <fs_citi_hed>-credttm = lv_date_h+0(4) && '-' && lv_date_h+4(2) && '-'  && lv_date_h+6(2) && 'T'
                                             && lv_time_h+0(2) && ':' && lv_time_h+2(2) && ':' && lv_time_h+4(2).


      <fs_citi_hed>-ctrlsum = ls_citi_payhdr-amountincompanycodecurrency * -1.
      <fs_citi_hed>-cname = 'Crescent Foundry Limited'.

      <fs_citi_hed>-reqdexctndt = lv_date_h+0(4) && '-' && lv_date_h+4(2) && '-'  && lv_date_h+6(2) .

      <fs_citi_hed>-housebank = ls_citi_payhdr-bankaccountnumber.
      <fs_citi_hed>-vifsc     = ls_citi_payhdr-payeebankkey.
      <fs_citi_hed>-vname     = ls_citi_payhdr-suppliername.
      <fs_citi_hed>-vacc      = ls_citi_payhdr-payeebankaccount.
      <fs_citi_hed>-vadd      = ''.
      <fs_citi_hed>-vadd1     = ''.
*------------------------------------------------------------------------------------------------------------------------
***      LOOP AT lt_citit_payitm INTO DATA(ls_citit_payitm) WHERE accountingdocument = ls_citi_payhdr-accountingdoc AND
***                                                               fiscalyear         = ls_citi_payhdr-fiscalyear AND
***                                                               companycode        = ls_citi_payhdr-companycode .
***        lv_inv = ls_citit_payitm-supplierinvoice.
***        lv_invdate = sy-datlo+6(2) && '/' && sy-datlo+4(2) && '/' && sy-datlo+0(4).
***        lv_invamnt = ls_citit_payitm-amountincompanycodecurrency * -1.
***        lv_tdsamnt = ls_citit_payitm-withholdingtaxamount * -1.
***        lv_netamnt = lv_invamnt + lv_tdsamnt.
***        CONCATENATE lv_inv lv_invdate lv_invamnt lv_tdsamnt lv_netamnt INTO DATA(lv_remarks) SEPARATED BY ' '.
***        <fs_citi_hed>-remarks   = lv_remarks.
***      ENDLOOP.

      lv_inv     = ls_citi_payhdr-accountingdoc.
      lv_invdate = ls_citi_payhdr-documentdate+6(2) && '.' && ls_citi_payhdr-documentdate+4(2) && '.' && ls_citi_payhdr-documentdate+0(4).

      CONCATENATE lv_inv lv_invdate INTO <fs_citi_hed>-remarks RESPECTING BLANKS.

      lv_string = <fs_citi_hed>-ctrlsum.CONDENSE lv_string.
      lv_len = 12 - strlen( lv_string ).
      DO lv_len TIMES.
        CONCATENATE lv_string lc_val INTO lv_string .
      ENDDO.
      CONCATENATE <fs_citi_hed>-remarks lv_string INTO <fs_citi_hed>-remarks RESPECTING BLANKS.

      lv_string =  ''.CONDENSE lv_string.
      lv_len = 12 - strlen( lv_string ).
      DO lv_len TIMES.
        CONCATENATE lv_string lc_val INTO lv_string .
      ENDDO.
      CONCATENATE <fs_citi_hed>-remarks lv_string INTO <fs_citi_hed>-remarks RESPECTING BLANKS.

      lv_string = <fs_citi_hed>-ctrlsum. CONDENSE lv_string.
      lv_len = 12 - strlen( lv_string ).
      DO lv_len TIMES.
        CONCATENATE lv_string lc_val INTO lv_string .
      ENDDO.
      CONCATENATE <fs_citi_hed>-remarks lv_string INTO <fs_citi_hed>-remarks RESPECTING BLANKS.

*------------------------------------------------------------------------------------------------------------------------
    ENDLOOP.

*//-------------------------------------------------------------------------//
    CHECK lt_citi_hed IS NOT INITIAL .

    LOOP AT lt_citi_hed ASSIGNING <fs_citi_hed>.
      CLEAR lv_val .
      lv_val = |<?xml version = '1.0' encoding = 'UTF-8'?>| &&
               |<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">| &&
               |<CstmrCdtTrfInitn>|.

      lv_val = lv_val && '<GrpHdr><MsgId>' && <fs_citi_hed>-msgid && '</MsgId>'.
      lv_val = lv_val && '<CreDtTm>' && <fs_citi_hed>-credttm && '</CreDtTm><NbOfTxs>1</NbOfTxs>'.
      lv_val = lv_val && '<CtrlSum>' && <fs_citi_hed>-ctrlsum && '</CtrlSum><InitgPty>'.
      lv_val = lv_val && '<Nm>' && <fs_citi_hed>-cname && '</Nm></InitgPty></GrpHdr><PmtInf>'.
      lv_val = lv_val && '<PmtInfId>' && <fs_citi_hed>-msgid && |</PmtInfId><PmtMtd>TRF</PmtMtd>| &&
                 |<PmtTpInf><InstrPrty>NORM</InstrPrty><SvcLvl><Cd>URNS</Cd></SvcLvl><LclInstrm><Prtry>CITI540</Prtry>| &&
                 |</LclInstrm><CtgyPurp><Cd>SUPP</Cd></CtgyPurp></PmtTpInf>| .
      lv_val = lv_val && '<ReqdExctnDt>' && <fs_citi_hed>-reqdexctndt && '</ReqdExctnDt><Dbtr>'.
      lv_val = lv_val && '<Nm>' && <fs_citi_hed>-cname && '</Nm></Dbtr><DbtrAcct>'.
      lv_val = lv_val && '<Id><Othr><Id>' && <fs_citi_hed>-housebank && '</Id></Othr></Id></DbtrAcct><DbtrAgt><FinInstnId>' &&
               '<BIC>CITIINBXIBC</BIC></FinInstnId></DbtrAgt><ChrgBr>SLEV</ChrgBr><CdtTrfTxInf><PmtId>'.
      lv_val = lv_val && '<InstrId>' && <fs_citi_hed>-msgid && '</InstrId><EndToEndId>' &&
                        <fs_citi_hed>-msgid && '</EndToEndId></PmtId><Amt>'.
      lv_val = lv_val && '<InstdAmt Ccy="INR">' && <fs_citi_hed>-ctrlsum && '</InstdAmt></Amt><CdtrAgt><FinInstnId><ClrSysMmbId>'.
      lv_val = lv_val && '<MmbId>' && <fs_citi_hed>-vifsc && '</MmbId></ClrSysMmbId></FinInstnId></CdtrAgt><Cdtr>'.
      lv_val = lv_val && '<Nm>' && <fs_citi_hed>-vname && '</Nm><PstlAdr><Ctry>IN</Ctry>'.
      lv_val = lv_val && '<AdrLine>' && <fs_citi_hed>-vadd && '</AdrLine>'.
      lv_val = lv_val && '<AdrLine>' && <fs_citi_hed>-vadd1 && '</AdrLine></PstlAdr></Cdtr><CdtrAcct><Id><Othr>'.
      lv_val = lv_val && '<Id>' && <fs_citi_hed>-vacc && '</Id></Othr></Id><Tp><Cd>CACC</Cd></Tp></CdtrAcct><Purp><Cd>SUPP</Cd></Purp><RmtInf>'.
*-------------------------------------------------------------------------------------------------------------------------
      READ TABLE lt_citit_payitm TRANSPORTING NO FIELDS WITH KEY accountingdocument = <fs_citi_hed>-accountingdoc
                                                                 fiscalyear         = <fs_citi_hed>-fiscalyear
                                                                 companycode        = <fs_citi_hed>-companycode .
      IF sy-subrc EQ 0.
        LOOP AT lt_citit_payitm INTO DATA(ls_citit_payitm) WHERE accountingdocument = <fs_citi_hed>-accountingdoc AND
                                                                 fiscalyear         = <fs_citi_hed>-fiscalyear AND
                                                                 companycode        = <fs_citi_hed>-companycode .
          CLEAR:<fs_citi_hed>-remarks,lv_string.

          lv_inv     = ls_citit_payitm-supplierinvoice.
          lv_invdate = ls_citit_payitm-documentdate+6(2) && '.' && ls_citit_payitm-documentdate+4(2) && '.' && ls_citit_payitm-documentdate+0(4).

          CONCATENATE lv_inv lv_invdate INTO <fs_citi_hed>-remarks RESPECTING BLANKS.

          lv_string = ls_citit_payitm-amountincompanycodecurrency.CONDENSE lv_string.
          lv_len = 12 - strlen( lv_string ).
          DO lv_len TIMES.
            CONCATENATE lv_string lc_val INTO lv_string .
          ENDDO.
          CONCATENATE <fs_citi_hed>-remarks lv_string INTO <fs_citi_hed>-remarks RESPECTING BLANKS.


          lv_string = ls_citit_payitm-withholdingtaxamount.CONDENSE lv_string.
          lv_len = 12 - strlen( lv_string ).
          DO lv_len TIMES.
            CONCATENATE lv_string lc_val INTO lv_string .
          ENDDO.
          CONCATENATE <fs_citi_hed>-remarks lv_string INTO <fs_citi_hed>-remarks RESPECTING BLANKS.

          lv_string = ls_citit_payitm-amountincompanycodecurrency +
                      ls_citit_payitm-withholdingtaxamount.  CONDENSE lv_string.
          lv_len = 12 - strlen( lv_string ).
          DO lv_len TIMES.
            CONCATENATE lv_string lc_val INTO lv_string .
          ENDDO.
          CONCATENATE <fs_citi_hed>-remarks lv_string INTO <fs_citi_hed>-remarks RESPECTING BLANKS.

          lv_val = lv_val && '<Ustrd>' && <fs_citi_hed>-remarks && '</Ustrd>'.
        ENDLOOP.
      ELSE.
        lv_val = lv_val && '<Ustrd>' && <fs_citi_hed>-remarks && '</Ustrd>'.
      ENDIF.

*-----------------------------------------------------------------------------------------------------------------------

      lv_val = lv_val && '</RmtInf></CdtTrfTxInf></PmtInf></CstmrCdtTrfInitn></Document>'.
      CONDENSE lv_val .

      <fs_citi_hed>-xmlval = lv_val .


      TRY.
          DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario = 'ZFI_SC_CITIPAY'
                                                                                           service_id    = 'ZSB_CITI_PAYMENT_REST' ).
          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          DATA(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |text/plain| ).

          DATA : lv_cou  TYPE numc2,
                 lv_date TYPE datn,
                 lv_time TYPE timn.

          CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
          SELECT SINGLE MAX( counter ) FROM zdt_file_log WHERE credt = @sy-datlo  INTO @lv_cou.
          lv_cou = lv_cou + 1.

          DATA : lv_date_1 TYPE char8.

          lv_date_1 = lv_date+6(2) && lv_date+4(2) && lv_date+0(4).

*          lv_value = 'CRCPL_CRCPLAPIUPLD_' && lv_date_1  && '_' && lv_cou && '.txt'.
*          lo_request->set_header_field( i_name = |FileName| i_value = lv_value ).
          lo_request->set_text( lv_val ).
          DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          lo_http_client->close(  ).

          IF ls_result IS NOT INITIAL AND ls_result CS 'PDNG'.

            UPDATE zdt_payment_head SET status = 'Sent to Bank'
                                    WHERE accountingdoc = @<fs_citi_hed>-accountingdoc
                                      AND fiscalyear    = @<fs_citi_hed>-fiscalyear
                                      AND companycode   = @<fs_citi_hed>-companycode.
            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.

          ELSE.
            UPDATE zdt_payment_head SET status = 'Failed'
                                    WHERE accountingdoc = @<fs_citi_hed>-accountingdoc
                                      AND fiscalyear    = @<fs_citi_hed>-fiscalyear
                                      AND companycode   = @<fs_citi_hed>-companycode.
            IF sy-subrc EQ 0.
              COMMIT WORK AND WAIT.
            ENDIF.

          ENDIF.

          ls_file_logciti-accountingdoc = <fs_citi_hed>-accountingdoc.
          ls_file_logciti-fiscalyear    = <fs_citi_hed>-fiscalyear.
          ls_file_logciti-companycode   = <fs_citi_hed>-companycode.
          ls_file_logciti-msgid         = <fs_citi_hed>-msgid.
          ls_file_logciti-credt         = sy-datlo.
          ls_file_logciti-counter       = lv_cou.
          MODIFY zdt_file_logciti FROM @ls_file_logciti.
          IF sy-subrc EQ 0.
            COMMIT WORK AND WAIT.
          ENDIF.

          CLEAR lv_val.
        CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error).
        CATCH cx_web_http_client_error INTO DATA(web_http_client_error).
      ENDTRY.

    ENDLOOP.
*//-------------------------------------------------------------------------//

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
    TRY.
        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
        out->write( |Finished| ).
      CATCH cx_root INTO FINAL(job_scheduling_exception).
    ENDTRY.

***    DATA et_parameters TYPE if_apj_rt_exec_object=>tt_templ_val.
***
***
***    TYPES: BEGIN OF ty_citi_hed,
***             accountingdoc TYPE belnr_d,
***             fiscalyear    TYPE gjahr,
***             companycode   TYPE bukrs,
***             msgid         TYPE string,
***             credttm       TYPE string,
***             ctrlsum       TYPE string,
***             cname         TYPE string,
***             reqdexctndt   TYPE string,
***             housebank     TYPE string,
***             payamt        TYPE string,
***             vifsc         TYPE string,
***             vname         TYPE string,
***             vadd          TYPE string,
***             vadd1         TYPE string,
***             vacc          TYPE string,
***             remarks       TYPE string,
***             xmlval        TYPE string,
***           END OF ty_citi_hed ,
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
***           END OF ty_icici_itm..
***
***    DATA: lt_citi_hed     TYPE STANDARD TABLE OF ty_citi_hed,
***          lt_citi_itm TYPE STANDARD TABLE OF ty_icici_itm,
***          ls_citi_pay TYPE zdt_citi_pay,
***          ls_file_logciti TYPE zdt_file_logciti.
***
***    DATA: lv_date_h      TYPE datn,
***          lv_time_h      TYPE timn,
***          lv_val         TYPE string,
***          lv_timestamp_l TYPE timestamp.
***    DATA: lv_inv  type char10,
***          lv_invdate type char10,
***          lv_invamnt type char12,
***          lv_tdsamnt type char12,
***          lv_netamnt type char12.
***
***    DATA: lr_citi TYPE RANGE OF hbkid.
***
***    CLEAR: lr_citi[].
****---------------------------------------------------------------------------------------------------
***    lr_citi = VALUE #( sign = 'I' option = 'CP' ( low = 'CTB*'  ) ).
***
***    SELECT * FROM zdt_payment_head
***     WHERE approved = 'X' AND status = 'Approved' AND housebank IN @lr_citi
***     INTO TABLE @DATA(lt_citi_payhdr).
***
***    CHECK sy-subrc EQ 0 AND lt_citi_payhdr IS NOT INITIAL.
***
***    SELECT a~* FROM ZV_PAYMENT_ITEM_CITI AS a
***             INNER JOIN @lt_citi_payhdr AS b ON a~accountingdocument = b~accountingdoc AND
***                                                 a~fiscalyear         = b~fiscalyear AND
***                                                 a~companycode        = b~companycode
***             INTO TABLE @DATA(lt_citit_payitm).
***
****//--get org mail id
***    SELECT b~supplier,a~email
***            FROM zdt_orgemail AS a
***             INNER JOIN i_supplier AS b ON a~ktokk = b~supplieraccountgroup
***             INNER JOIN @lt_citi_payhdr AS c ON b~supplier = c~supplier
***           INTO TABLE @DATA(lt_orgmail)  .
***
***     SELECT a~accountingdoc, a~fiscalyear, a~companycode, c~accountingdoccreatedbyuser,
***           b~personfullname
***      FROM @lt_citi_payhdr AS a
***      INNER JOIN i_journalentry AS c ON  c~accountingdocument = a~accountingdoc
***                                     AND c~companycode = a~companycode
***                                     AND c~fiscalyear  = a~fiscalyear
***      INNER JOIN i_businessuserbasic AS b ON b~userid = c~accountingdoccreatedbyuser
***      GROUP BY a~accountingdoc, a~fiscalyear, a~companycode, c~accountingdoccreatedbyuser,
***               b~personfullname
***      INTO TABLE @DATA(lt_user).
***
***
***    FREE:lt_citi_hed, lt_citi_itm.
***
***    LOOP AT lt_citi_payhdr INTO DATA(ls_citi_payhdr) WHERE approved = 'X' AND status    = 'Approved'.
***
***      APPEND INITIAL LINE TO lt_citi_hed ASSIGNING FIELD-SYMBOL(<fs_citi_hed>).
***
***      <fs_citi_hed>-accountingdoc = ls_citi_payhdr-accountingdoc.
***      <fs_citi_hed>-fiscalyear    = ls_citi_payhdr-fiscalyear .
***      <fs_citi_hed>-companycode   = ls_citi_payhdr-companycode.
***
****//---Message ID
***      <fs_citi_hed>-msgid = ls_citi_payhdr-accountingdoc && ls_citi_payhdr-fiscalyear+2(2) && ls_citi_payhdr-companycode.
***
***
****//------------------Get Date Time from Time Stamp -----------//
***      TRY.
***          CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
***                  INTO TIME STAMP DATA(lv_timestamp) TIME ZONE '' ."cl_abap_context_info=>get_user_time_zone( ).
***        CATCH cx_abap_context_info_error.
***      ENDTRY.
***
***      CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date_h TIME lv_time_h.
***
***      <fs_citi_hed>-credttm = lv_date_h+0(4) && '-' && lv_date_h+4(2) && '-'  && lv_date_h+6(2) && 'T'
***                                             && lv_time_h+0(2) && ':' && lv_time_h+2(2) && ':' && lv_time_h+4(2).
***
***
***      <fs_citi_hed>-ctrlsum = ls_citi_payhdr-amountincompanycodecurrency * -1.
***      <fs_citi_hed>-cname = 'Crescent Foundry Limited'.
***
***      <fs_citi_hed>-reqdexctndt = lv_date_h+0(4) && '-' && lv_date_h+4(2) && '-'  && lv_date_h+6(2) .
***
***      <fs_citi_hed>-housebank = ls_citi_payhdr-bankaccountnumber.
***      <fs_citi_hed>-vifsc     = ls_citi_payhdr-payeebankkey.
***      <fs_citi_hed>-vname     = ls_citi_payhdr-suppliername.
***      <fs_citi_hed>-vacc      = ls_citi_payhdr-payeebankaccount.
***      <fs_citi_hed>-vadd      = ''.
***      <fs_citi_hed>-vadd1     = ''.
***      LOOP AT lt_citit_payitm INTO DATA(ls_citit_payitm) WHERE accountingdocument = ls_citi_payhdr-accountingdoc AND
***                                                               fiscalyear         = ls_citi_payhdr-fiscalyear AND
***                                                               companycode        = ls_citi_payhdr-companycode .
***       lv_inv = ls_citit_payitm-supplierinvoice.
***       lv_invdate = sy-datlo+6(2) && '/' && sy-datlo+4(2) && '/' && sy-datlo+0(4).
***       lv_invamnt = ls_citit_payitm-amountincompanycodecurrency * -1.
***       lv_tdsamnt = ls_citit_payitm-withholdingtaxamount * -1.
***       lv_netamnt = lv_invamnt + lv_tdsamnt.
***       CONCATENATE lv_inv lv_invdate lv_invamnt lv_tdsamnt lv_netamnt into data(lv_remarks) SEPARATED BY ' '.
***      <fs_citi_hed>-remarks   = lv_remarks.
***      endloop.
***
***    ENDLOOP.
***
****//-------------------------------------------------------------------------//
***    CHECK lt_citi_hed IS NOT INITIAL .
***
***    LOOP AT lt_citi_hed ASSIGNING <fs_citi_hed>.
***      CLEAR lv_val .
***      lv_val = |<?xml version = '1.0' encoding = 'UTF-8'?>| &&
***               |<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">| &&
***               |<CstmrCdtTrfInitn>|.
***
***      lv_val = lv_val && '<GrpHdr><MsgId>' && <fs_citi_hed>-msgid && '</MsgId>'.
***      lv_val = lv_val && '<CreDtTm>' && <fs_citi_hed>-credttm && '</CreDtTm><NbOfTxs>1</NbOfTxs>'.
***      lv_val = lv_val && '<CtrlSum>' && <fs_citi_hed>-ctrlsum && '</CtrlSum><InitgPty>'.
***      lv_val = lv_val && '<Nm>' && <fs_citi_hed>-cname && '</Nm></InitgPty></GrpHdr><PmtInf>'.
***      lv_val = lv_val && '<PmtInfId>' && <fs_citi_hed>-msgid && |</PmtInfId><PmtMtd>TRF</PmtMtd>| &&
***                 |<PmtTpInf><InstrPrty>NORM</InstrPrty><SvcLvl><Cd>URNS</Cd></SvcLvl><LclInstrm><Prtry>CITI540</Prtry>| &&
***                 |</LclInstrm><CtgyPurp><Cd>SUPP</Cd></CtgyPurp></PmtTpInf>| .
***      lv_val = lv_val && '<ReqdExctnDt>' && <fs_citi_hed>-reqdexctndt && '</ReqdExctnDt><Dbtr>'.
***      lv_val = lv_val && '<Nm>' && <fs_citi_hed>-cname && '</Nm></Dbtr><DbtrAcct>'.
***      lv_val = lv_val && '<Id><Othr><Id>' && <fs_citi_hed>-housebank && '</Id></Othr></Id></DbtrAcct><DbtrAgt><FinInstnId>' &&
***               '<BIC>CITIINBXIBC</BIC></FinInstnId></DbtrAgt><ChrgBr>SLEV</ChrgBr><CdtTrfTxInf><PmtId>'.
***      lv_val = lv_val && '<InstrId>' && <fs_citi_hed>-msgid && '</InstrId><EndToEndId>' &&
***                        <fs_citi_hed>-msgid && '</EndToEndId></PmtId><Amt>'.
***      lv_val = lv_val && '<InstdAmt Ccy="INR">' && <fs_citi_hed>-ctrlsum && '</InstdAmt></Amt><CdtrAgt><FinInstnId><ClrSysMmbId>'.
***      lv_val = lv_val && '<MmbId>' && <fs_citi_hed>-vifsc && '</MmbId></ClrSysMmbId></FinInstnId></CdtrAgt><Cdtr>'.
***      lv_val = lv_val && '<Nm>' && <fs_citi_hed>-vname && '</Nm><PstlAdr><Ctry>IN</Ctry>'.
***      lv_val = lv_val && '<AdrLine>' && <fs_citi_hed>-vadd && '</AdrLine>'.
***      lv_val = lv_val && '<AdrLine>' && <fs_citi_hed>-vadd1 && '</AdrLine></PstlAdr></Cdtr><CdtrAcct><Id><Othr>'.
***      lv_val = lv_val && '<Id>' && <fs_citi_hed>-vacc && '</Id></Othr></Id><Tp><Cd>CACC</Cd></Tp></CdtrAcct><Purp><Cd>SUPP</Cd></Purp><RmtInf>'.
***      lv_val = lv_val && '<Ustrd>' && <fs_citi_hed>-remarks && '</Ustrd></RmtInf></CdtTrfTxInf></PmtInf></CstmrCdtTrfInitn></Document>'.
***      CONDENSE lv_val .
***
***      <fs_citi_hed>-xmlval = lv_val .
***
***
***      TRY.
***          DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario = 'ZFI_SC_CITIPAY'
***                                                                                           service_id    = 'ZSB_CITI_PAYMENT_REST' ).
***          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
***          DATA(lo_request) = lo_http_client->get_http_request( ).
***          lo_request->set_content_type( content_type = |text/plain| ).
***
***          DATA : lv_cou  TYPE numc2,
***                 lv_date TYPE datn,
***                 lv_time TYPE timn.
***
***          CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
***          SELECT SINGLE MAX( counter ) FROM zdt_file_log WHERE credt = @sy-datlo  INTO @lv_cou.
***          lv_cou = lv_cou + 1.
***
***          DATA : lv_date_1 TYPE char8.
***
***          lv_date_1 = lv_date+6(2) && lv_date+4(2) && lv_date+0(4).
***
****          lv_value = 'CRCPL_CRCPLAPIUPLD_' && lv_date_1  && '_' && lv_cou && '.txt'.
****          lo_request->set_header_field( i_name = |FileName| i_value = lv_value ).
***          lo_request->set_text( lv_val ).
***          DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
***          lo_http_client->close(  ).
***
***          IF ls_result IS NOT INITIAL AND ls_result CS 'PDNG'.
***
***            UPDATE zdt_payment_head SET status = 'Sent to Bank'
***                                    WHERE accountingdoc = @<fs_citi_hed>-accountingdoc
***                                      AND fiscalyear    = @<fs_citi_hed>-fiscalyear
***                                      AND companycode   = @<fs_citi_hed>-companycode.
***            IF sy-subrc EQ 0.
***              COMMIT WORK AND WAIT.
***            ENDIF.
***
***          ELSE.
***            UPDATE zdt_payment_head SET status = 'Failed'
***                                    WHERE accountingdoc = @<fs_citi_hed>-accountingdoc
***                                      AND fiscalyear    = @<fs_citi_hed>-fiscalyear
***                                      AND companycode   = @<fs_citi_hed>-companycode.
***            IF sy-subrc EQ 0.
***              COMMIT WORK AND WAIT.
***            ENDIF.
***
***          ENDIF.
***
***          ls_file_logciti-accountingdoc = <fs_citi_hed>-accountingdoc.
***          ls_file_logciti-fiscalyear    = <fs_citi_hed>-fiscalyear.
***          ls_file_logciti-companycode   = <fs_citi_hed>-companycode.
***          ls_file_logciti-msgid         = <fs_citi_hed>-msgid.
***          ls_file_logciti-credt         = sy-datlo.
***          ls_file_logciti-counter       = lv_cou.
***          MODIFY zdt_file_logciti FROM @ls_file_logciti.
***          IF sy-subrc EQ 0.
***            COMMIT WORK AND WAIT.
***          ENDIF.
***
***          CLEAR lv_val.
***        CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error).
***        CATCH cx_web_http_client_error INTO DATA(web_http_client_error).
***      ENDTRY.
***
***    ENDLOOP.
****//-------------------------------------------------------------------------//
***
***    TRY.
***        if_apj_rt_exec_object~execute( it_parameters = et_parameters ).
***        out->write( |Finished| ).
***      CATCH cx_root INTO FINAL(job_scheduling_exception).
***    ENDTRY.
  ENDMETHOD.
ENDCLASS.
