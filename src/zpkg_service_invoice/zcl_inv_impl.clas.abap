CLASS zcl_inv_impl DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.



CLASS ZCL_INV_IMPL IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA lv_sourcekey TYPE i_in_electronicdocinvoice-electronicdocsourcekey.
    DATA rt_table     TYPE TABLE OF zzvvheader.

    IF NOT io_request->is_data_requested( ).
      RETURN.
    ENDIF.

    FINAL(lo_filter) = io_request->get_filter( ).
    TRY.
        FINAL(lt_range) = lo_filter->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range.
    ENDTRY.

    IF NOT line_exists( lt_range[ name = 'INVOICENO' ] ).
      " Need select parameter!
      RETURN.
    ENDIF.

    LOOP AT lt_range[ name = 'INVOICENO' ]-range ASSIGNING FIELD-SYMBOL(<ls_range>).
      FINAL(lv_invoice) = <ls_range>-low.
      SELECT SINGLE * FROM zv_serv_journalentry " i_journalentry
        WHERE accountingdocument = @lv_invoice
        AND FiscalYear = '2026'
        INTO @FINAL(ls_invhead).

       SELECT SINGLE bankname,bankdetails FROM zi_service_inv_head " bank details
        WHERE InvoiceNo = @lv_invoice
        AND FiscalYear = '2026'
        INTO @FINAL(ls_bnk).

      SELECT SINGLE * FROM zv_serv_businessplace " i_in_businessplacetaxdetail
        WHERE businessplace = @ls_invhead-branch
        INTO @FINAL(ls_businessplace).

      SELECT SINGLE * FROM zdt_mm_pc_tmg
        WHERE cocode = @ls_invhead-companycode
        INTO @FINAL(ls_tmg).
      SELECT SINGLE * FROM zv_serv_docitem " i_operationalacctgdocitem
        WHERE accountingdocument = @ls_invhead-accountingdocument
          AND fiscalyear         = @ls_invhead-fiscalyear
        INTO @FINAL(ls_docitem).

      SELECT SINGLE * FROM zv_customer " i_customer
        WHERE customer = @ls_docitem-customer
        INTO @FINAL(ls_customer).

      lv_sourcekey = ls_invhead-companycode && ls_invhead-accountingdocument && ls_invhead-fiscalyear.

      SELECT SINGLE * FROM zv_qrcode "I_IN_ElectronicDocInvoice
        WHERE electronicdocsourcetype = 'FI_INVOICE'
          AND electronicdocsourcekey  = @lv_sourcekey
        INTO @FINAL(ls_einvoice).

      INSERT VALUE zzvvheader( invoiceno          = ls_invhead-accountingdocument
                               fiscalyear         = ls_invhead-fiscalyear
                               invoicereference   = ls_invhead-documentreferenceid
                               invoicedate        = ls_invhead-documentdate
                               invoicegstin       = ls_businessplace-in_gstidentificationnumber
                               companyname        = ls_tmg-name
                               address1           = ls_tmg-caddress1
                               address2           = ls_tmg-caddress2
                               currency           = ls_invhead-transactioncurrency
                               customer           = ls_customer-customer
                               customername       = ls_customer-customername
                               customerstreetname = ls_customer-streetname
                               customerpostalcode = ls_customer-postalcode
                               customercity       = ls_customer-cityname
                               customercountry    = ls_customer-country
                               customergstin      = ls_customer-taxnumber3
                               bankname           = ls_bnk-BankName
                               bankdetails        = ls_bnk-Bankdetails
                               irn                = ls_einvoice-in_electronicdocinvcrefnmbr
                               qrcode             = ls_einvoice-in_electronicdocqrcodetxt )
             INTO TABLE rt_table.

    ENDLOOP.

    io_response->set_data( rt_table ).
    io_response->set_total_number_of_records( lines( rt_table ) ).
  ENDMETHOD.
ENDCLASS.
