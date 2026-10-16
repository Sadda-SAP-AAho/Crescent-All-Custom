CLASS lhc_ZI_bank_stat_head DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR ZI_bank_stat_head RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZI_bank_stat_head RESULT result.

    METHODS approve1 FOR MODIFY
      IMPORTING keys FOR ACTION ZI_bank_stat_head~approve1 RESULT result.

ENDCLASS.

CLASS lhc_ZI_bank_stat_head IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD approve1.

    DATA lv_utr TYPE string.
    DATA:ls_head TYPE zdt_payment_head.
    TYPES: BEGIN OF ty_type,
             login_id       TYPE string,
             input_gcif     TYPE string,
             cbx_api_ref_no TYPE string,
             txndate        TYPE string,
           END OF ty_type.
    DATA: ls_paystat TYPE ty_type.
    DATA: lv_json_post TYPE string VALUE ''.

    DATA(l_accdoc) = VALUE #(  keys[ 1 ]-Accountingdoc OPTIONAL ).
    DATA(l_fiscyear) = VALUE #(  keys[ 1 ]-Fiscalyear OPTIONAL ).
    DATA(l_comp) = VALUE #(  keys[ 1 ]-Companycode OPTIONAL ).

    SELECT SINGLE * FROM zdt_payment_head WHERE accountingdoc = @l_accdoc
    AND fiscalyear = @l_fiscyear AND companycode = @l_comp
    INTO @DATA(l_head).
    IF l_head-appr1 = 'X' AND l_head-appr2 = 'X' AND l_head-appr3 = 'X'.

      " get status from bank
      ls_paystat-input_gcif = 'CBXMGRT4'.
      ls_paystat-login_id = 'APIUSER@CBXMGRT4'.
      ls_paystat-cbx_api_ref_no = l_accdoc && l_fiscyear && l_comp.
      ls_paystat-txndate = l_head-senton+0(4) && '-' && l_head-senton+4(2) && '-' && l_head-senton+6(2).

      /ui2/cl_json=>serialize( EXPORTING data = ls_paystat RECEIVING r_json = lv_json_post ).
      TRY.
          DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario = 'ZFI_SC_PAYSTATUS'
                                                                                           service_id    = 'ZFI_PAYSTATUS_REST' ).
          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
          DATA(lo_request) = lo_http_client->get_http_request( ).
          lo_request->set_content_type( content_type = |application/json| ).
          lo_request->set_text( lv_json_post ).
          DATA(ls_result) = lo_http_client->execute( if_web_http_client=>post )->get_text( ).
          lo_http_client->close(  ).
          CLEAR lv_json_post.

        CATCH cx_http_dest_provider_error INTO DATA(http_dest_provider_error).
        CATCH cx_web_http_client_error INTO DATA(web_http_client_error).
      ENDTRY.
*
      TYPES: BEGIN OF ty_data_reject,
               input_user_no        TYPE string,
               lei_expiry_date      TYPE  string,
               od_txn_type          TYPE  string,
               od_bsn_prod          TYPE  string,
               initiatedate_time    TYPE  string,
               paymentrefno         TYPE  string,
               txn_status           TYPE  string,
               od_txn_ccy           TYPE  string,
               od_status_desc       TYPE  string,
               bene_narration       TYPE  string,
               lei_code             TYPE  string,
               od_acc_no            TYPE  string,
               od_maker_date        TYPE  string,
               od_gcif              TYPE  string,
               txn_ref_num          TYPE  string,
               status               TYPE  string,
               origin               TYPE  string,
               od_reject_reason     TYPE  string,
               od_channel_desc      TYPE  string,
               ifsc_code            TYPE  string,
               product              TYPE  string,
               od_bsn_code          TYPE  string,
               od_maker_id          TYPE  string,
               auth_allowed         TYPE  string,
               remark               TYPE  string,
               od_status            TYPE  string,
               parent_ref_no        TYPE  string,
               check_same_bene_flag TYPE  string,
               debit_acc_no         TYPE  string,
               sub_product          TYPE  string,
               od_lcy_amount        TYPE  string,
               bene_name            TYPE  string,
               od_amount            TYPE  string,
               od_value_date        TYPE  string,
               entitled             TYPE  string,
               transfer_type_desc   TYPE string,
               bene_acc_no          TYPE  string,
               action               TYPE  string,
               total_count          TYPE  string,
               od_maker_name        TYPE  string,
               transfer_type        TYPE  string,
               input_ver_no         TYPE  string,
               hold_remark_ind      TYPE  string,
               reference_no         TYPE  string,
               input_host_code      TYPE  string,
             END OF ty_data_reject.
      TYPES: BEGIN OF ty_data_success,
               host_file_ind       TYPE string,
               od_auth_date        TYPE string,
               input_user_no       TYPE string,
               initiatedate_time   TYPE string,
               paymentrefno        TYPE string,
               txn_status          TYPE string,
               credit_acc_no       TYPE string,
               business_prod_desc  TYPE string,
               txn_reference_no    TYPE string,
               lei_code            TYPE string,
               od_acc_no           TYPE string,
               origin              TYPE string,
               od_gcif             TYPE string,
               od_reject_reason    TYPE string,
               ifsc_code           TYPE string,
               nodal_approval      TYPE string,
               product             TYPE string,
               od_maker_id         TYPE string,
               handoff_code        TYPE string,
               org_pay_prod        TYPE string,
               currency            TYPE string,
               od_status           TYPE string,
               debit_acc_no        TYPE string,
               sub_product         TYPE string,
               od_auth_name        TYPE string,
               business_product_id TYPE string,
               od_amount           TYPE string,
               bene_name           TYPE string,
               maker_date          TYPE string,
               value_date          TYPE string,
               bene_nm_frm_host    TYPE string,
               batchrefno          TYPE string,
               transfer_type_desc  TYPE string,
               action              TYPE string,
               total_count         TYPE string,
               od_maker_name       TYPE string,
               transfer_type       TYPE string,
               input_ver_no        TYPE string,
               reference_no        TYPE string,
               utr_no              TYPE string,
             END OF ty_data_success.
      TYPES: BEGIN OF ty_errors,
               code       TYPE char10,
               field      TYPE char20,
               message    TYPE char255,
               resourceId TYPE char40,
             END OF ty_errors.

      DATA: ls_data TYPE ty_data_reject.
      DATA: ls_data_success TYPE ty_data_success.
      DATA: ls_errors TYPE ty_errors,
            l_errors  TYPE flag,
            l_donothing TYPE flag.
      IF ls_result CS 'valErrors'.

        SPLIT ls_result AT '[' INTO DATA(lv_e1) DATA(lv_e2).
        SPLIT lv_e2 AT ']' INTO DATA(lv_e3) DATA(lv_e4).

        /ui2/cl_json=>deserialize( EXPORTING json = lv_e3 CHANGING data = ls_errors ).
        l_errors = 'X'.
        "  ELSE. "Might be rejected,Processed,Payload = Parse into a structure and handle that
      ELSEIF ls_result CS '"TXN_STATUS":"TXCOMP"' OR
             ls_result CS '"TXN_STATUS":"3"' OR
             ls_result CS '"TXN_STATUS":"TXDSETT"' OR
             ls_result CS '"TXN_STATUS":"Processed"'.

        SPLIT ls_result AT '[' INTO DATA(lv_s1) DATA(lv_s2).
        SPLIT lv_s2 AT ']' INTO DATA(lv_s3) DATA(lv_s4).

        /ui2/cl_json=>deserialize( EXPORTING json = lv_S3 CHANGING data = ls_data_success ).

        IF ls_data_success-txn_status = 'TXCOMP' OR ls_data_success-txn_status = '3' OR ls_data_success-txn_status = 'TXDSETT'
           OR ls_data_success-txn_status = 'Processed'.
          lv_utr = ls_data_success-reference_no.
          DATA(lv_status1) =  ls_data_success-txn_status.
        ENDIF.

      ELSE.
        SPLIT ls_result AT '[' INTO DATA(lv1) DATA(lv2).
        SPLIT lv2 AT ']' INTO DATA(lv3) DATA(lv4).

        /ui2/cl_json=>deserialize( EXPORTING json = lv3 CHANGING data = ls_data ).

        IF ls_data-txn_status = '0' OR ls_data-txn_status = 'RV' OR ls_data-txn_status = 'RR' OR ls_data-txn_status = 'PR' OR
           ls_data-txn_status = 'DR' OR ls_data-txn_status = 'AO' OR ls_data-txn_status = 'RA' OR ls_data-txn_status = 'LK' OR
           ls_data-txn_status = 'TXPDAUTH' OR ls_data-txn_status = 'TXPARK' OR ls_data-txn_status = 'TXNVIP' OR
           ls_data-txn_status = 'TXDRHD' OR ls_data-txn_status = 'TXDBPR' OR ls_data-txn_status = 'TXBVSU' OR
           ls_data-txn_status = 'TXBVSP' OR ls_data-txn_status = 'TXAWRB' OR ls_data-txn_status = 'TXAUTH' OR
           ls_data-txn_status = 'TXAICN' OR ls_data-txn_status = 'TXAGWT' OR ls_data-txn_status = 'TRBLWT' OR
           ls_data-txn_status = 'TLCWT' OR ls_data-txn_status = 'PRTXINPR' OR ls_data-txn_status = 'NDF' OR
           ls_data-txn_status = 'UNKNOWN' OR  ls_data-txn_status = 'CI' OR  ls_data-txn_status = 'IO' OR ls_data-txn_status = 'LK' OR
           ls_data-txn_status = 'TXWRHD' OR ls_data-txn_status = '70008' OR ls_data-txn_status = '70009' OR
           ls_data-txn_status = 'ENTL_ERR' OR ls_data-txn_status = 'U' OR  ls_data-txn_status = 'TXSIP' OR
           ls_data-txn_status = 'TXSETT' OR  ls_data-txn_status = 'TXPDST' OR ls_data-txn_status = 'TXTRHOLD' OR ls_data-txn_status = 'N'.
          " lv_utr = ls_data-reference_no.
          DATA(lv_status) =  ls_data-od_status_desc.
          l_donothing = 'X'.
        ELSE.
          l_errors = 'X'.
        ENDIF.

      ENDIF.


      IF lv_utr IS INITIAL.
        IF lv_status IS NOT INITIAL and l_donothing = 'X'.
          MODIFY ENTITIES OF zi_bank_stat_head IN LOCAL MODE
              ENTITY zi_bank_stat_head
                 UPDATE FROM VALUE #( FOR key IN keys
                                      ( Accountingdoc         = key-Accountingdoc
                                        Fiscalyear            = key-Fiscalyear
                                        Companycode           = key-Companycode
                                     "   utr             = lv_utr
                                        appr1comment          = lv_status
                                      "  %control-utr    = if_abap_behv=>mk-on
                                        %control-Appr1comment = if_abap_behv=>mk-on
                                      ) )
                 FAILED failed
                 REPORTED reported.

          "Read changed data for action result
          READ ENTITIES OF zi_bank_stat_head IN LOCAL MODE
            ENTITY zi_bank_stat_head
            ALL FIELDS WITH
            CORRESPONDING #( keys )
            RESULT DATA(heads).


          result = VALUE #( FOR head IN heads
                            ( %tky   = head-%tky
                              %param = head ) ).
        ELSEIF l_errors = 'X'.
           MODIFY ENTITIES OF zi_bank_stat_head IN LOCAL MODE
              ENTITY zi_bank_stat_head
                 UPDATE FROM VALUE #( FOR key IN keys
                                      ( Accountingdoc         = key-Accountingdoc
                                        Fiscalyear            = key-Fiscalyear
                                        Companycode           = key-Companycode
                                        status                = 'Failed'
                                     "   utr             = lv_utr
                                        appr1comment          = lv_status
                                      "  %control-utr    = if_abap_behv=>mk-on
                                        %control-Appr1comment = if_abap_behv=>mk-on
                                        %control-Status       = if_abap_behv=>mk-on
                                      ) )
                 FAILED failed
                 REPORTED reported.

          "Read changed data for action result
          READ ENTITIES OF zi_bank_stat_head IN LOCAL MODE
            ENTITY zi_bank_stat_head
            ALL FIELDS WITH
            CORRESPONDING #( keys )
            RESULT heads.


          result = VALUE #( FOR head IN heads
                            ( %tky   = head-%tky
                              %param = head ) ).
        ENDIF.
      ELSE.
        "accepted UTR NO received
        DATA : lv_assingment TYPE char18.
        DATA(lv_len1) = strlen( lv_utr ).
        IF lv_len1 <= 18.
          lv_assingment = lv_utr.
        ELSE.
          lv_len1 = lv_len1 - 19 .
          lv_assingment = lv_utr+lv_len1(18).
        ENDIF.

        MODIFY ENTITIES OF zi_bank_stat_head IN LOCAL MODE
            ENTITY zi_bank_stat_head
               UPDATE FROM VALUE #( FOR key IN keys
                                    ( Accountingdoc         = key-Accountingdoc
                                      Fiscalyear            = key-Fiscalyear
                                      Companycode           = key-Companycode
                                      status                = 'UTR Generated' "For Successful UTR Generation
                                      utr                   = lv_utr
                                      appr1comment          = lv_status1
                                      %control-status       = if_abap_behv=>mk-on
                                      %control-utr          = if_abap_behv=>mk-on
                                      %control-Appr1comment = if_abap_behv=>mk-on
                                    ) )
               FAILED failed
               REPORTED reported.

        "Read changed data for action result
        READ ENTITIES OF zi_bank_stat_head IN LOCAL MODE
          ENTITY zi_bank_stat_head
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT heads.

        result = VALUE #( FOR head IN heads
                          ( %tky   = head-%tky
                            %param = head ) ).

        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " acc doc entry Assignement refernce  DocumentItemText update
        DATA: lt_je  TYPE TABLE FOR ACTION IMPORT i_journalentrytp~change,
              lv_cid TYPE abp_behv_cid.

        APPEND INITIAL LINE TO lt_je ASSIGNING FIELD-SYMBOL(<je>).
* GL Item Control
        DATA lt_glitem LIKE <je>-%param-_glitems.
        DATA ls_glitem LIKE LINE OF lt_glitem.
        DATA ls_glitem_control LIKE ls_glitem-%control.
        ls_glitem_control-glaccountlineitem = if_abap_behv=>mk-on.
        ls_glitem_control-documentitemtext = if_abap_behv=>mk-on.
        ls_glitem_control-assignmentreference = if_abap_behv=>mk-on.

        SELECT SINGLE LedgerGLLineItem
        FROM I_JournalEntryItem
        WHERE CompanyCode = @l_comp AND FiscalYear = @l_fiscyear AND AccountingDocument = @l_accdoc AND
        Ledger = '0L' AND Supplier IS INITIAL AND HouseBank IS NOT INITIAL
        INTO @DATA(ls_gl_item) .

*    "CHANGE BO
        <je>-companycode = l_comp.
        <je>-fiscalyear  = l_fiscyear.
        <je>-accountingdocument = l_accdoc.
        <je>-%param = VALUE #(
        _glitems = VALUE #( ( glaccountlineitem   = ls_gl_item
                              documentitemtext    = lv_assingment
                              assignmentreference = lv_utr
                              %control            = ls_glitem_control ) ) ).

        MODIFY ENTITIES OF i_journalentrytp
         ENTITY journalentry
         EXECUTE change FROM lt_je
         FAILED DATA(ls_failed_deep)
         REPORTED DATA(ls_reported_deep)
         MAPPED DATA(ls_mapped_deep).

      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_BANK_STAT_HEAD DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_BANK_STAT_HEAD IMPLEMENTATION.

  METHOD save_modified.
    DATA : lt_head  TYPE STANDARD TABLE OF zdt_payment_head,
           lt_head1 TYPE STANDARD TABLE OF zdt_payment_head,
           lt_log   TYPE STANDARD TABLE OF zdt_appr_log.

    "header table update
    IF update IS NOT INITIAL.
      lt_head = CORRESPONDING #(  update-zi_bank_stat_head ).

      "log table update
      SELECT a~accountingdoc,a~fiscalyear,a~companycode,a~supplier,a~apprlevel,b~inprocess,b~rejected,b~approved,
      b~appr1comment
      FROM zdt_appr_log AS a
      INNER JOIN @lt_head AS b
      ON ( b~accountingdoc = a~accountingdoc AND b~fiscalyear = a~fiscalyear AND b~companycode = a~companycode )
      INTO TABLE @DATA(lt_apprlog).
      SORT lt_apprlog BY accountingdoc ASCENDING fiscalyear ASCENDING companycode ASCENDING apprlevel DESCENDING.
      DELETE ADJACENT DUPLICATES FROM lt_apprlog COMPARING accountingdoc fiscalyear companycode.
      IF lt_apprlog[] IS NOT INITIAL.

        lt_log[] = VALUE #( FOR wa1 IN lt_apprlog ( accountingdoc = wa1-accountingdoc fiscalyear = wa1-fiscalyear
                          companycode = wa1-companycode apprlevel = ( wa1-apprlevel + 1 )
                          supplier = wa1-supplier actionedby = sy-uname actionedon = sy-datum
                          actionedat = sy-uzeit action = 'Status Upd'
                          apprcomment = wa1-appr1comment    ) ).

        IF lt_log[] IS NOT INITIAL.
          MODIFY zdt_appr_log FROM TABLE @lt_log.
        ENDIF.

      ENDIF.

      IF lt_head[] IS NOT INITIAL.
        LOOP AT lt_head ASSIGNING FIELD-SYMBOL(<fs_head>).
          CLEAR: <fs_head>-appr1comment.
        ENDLOOP.
        MODIFY zdt_payment_head FROM TABLE @lt_head.
      ENDIF.

    ENDIF.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
