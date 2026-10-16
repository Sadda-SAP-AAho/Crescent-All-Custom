CLASS lhc_zi_payment_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_payment_head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_payment_head RESULT result.

    METHODS approve1 FOR MODIFY
      IMPORTING keys FOR ACTION zi_payment_head~approve1 RESULT result.

*    METHODS approve2 FOR MODIFY
*      IMPORTING keys FOR ACTION zi_payment_head~approve2 RESULT result.
*
*    METHODS approve3 FOR MODIFY
*      IMPORTING keys FOR ACTION zi_payment_head~approve3 RESULT result.

    METHODS reject1 FOR MODIFY
      IMPORTING keys FOR ACTION zi_payment_head~reject1 RESULT result.

    METHODS delete1 FOR MODIFY
      IMPORTING keys FOR ACTION zi_payment_head~delete1 RESULT result.
    METHODS senthsbc FOR MODIFY

      IMPORTING keys FOR ACTION zi_payment_head~senthsbc RESULT result.

*    METHODS Reject2 FOR MODIFY
*      IMPORTING keys FOR ACTION zi_payment_head~Reject2 RESULT result.
*
*    METHODS Reject3 FOR MODIFY
*      IMPORTING keys FOR ACTION zi_payment_head~Reject3 RESULT result.

ENDCLASS.

CLASS lhc_zi_payment_head IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zi_payment_head IN LOCAL MODE
                ENTITY zi_payment_head
                ALL FIELDS
                WITH CORRESPONDING #( keys )
                RESULT FINAL(header)
                " TODO: variable is assigned but never used (ABAP cleaner)
                FAILED FINAL(header_failed).
    ASSIGN header[ 1 ] TO FIELD-SYMBOL(<head>). .

    result = VALUE #(
        FOR gs_header IN header
        ( %tky                            = gs_header-%tky
          %action-delete1                    = COND #( WHEN <head>-status = 'Sent to Bank'
                                                    THEN if_abap_behv=>fc-o-disabled
                                                    ELSE if_abap_behv=>fc-o-enabled  )
        ) ).
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD approve1.
    DATA: lv_json_post TYPE string VALUE ''.
    TYPES: BEGIN OF ty_type,
             login_id               TYPE string,
             input_gcif             TYPE string,
             transfer_type_desc     TYPE string,
             bene_bank              TYPE string,
             input_debit_amount     TYPE string,
             input_value_date       TYPE string,
             transaction_type       TYPE string,
             input_debit_org_acc_no TYPE string,
             input_business_prod    TYPE string,
             bene_id                TYPE string,
             bene_acc_name          TYPE string,
             bene_acc_no            TYPE string,
             bene_type              TYPE string,
             bene_branch            TYPE string,
             bene_idn_code          TYPE string,
             payment_ref_no         TYPE string,
           END OF ty_type.
    DATA: ls_paysend TYPE ty_type.
    DATA(l_accdoc) = VALUE #(  keys[ 1 ]-accountingdoc OPTIONAL ).
    DATA(l_fiscyear) = VALUE #(  keys[ 1 ]-fiscalyear OPTIONAL ).
    DATA(l_comp) = VALUE #(  keys[ 1 ]-companycode OPTIONAL ).
    DATA l_apprlevel TYPE zdt_payment_head-apprlevel.
    SELECT SINGLE * FROM zdt_payment_head WHERE accountingdoc = @l_accdoc
    AND fiscalyear = @l_fiscyear AND companycode = @l_comp
    INTO @DATA(l_head).
    IF sy-subrc <> 0.
      l_apprlevel = 1.
      SELECT SINGLE userid FROM ztmg_appr_matrix WHERE companycode = @l_comp AND apprlevel = '1'
      AND userid = @sy-uname INTO @DATA(l_user).
      IF sy-subrc EQ 0.
        MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
               ENTITY zi_payment_head
                  UPDATE FROM VALUE #( FOR key IN keys
                                       ( accountingdoc      = key-accountingdoc
                                         fiscalyear         = key-fiscalyear
                                         companycode        = key-companycode
                                         appr1              = 'X' " Booked
                                         approved           = 'X'
                                         apprlevel          = l_apprlevel
                                         status             = 'Approved'
                                         %control-status    = if_abap_behv=>mk-on
                                         %control-appr1     = if_abap_behv=>mk-on
                                         %control-approved = if_abap_behv=>mk-on
                                         %control-apprlevel = if_abap_behv=>mk-on ) )
                  FAILED failed
                  REPORTED reported.

        "Read changed data for action result
        READ ENTITIES OF zi_payment_head IN LOCAL MODE
          ENTITY zi_payment_head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT DATA(heads).

        result = VALUE #( FOR head IN heads
                          ( %tky   = head-%tky
                            %param = head ) ).

        INSERT VALUE #(
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Approved' )
         ) INTO TABLE reported-zi_payment_head.
      ENDIF.
    ELSEIF l_head-appr1 = 'X' AND l_head-appr2 IS INITIAL AND l_head-appr3 IS INITIAL.
      l_apprlevel = l_head-apprlevel + 1.
      SELECT SINGLE userid FROM ztmg_appr_matrix WHERE companycode = @l_comp AND apprlevel = '2'
      AND userid = @sy-uname INTO @l_user.
      IF sy-subrc EQ 0.
        MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
               ENTITY zi_payment_head
                  UPDATE FROM VALUE #( FOR key IN keys
                                       ( accountingdoc      = key-accountingdoc
                                         fiscalyear         = key-fiscalyear
                                         companycode        = key-companycode
                                         appr2              = 'X' " Booked
                                         inprocess          = 'X'
                                         apprlevel          = l_apprlevel
                                         status             = 'In Approval'
                                         %control-status    = if_abap_behv=>mk-on
                                         %control-appr2     = if_abap_behv=>mk-on
                                         %control-inprocess = if_abap_behv=>mk-on
                                         %control-apprlevel = if_abap_behv=>mk-on ) )
                  FAILED failed
                  REPORTED reported.

        "Read changed data for action result
        READ ENTITIES OF zi_payment_head IN LOCAL MODE
          ENTITY zi_payment_head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT heads.

        result = VALUE #( FOR head IN heads
                          ( %tky   = head-%tky
                            %param = head ) ).

        INSERT VALUE #(
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Approved' )
        ) INTO TABLE reported-zi_payment_head.
      ENDIF.
    ELSEIF l_head-appr1 = 'X' AND l_head-appr2 = 'X' AND l_head-appr3 IS INITIAL.
      l_apprlevel = l_head-apprlevel + 1.
      SELECT SINGLE userid FROM ztmg_appr_matrix WHERE companycode = @l_comp AND apprlevel = '3'
      AND userid = @sy-uname INTO @l_user.
      IF sy-subrc EQ 0.
*         Data : lv_val TYPE string.
*
*         lv_val = 'I|N|DOCNEFT|ABC PVT. LTD.|10000|03/03/2025|000405000005|6792375809094|HDFC0003961|abc@gmail.com|1234567890|||test1\n'
*               && 'I|R|DOCRTGS|ABC PVT. LTD.|942112.00|03/03/2025|000405000005|6792375809094|HDFC0003961|abc@gmail.com|1234567890|||test2\n'
*               && 'I|I|DOCTRANSFER|ABC PVT. LTD.|39682.00|03/03/2025|000405000005|6792375809094|ICIC0003961|abc@gmail.com|1234567890|||test3\n'
*               && 'A|DOCNEFT|B2305678|03/03/2025|5600.00|0.00|56.00|0.00|5544.00|4000004343\n'
*               && 'A|DOCNEFT|B2305679|03/03/2025|4656.00|0.00|0.00|200.00|4456.00|4000004344\n'
*               && 'A|DOCRTGS|B2305680|03/03/2025|57112.00|0.00|0.00|0.00|57112.00|4000004345\n'
*               && 'A|DOCRTGS|B2305681|03/03/2025|893938.50|0.00|8938.50|0.00|885000.00|4000004346\n'
*               && 'A|DOCTRANSFER|B2305682|03/03/2025|40000.00|0.00|18.00|300.00|39682.00|4000004347'.
*
*        /ui2/cl_json=>serialize( EXPORTING data = lv_val RECEIVING r_json = lv_json_post ).

*        TRY.
*            DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario = 'ZFI_SC_ICICIPAY'
*                                                                                             service_id    = 'ZFI_ICICI_PAYMENT_REST' ).
*            DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
*            DATA(lo_request) = lo_http_client->get_http_request( ).
*            lo_request->set_content_type( content_type = |text/plain| ).
*            DATA : lv_value TYPE string,
*                   lv_cou   TYPE numc2,
*                   lv_date  TYPE datn,
*                   lv_time  TYPE timn.
*            TRY.
*                CONVERT DATE cl_abap_context_info=>get_system_date( ) TIME cl_abap_context_info=>get_system_time( )
*                        INTO TIME STAMP FINAL(lv_timestamp) TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
*              CATCH cx_abap_context_info_error.
*            ENDTRY.
*
*            CONVERT TIME STAMP lv_timestamp TIME ZONE 'INDIA' INTO DATE lv_date TIME lv_time.
*            SELECT SINGLE MAX( counter ) FROM zdt_file_log WHERE credt = @sy-datlo  INTO @lv_cou.
*            lv_cou = lv_cou + 1.
*
*
*            lv_value = 'LAFARGE_CRESCENTAPIUATUPLD_' && lv_date  && '_' && lv_cou && '.txt'.
*            lo_request->set_header_field( i_name = |FileName| i_value = lv_value ).
*            lo_request->set_text( lv_json_post ).
*            DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
*            lo_http_client->close(  ).
*
*            CLEAR lv_json_post.
*            IF ls_result CS ''.
        MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
            ENTITY zi_payment_head
               UPDATE FROM VALUE #( FOR key IN keys
                                    ( accountingdoc      = key-accountingdoc
                                      fiscalyear         = key-fiscalyear
                                      companycode        = key-companycode
                                      appr3              = 'X' " Booked
                                      inprocess          = ''
                                      approved           = 'X'
                                      apprlevel          = l_apprlevel
                                      status             = 'Approved'
                                      senton             = sy-datum
                                      sentat             = sy-uzeit
                                      sentby             = sy-uname
                                      %control-status    = if_abap_behv=>mk-on
                                      %control-appr3     = if_abap_behv=>mk-on
                                      %control-inprocess = if_abap_behv=>mk-on
                                      %control-approved  = if_abap_behv=>mk-on
                                      %control-apprlevel = if_abap_behv=>mk-on
                                      %control-senton = if_abap_behv=>mk-on
                                      %control-sentat = if_abap_behv=>mk-on
                                      %control-sentby = if_abap_behv=>mk-on ) )
               FAILED failed
               REPORTED reported.
*            ELSE.
*              MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
*                 ENTITY zi_payment_head
*                    UPDATE FROM VALUE #( FOR key IN keys
*                                         ( accountingdoc      = key-accountingdoc
*                                           fiscalyear         = key-fiscalyear
*                                           companycode        = key-companycode
*                                           appr3              = 'X' " Booked
*                                           inprocess          = ''
*                                           rejected           = 'X'
*                                           apprlevel          = l_apprlevel
*                                           status             = 'Failed'
*                                           appr2comment       = ls_result
*                                           senton             = sy-datum
*                                           sentat             = sy-uzeit
*                                           sentby             = sy-uname
*                                           %control-status    = if_abap_behv=>mk-on
*                                           %control-appr3     = if_abap_behv=>mk-on
*                                           %control-inprocess = if_abap_behv=>mk-on
*                                           %control-rejected  = if_abap_behv=>mk-on
*                                           %control-apprlevel = if_abap_behv=>mk-on
*                                           %control-appr2comment = if_abap_behv=>mk-on
*                                           %control-senton = if_abap_behv=>mk-on
*                                           %control-sentat = if_abap_behv=>mk-on
*                                           %control-sentby = if_abap_behv=>mk-on ) )
*                    FAILED failed
*                    REPORTED reported.
*            ENDIF.

        "Read changed data for action result
        READ ENTITIES OF zi_payment_head IN LOCAL MODE
          ENTITY zi_payment_head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT heads.

        result = VALUE #( FOR head IN heads
                          ( %tky   = head-%tky
                            %param = head ) ).

*          CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error).
*          CATCH cx_web_http_client_error INTO DATA(web_http_client_error).
*        ENDTRY.

        INSERT VALUE #(
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Approved' )
         ) INTO TABLE reported-zi_payment_head.
      ENDIF.
    ENDIF.
  ENDMETHOD.

*  METHOD approve2.
*  ENDMETHOD.
*
*  METHOD approve3.
*  ENDMETHOD.

  METHOD reject1.
    DATA(l_accdoc) = VALUE #(  keys[ 1 ]-accountingdoc OPTIONAL ).
    DATA(l_fiscyear) = VALUE #(  keys[ 1 ]-fiscalyear OPTIONAL ).
    DATA(l_comp) = VALUE #(  keys[ 1 ]-companycode OPTIONAL ).
    DATA l_apprlevel TYPE zdt_payment_head-apprlevel.
    DATA: lt_jr TYPE TABLE FOR ACTION IMPORT i_journalentrytp~reverse.

*    APPEND INITIAL LINE TO lt_jr ASSIGNING FIELD-SYMBOL(<jr>).
*    "Reversal BO
*    <jr>-companycode = l_comp.
*    <jr>-fiscalyear = l_fiscyear.
*    <jr>-accountingdocument = l_accdoc.
*    <jr>-%param = VALUE #(
*    postingdate    = sy-datlo
*    reversalreason = '01'
*    createdbyuser  = sy-uname ).
*
*    MODIFY ENTITIES OF i_journalentrytp FORWARDING PRIVILEGED
*    ENTITY journalentry
*    EXECUTE reverse FROM lt_jr
*    FAILED DATA(ls_failed)
*    REPORTED DATA(ls_reported)
*    MAPPED DATA(ls_mapped).
*    IF ls_failed-journalentry IS INITIAL.
*
*    ENDIF.
*    SELECT * FROM zdt_payment_head INTO TABLE @DATA(lt_del).
*    IF sy-subrc EQ 0.
*        DELETE zdt_payment_head FROM TABLE @lt_del.
*    ENDIF.

    SELECT SINGLE * FROM zdt_payment_head WHERE accountingdoc = @l_accdoc
    AND fiscalyear = @l_fiscyear AND companycode = @l_comp
    INTO @DATA(l_head).
    IF sy-subrc <> 0.
      l_apprlevel = 1.
      SELECT SINGLE userid FROM ztmg_appr_matrix WHERE companycode = @l_comp AND apprlevel = '1'
      AND userid = @sy-uname INTO @DATA(l_user).
      IF sy-subrc EQ 0.
        MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
               ENTITY zi_payment_head
                  UPDATE FROM VALUE #( FOR key IN keys
                                       ( accountingdoc      = key-accountingdoc
                                         fiscalyear         = key-fiscalyear
                                         companycode        = key-companycode
                                         reject1            = 'X' " Booked
                                         rejected           = 'X'
                                         inprocess          = ''
                                         apprlevel          = l_apprlevel
                                         status             = 'Rejected'
                                         %control-status    = if_abap_behv=>mk-on
                                         %control-reject1   = if_abap_behv=>mk-on
                                         %control-inprocess = if_abap_behv=>mk-on
                                         %control-rejected  = if_abap_behv=>mk-on
                                         %control-apprlevel = if_abap_behv=>mk-on ) )
                  FAILED failed
                  REPORTED reported.

        "Read changed data for action result
        READ ENTITIES OF zi_payment_head IN LOCAL MODE
          ENTITY zi_payment_head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT DATA(heads).

        result = VALUE #( FOR head IN heads
                          ( %tky   = head-%tky
                            %param = head
                            %cid_ref = if_abap_behv=>fc-o-disabled ) ).

        INSERT VALUE #(
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Rejected' )
         ) INTO TABLE reported-zi_payment_head.
      ENDIF.
    ELSEIF l_head-appr1 = 'X' AND l_head-appr2 IS INITIAL AND l_head-appr3 IS INITIAL.
      l_apprlevel = l_head-apprlevel + 1.
      SELECT SINGLE userid FROM ztmg_appr_matrix WHERE companycode = @l_comp AND apprlevel = '2'
      AND userid = @sy-uname INTO @l_user.
      IF sy-subrc EQ 0.
        MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
               ENTITY zi_payment_head
                  UPDATE FROM VALUE #( FOR key IN keys
                                       ( accountingdoc      = key-accountingdoc
                                         fiscalyear         = key-fiscalyear
                                         companycode        = key-companycode
                                         reject2            = 'X' " Booked
                                         rejected           = 'X'
                                         inprocess          = ''
                                         apprlevel          = l_apprlevel
                                         status             = 'Rejected'
                                         %control-status    = if_abap_behv=>mk-on
                                         %control-reject2   = if_abap_behv=>mk-on
                                         %control-inprocess = if_abap_behv=>mk-on
                                         %control-apprlevel = if_abap_behv=>mk-on
                                         %control-rejected  = if_abap_behv=>mk-on ) )
                  FAILED failed
                  REPORTED reported.

        "Read changed data for action result
        READ ENTITIES OF zi_payment_head IN LOCAL MODE
          ENTITY zi_payment_head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT heads.

        result = VALUE #( FOR head IN heads
                          ( %tky   = head-%tky
                            %param = head ) ).

        INSERT VALUE #(
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Rejected' )
         ) INTO TABLE reported-zi_payment_head.
      ENDIF.
    ELSEIF l_head-appr1 = 'X' AND l_head-appr2 = 'X' AND l_head-appr3 IS INITIAL.
      l_apprlevel = l_head-apprlevel + 1.
      SELECT SINGLE userid FROM ztmg_appr_matrix WHERE companycode = @l_comp AND apprlevel = '3'
      AND userid = @sy-uname INTO @l_user.
      IF sy-subrc EQ 0.
        MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
               ENTITY zi_payment_head
                  UPDATE FROM VALUE #( FOR key IN keys
                                       ( accountingdoc      = key-accountingdoc
                                         fiscalyear         = key-fiscalyear
                                         companycode        = key-companycode
                                         reject3            = 'X' " Booked
                                         rejected           = 'X'
                                         inprocess          = ''
                                         apprlevel          = l_apprlevel
                                         status             = 'Rejected'
                                         %control-status    = if_abap_behv=>mk-on
                                         %control-reject3   = if_abap_behv=>mk-on
                                         %control-inprocess = if_abap_behv=>mk-on
                                         %control-apprlevel = if_abap_behv=>mk-on
                                         %control-rejected  = if_abap_behv=>mk-on ) )
                  FAILED failed
                  REPORTED reported.

        "Read changed data for action result
        READ ENTITIES OF zi_payment_head IN LOCAL MODE
          ENTITY zi_payment_head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT heads.

        result = VALUE #( FOR head IN heads
                          ( %tky   = head-%tky
                            %param = head ) ).

        INSERT VALUE #(
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Rejected' )
         ) INTO TABLE reported-zi_payment_head.
      ENDIF.
    ENDIF.
  ENDMETHOD.

*  METHOD Reject2.
*  ENDMETHOD.
*
*  METHOD Reject3.
*  ENDMETHOD.

  METHOD delete1.

    DATA(l_accdoc) = VALUE #(  keys[ 1 ]-accountingdoc OPTIONAL ).
    DATA(l_fiscyear) = VALUE #(  keys[ 1 ]-fiscalyear OPTIONAL ).
    DATA(l_comp) = VALUE #(  keys[ 1 ]-companycode OPTIONAL ).

    MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
      ENTITY zi_payment_head
         UPDATE FROM VALUE #( FOR key IN keys
                              (
                              accountingdoc      = key-accountingdoc
                                fiscalyear         = key-fiscalyear
                                companycode        = key-companycode
                                delete_ind = 'X'
                                %control-delete_ind    = if_abap_behv=>mk-on
                                ) )
          FAILED failed
         REPORTED reported.


    READ ENTITIES OF zi_payment_head IN LOCAL MODE
       ENTITY zi_payment_head
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT DATA(heads).

    result = VALUE #( FOR head IN heads
                      ( %tky   = head-%tky
                        %param = head ) ).

    INSERT VALUE #(
%msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Deleted' )
) INTO TABLE reported-zi_payment_head.


  ENDMETHOD.



  METHOD senthsbc.

DATA lv_timestamp TYPE timestampl.
DATA lv_iso_ts TYPE string.
DATA lv_postdate TYPE string.
DATA lv_docdate TYPE string.
data : lv_msgid type string.
data : inv_amount type p DECIMALS 2.
data :   lv_strd     TYPE string.
data : lv_exctndt type string.

    READ ENTITIES OF zi_payment_head IN LOCAL MODE
       ENTITY zi_payment_head
       ALL FIELDS WITH
       CORRESPONDING #( keys )
       RESULT DATA(heads).

       READ ENTITIES OF zi_payment_head IN LOCAL MODE
  ENTITY zi_payment_head
  BY \_Item
  ALL FIELDS
  WITH CORRESPONDING #( keys )
  RESULT DATA(items).


DATA: lv_xml TYPE string.
DATA: lv_filename TYPE string.



lv_iso_ts =
|{ sy-datum+0(4) }-{ sy-datum+4(2) }-{ sy-datum+6(2) }T|
&&
|{ sy-uzeit+0(2) }:{ sy-uzeit+2(2) }:{ sy-uzeit+4(2) }|.

lv_exctndt = |{ sy-datum+0(4) }-{ sy-datum+4(2) }-{ sy-datum+6(2) }|.

loop at heads into data(ls_head).
select single BANKINTERNALID from I_HOUSEBANK where HouseBank = @ls_head-HouseBank into @data(BANKINTERNALID).
if sy-subrc = 0.
select single bankname from i_bank_2 where BankInternalID = @BANKINTERNALID into @data(bankname).
endif.

select single companycodename,addressid,country from i_companycode where CompanyCode = @ls_head-Companycode
into (@data(companycodename),@data(addressid),@data(Country)).

select single POSTALCODE,STREETNAME,COUNTRY from i_supplier where Supplier = @ls_head-Supplier into (@data(postalcode),@data(STREETNAME),@data(suppl_cntry)).


read table items into data(ls_item) with key AccountingDocument = ls_head-Accountingdoc.
if sy-subrc = 0.
data(invoice_no) = ls_item-SupplierInvoice.
data(document_date) = ls_item-DocumentDate.
data(inv_currency) = ls_item-CompanyCodeCurrency.
endif.

loop at items into ls_item where  accountingdocument = ls_head-accountingdoc.
inv_amount = inv_amount + ls_item-AmountInCompanyCodeCurrency.
endloop.

data(time) = cl_abap_context_info=>get_system_time(  ).
lv_msgid = |{ ls_head-PaymentRunID }{ time }|.

if inv_amount < 0.
inv_amount = abs( inv_amount ).
endif.

IF ls_head-AmountInCompanyCodeCurrency < 0.
ls_head-AmountInCompanyCodeCurrency = ABS( ls_head-AmountInCompanyCodeCurrency ).
ENDIF.

lv_filename = |{ 'xml_v3_' }{ ls_head-Accountingdoc }{ '_Neft.xml' }|.

lv_postdate =
|{ ls_head-PostingDate+0(4) }-{ ls_head-PostingDate+4(2) }-{ ls_head-PostingDate+6(2) }|.

lv_docdate =
|{ document_date+0(4) }-{ document_date+4(2) }-{ document_date+6(2) }|.



select single bankname from I_bank_2 where BankInternalID = @ls_head-PayeeBankKey into @data(payee_bank_name).

LOOP AT items INTO ls_item.



  lv_docdate =
  |{ ls_item-DocumentDate+0(4) }-{ ls_item-DocumentDate+4(2) }-{ ls_item-DocumentDate+6(2) }|.

  lv_strd = lv_strd &&

  |<Strd>| &&
  |<RfrdDocInf>| &&
*  |<Tp/>| &&
  |<Nb>{ ls_item-SupplierInvoice }</Nb>| &&
  |<RltdDt>{ lv_docdate }</RltdDt>| &&
  |</RfrdDocInf>| &&

  |<RfrdDocAmt>| &&
  |<DuePyblAmt Ccy="{ ls_item-CompanyCodeCurrency }">{ abs( ls_item-AmountInCompanyCodeCurrency ) }</DuePyblAmt>| &&
  |</RfrdDocAmt>| &&

  |<CdtrRefInf>| &&
  |<Tp><CdOrPrtry><Prtry>0.00</Prtry></CdOrPrtry></Tp>| &&
  |<Ref>{ abs( ls_item-AmountInCompanyCodeCurrency ) }</Ref>| &&
  |</CdtrRefInf>| &&
*  |<AddtlRmtInf>Payment Remarks</AddtlRmtInf>| &&
  |</Strd>| .


ENDLOOP.

lv_xml =
|<?xml version="1.0" encoding="UTF-8"?>| &&
|<Document xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.03" | &&
|xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">| &&
|<CstmrCdtTrfInitn>| &&

|<GrpHdr>| &&
|<MsgId>{ lv_msgid }</MsgId>| &&
|<CreDtTm>{  lv_iso_ts  }</CreDtTm>| &&                                  "2025-03-05T12:30:00
|<Authstn><Cd>ILEV</Cd></Authstn>| &&
|<NbOfTxs>1</NbOfTxs>| &&
|<CtrlSum>{ inv_amount }</CtrlSum>| &&
|<InitgPty>| &&
|<Nm>{ 'CRESCENT FOUNDRY CO PVT LTD' }</Nm>| &&
|<Id><OrgId><Othr><Id>PC000031945</Id></Othr></OrgId></Id>| &&
|</InitgPty>| &&
|</GrpHdr>| &&
*-------------------------------------------------------------------
* PAYMENT BLOCK 1
*-------------------------------------------------------------------

|<PmtInf>| &&
|<PmtInfId>{ ls_head-PaymentRunID }</PmtInfId>| &&
*|<PmtMtd>{ ls_head-PaymentMethod }</PmtMtd>| &&
|<PmtMtd>TRF</PmtMtd>| &&
|<PmtTpInf><SvcLvl><Cd>URNS</Cd></SvcLvl></PmtTpInf>| &&
*|<ReqdExctnDt>{ lv_postdate }</ReqdExctnDt>| &&
|<ReqdExctnDt>{  lv_exctndt }</ReqdExctnDt>| &&
|<Dbtr>| &&
|<Nm>{ companycodename }</Nm>| &&
|<PstlAdr>| &&
|<StrtNm>{ '4TH FLOOR, SUIT NO 406, LORDS BUILDING 7/1 LORD SINHA ROAD' }</StrtNm>| &&
|<PstCd>{ ' 700071' }</PstCd>| &&
|<TwnNm>{ 'KOLKATA' }</TwnNm>| &&
|<Ctry>{ Country }</Ctry>| &&
|</PstlAdr>| &&
|</Dbtr>| &&

|<DbtrAcct>| &&
|<Id><Othr><Id>{ ls_head-BankAccountNumber }</Id></Othr></Id>| &&
|<Ccy>{ ls_head-CompanyCodeCurrency }</Ccy>| &&
|</DbtrAcct>| &&

|<DbtrAgt>| &&
|<FinInstnId>| &&
|<BIC>{ 'HSBCINBB'  }</BIC>| &&
|<PstlAdr>| &&
|<Ctry>{ 'IN' }</Ctry>| &&
|</PstlAdr>| &&
|</FinInstnId>| &&
|</DbtrAgt>| &&

|<CdtTrfTxInf>| &&
|<PmtId>| &&
*|<InstrId>{ ls_head-PaymentRunID }</InstrId>| &&
|<InstrId>{ lv_msgid }</InstrId>| &&
*|<EndToEndId>{ ls_head-PaymentRunID }</EndToEndId>| &&
|<EndToEndId>{ lv_msgid }</EndToEndId>| &&
|</PmtId>| &&

|<Amt>| &&
|<InstdAmt Ccy="INR">{ ls_head-AmountInCompanyCodeCurrency }</InstdAmt>| &&
|</Amt>| &&

|<ChrgBr>DEBT</ChrgBr>| &&

|<CdtrAgt>| &&
|<FinInstnId>| &&
|<ClrSysMmbId><MmbId>{ ls_head-PayeeBankKey }</MmbId></ClrSysMmbId>| &&
|<Nm>{ payee_bank_name }</Nm>| &&
|</FinInstnId>| &&
|</CdtrAgt>| &&

|<Cdtr>| &&
|<Nm>{ ls_head-SupplierName }</Nm>| &&
|<PstlAdr>| &&
|<PstCd>{ postalcode }</PstCd>| &&
|<TwnNm>{ streetname }</TwnNm>| &&
|<CtrySubDvsn>01</CtrySubDvsn>| &&
|<Ctry>{ suppl_cntry }</Ctry>| &&
|</PstlAdr>| &&
|</Cdtr>| &&

|<CdtrAcct>| &&
|<Id><Othr><Id>{ ls_head-PayeeBankAccount }</Id></Othr></Id>| &&
|</CdtrAcct>| &&

|<RltdRmtInf>| &&
|<RmtLctnMtd>EMAL</RmtLctnMtd>| &&
|<RmtLctnElctrncAdr>bijay.agrawal@crescentfoundry.in</RmtLctnElctrncAdr>| &&
|</RltdRmtInf>| &&
|<RmtInf>| &&
|<Ustrd>PYMT NARRATION</Ustrd>| &&
lv_strd &&
|</RmtInf>| &&
|</CdtTrfTxInf>| &&
|</PmtInf>| &&
|</CstmrCdtTrfInitn>| &&
|</Document>|.



      TRY.
          DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario = 'ZFI_HSBC_PAY'
                                                                                           service_id    = 'ZFI_HSBC_REST' ).
          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          DATA(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |application/xml| ).


lo_request->set_header_field(
       i_name  = 'filename'
       i_value = lv_filename ).

       lo_request->set_header_field(
    i_name  = 'Connection'
    i_value = 'keep-alive' ).
                    lo_request->set_text( lv_xml ).
          DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          lo_http_client->close(  ).
        CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error).
        CATCH cx_web_http_client_error INTO DATA(web_http_client_error).
      ENDTRY.
endloop.



    DATA(l_accdoc) = VALUE #(  keys[ 1 ]-accountingdoc OPTIONAL ).
    DATA(l_fiscyear) = VALUE #(  keys[ 1 ]-fiscalyear OPTIONAL ).
    DATA(l_comp) = VALUE #(  keys[ 1 ]-companycode OPTIONAL ).
    DATA l_apprlevel TYPE zdt_payment_head-apprlevel.
    SELECT SINGLE * FROM zdt_payment_head WHERE accountingdoc = @l_accdoc
    AND fiscalyear = @l_fiscyear AND companycode = @l_comp
    INTO @DATA(l_head).
    IF sy-subrc <> 0.
      l_apprlevel = 1.
      SELECT SINGLE userid FROM ztmg_appr_matrix WHERE companycode = @l_comp AND apprlevel = '1'
      AND userid = @sy-uname INTO @DATA(l_user).
      IF sy-subrc EQ 0.
        MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
               ENTITY zi_payment_head
                  UPDATE FROM VALUE #( FOR key IN keys
                                       ( accountingdoc      = key-accountingdoc
                                         fiscalyear         = key-fiscalyear
                                         companycode        = key-companycode
                                         appr1              = 'X' " Booked
                                         approved           = 'X'
                                         apprlevel          = l_apprlevel
                                         status             = 'Sent to Bank'
                                         %control-status    = if_abap_behv=>mk-on
                                         %control-appr1     = if_abap_behv=>mk-on
                                         %control-approved = if_abap_behv=>mk-on
                                         %control-apprlevel = if_abap_behv=>mk-on ) )
                  FAILED failed
                  REPORTED reported.

        "Read changed data for action result
        READ ENTITIES OF zi_payment_head IN LOCAL MODE
          ENTITY zi_payment_head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT DATA(headss).

        result = VALUE #( FOR head IN headss
                          ( %tky   = head-%tky
                            %param = head ) ).

        INSERT VALUE #(
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Approved' )
         ) INTO TABLE reported-zi_payment_head.
      ENDIF.
    ELSEIF l_head-appr1 = 'X' AND l_head-appr2 IS INITIAL AND l_head-appr3 IS INITIAL.
      l_apprlevel = l_head-apprlevel + 1.
      SELECT SINGLE userid FROM ztmg_appr_matrix WHERE companycode = @l_comp AND apprlevel = '2'
      AND userid = @sy-uname INTO @l_user.
      IF sy-subrc EQ 0.
        MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
               ENTITY zi_payment_head
                  UPDATE FROM VALUE #( FOR key IN keys
                                       ( accountingdoc      = key-accountingdoc
                                         fiscalyear         = key-fiscalyear
                                         companycode        = key-companycode
                                         appr2              = 'X' " Booked
                                         inprocess          = 'X'
                                         apprlevel          = l_apprlevel
                                         status             = 'In Approval'
                                         %control-status    = if_abap_behv=>mk-on
                                         %control-appr2     = if_abap_behv=>mk-on
                                         %control-inprocess = if_abap_behv=>mk-on
                                         %control-apprlevel = if_abap_behv=>mk-on ) )
                  FAILED failed
                  REPORTED reported.

        "Read changed data for action result
        READ ENTITIES OF zi_payment_head IN LOCAL MODE
          ENTITY zi_payment_head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT heads.

        result = VALUE #( FOR head IN heads
                          ( %tky   = head-%tky
                            %param = head ) ).

        INSERT VALUE #(
         %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Approved' )
        ) INTO TABLE reported-zi_payment_head.
      ENDIF.
    ELSEIF l_head-appr1 = 'X' AND l_head-appr2 = 'X' AND l_head-appr3 IS INITIAL.
      l_apprlevel = l_head-apprlevel + 1.
      SELECT SINGLE userid FROM ztmg_appr_matrix WHERE companycode = @l_comp AND apprlevel = '3'
      AND userid = @sy-uname INTO @l_user.
      IF sy-subrc EQ 0.
        MODIFY ENTITIES OF zi_payment_head IN LOCAL MODE
            ENTITY zi_payment_head
               UPDATE FROM VALUE #( FOR key IN keys
                                    ( accountingdoc      = key-accountingdoc
                                      fiscalyear         = key-fiscalyear
                                      companycode        = key-companycode
                                      appr3              = 'X' " Booked
                                      inprocess          = ''
                                      approved           = 'X'
                                      apprlevel          = l_apprlevel
                                      status             = 'Sent to Bank'
                                      senton             = sy-datum
                                      sentat             = sy-uzeit
                                      sentby             = sy-uname
                                      %control-status    = if_abap_behv=>mk-on
                                      %control-appr3     = if_abap_behv=>mk-on
                                      %control-inprocess = if_abap_behv=>mk-on
                                      %control-approved  = if_abap_behv=>mk-on
                                      %control-apprlevel = if_abap_behv=>mk-on
                                      %control-senton = if_abap_behv=>mk-on
                                      %control-sentat = if_abap_behv=>mk-on
                                      %control-sentby = if_abap_behv=>mk-on ) )
               FAILED failed
               REPORTED reported.


      READ ENTITIES OF zi_payment_head IN LOCAL MODE
          ENTITY zi_payment_head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT heads.

        result = VALUE #( FOR head IN heads
                          ( %tky   = head-%tky
                            %param = head ) ).

*          CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error).
*          CATCH cx_web_http_client_error INTO DATA(web_http_client_error).
*        ENDTRY.

        INSERT VALUE #(
          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Approved' )
         ) INTO TABLE reported-zi_payment_head.
endif.
endif.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_payment_head DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_payment_head IMPLEMENTATION.

  METHOD save_modified.
    DATA : lt_head TYPE STANDARD TABLE OF zdt_payment_head,
           lt_log  TYPE STANDARD TABLE OF zdt_appr_log,
           lt_log1 TYPE STANDARD TABLE OF zdt_appr_log,
           ls_flog TYPE zdt_file_log.


    DATA: lt_head01 TYPE TABLE OF zdt_payment_head.
    DATA: lt_jr TYPE TABLE FOR ACTION IMPORT i_journalentrytp~reverse.
    IF update IS NOT INITIAL.
      lt_head = CORRESPONDING #(  update-zi_payment_head ).
      DATA(ls_head) = VALUE #(  lt_head[ 1 ] OPTIONAL ).

      IF lt_head[] IS NOT INITIAL.

        MODIFY zdt_payment_head FROM TABLE @lt_head.
*        LOOP AT lt_head INTO DATA(ls_head) WHERE status = 'Sent to Bank'.
*          ls_flog-companycode = ls_head-companycode.
*          ls_flog-fiscalyear  = ls_head-fiscalyear.
*          ls_flog-accountingdoc  = ls_head-accountingdoc.
*          ls_flog-filename  = ls_head-filename.
*          ls_flog-counter  = ls_head-counter.
*          ls_flog-credt = sy-datlo.
*          MODIFY zdt_file_log FROM @ls_flog.
*          Clear : ls_flog, ls_head.
*        ENDLOOP.
      ENDIF.
      IF ls_head-delete_ind <> 'X'.
        SELECT a~accountingdoc,a~fiscalyear,a~companycode,a~supplier,a~apprlevel,b~inprocess,b~rejected,b~approved
        FROM zdt_appr_log AS a
        INNER JOIN @lt_head AS b
        ON ( b~accountingdoc = a~accountingdoc AND b~fiscalyear = a~fiscalyear AND b~companycode = a~companycode )
        INTO TABLE @DATA(lt_apprlog).
        SORT lt_apprlog BY accountingdoc ASCENDING fiscalyear ASCENDING companycode ASCENDING apprlevel DESCENDING.
        DELETE ADJACENT DUPLICATES FROM lt_apprlog COMPARING accountingdoc fiscalyear companycode.
        IF lt_apprlog[] IS INITIAL. "No previous logs
          lt_log[] = VALUE #( FOR wa IN lt_head ( accountingdoc = wa-accountingdoc fiscalyear = wa-fiscalyear
                            companycode = wa-companycode apprlevel = 1
                            supplier = wa-supplier actionedby = sy-uname actionedon = sy-datum
                            actionedat = sy-uzeit action = COND #( WHEN wa-inprocess = 'X' THEN 'Approve'
                                                                   WHEN wa-approved = 'X' THEN 'Approve'
                                                                   WHEN wa-rejected = 'X' THEN 'Reject' ) ) ).
          IF lt_log[] IS NOT INITIAL.
            MODIFY zdt_appr_log FROM TABLE @lt_log.
          ENDIF.
        ELSE.
          lt_log[] = VALUE #( FOR wa1 IN lt_apprlog ( accountingdoc = wa1-accountingdoc fiscalyear = wa1-fiscalyear
                            companycode = wa1-companycode apprlevel = ( wa1-apprlevel + 1 )
                            supplier = wa1-supplier actionedby = sy-uname actionedon = sy-datum
                            actionedat = sy-uzeit action = COND #( WHEN wa1-inprocess = 'X' THEN 'Approve'
                                                                   WHEN wa1-approved = 'X' THEN 'Approve'
                                                                   WHEN wa1-rejected = 'X' THEN 'Reject' ) ) ).
*        DATA(l_level) = VALUE #( lt_apprlog[ 1 ]-apprlevel OPTIONAL ).
*        IF l_level <> '1'.
*          lt_log1[] = VALUE #( FOR wa2 IN lt_log ( accountingdoc = wa2-accountingdoc fiscalyear = wa2-fiscalyear
*                        companycode = wa2-companycode apprlevel = ( wa2-apprlevel + 1 )
*                        supplier = wa2-supplier actionedby = sy-uname actionedon = sy-datum
*                        actionedat = sy-uzeit action = 'Int Status'
*                        apprcomment = VALUE #( lt_head[  1 ]-appr2comment OPTIONAL ) ) ).
*          lt_log[] = CORRESPONDING #(  BASE (  lt_log[] ) lt_log1[] ).
*        ENDIF.
          IF lt_log[] IS NOT INITIAL.
            MODIFY zdt_appr_log FROM TABLE @lt_log.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
