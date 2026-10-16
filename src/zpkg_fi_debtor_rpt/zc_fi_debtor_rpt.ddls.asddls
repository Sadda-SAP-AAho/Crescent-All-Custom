@AbapCatalog.viewEnhancementCategory: [#NONE]
@EndUserText.label: 'Debtors Report'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_FI_DEBTOR_RPT
  as select from ZI_FI_DEBTOR_RPT_21
{
      @UI.hidden: true
  key CompanyCode,
      @EndUserText.label: 'Accounting Document'
  key AccountingDocument,
      @UI.hidden: true
  key FiscalYear,
      @UI.hidden: true
  key AccountingDocumentItem,
      @EndUserText.label: 'AR Invoice No.'
  key arinv,
      @EndUserText.label: 'AR Invoice Date'
  key DocumentDate,
      @EndUserText.label: 'Tax Invoice'
  key taxinv,
      @EndUserText.label: 'Tax Invoice Ref.'
      taxinvref,
      @EndUserText.label: 'Assignment Reference'
      AssignmentReference,
      @EndUserText.label: 'Document Reference'
      DocumentReferenceID,
      @EndUserText.label: 'Document Type'
      AccountingDocumentType                                          as doctyp,
      @EndUserText.label: 'Document Type Name'
      AccountingDocumentTypeName,
      @EndUserText.label: 'Plan Week'
      Planingweek,
      @EndUserText.label: 'Plan Month'
      Planingmonth,
      @EndUserText.label: 'Customer Code'
      Customer,
      @EndUserText.label: 'Customer Name'
      CustomerName,
      @EndUserText.label: 'Currency'
      TransactionCurrency,
      @EndUserText.label: 'BP Ref. No'
      Salesnoteref,
      @EndUserText.label: 'FC Total'
      AbsoluteAmountInTransacCrcy,
      @EndUserText.label: 'Exchange Rate'
      AbsoluteExchangeRate                                            as exchangerate,
      @EndUserText.label: 'Invoice value(INR)'
      AmountInCompanyCodeCurrency,
      @EndUserText.label: 'Paid Amount(INR)'
      abs(paidamt)                                                    as paidamt,
      @EndUserText.label: 'Balance Amount(INR)'
      cast( case when AccountingDocumentType = 'UE' then
      case when AbsoluteAmountInTransacCrcy < 0 then FCbalamt * AbsoluteExchangeRate * -1 else FCbalamt * AbsoluteExchangeRate end
      else AbsoluteExchangeRate *  FCbalamt end as abap.dec( 31,2 ) ) as balamt,
      @UI.hidden: true
      @EndUserText.label: 'Invoice value FC'
      FCInvoice,
      @EndUserText.label: 'Paid Amount FC'
      abs(FCPaid)                                                     as FCPaid,
      @EndUserText.label: 'Balance Amount FC'
      case when AccountingDocumentType = 'UE' then
      case when AbsoluteAmountInTransacCrcy < 0 then FCbalamt * -1 else FCbalamt end
      else FCbalamt end                                               as FCbalamt,
      @EndUserText.label: 'B/L No.'
      Ladingno,
      @EndUserText.label: 'B/L Date'
      Ladingdt,
      @EndUserText.label: 'Shipping Bill No.'
      shippingbill,
      @EndUserText.label: 'Shipping Bill Dt.'
      shippingbilldate,
      @EndUserText.label: 'FOB Value'
      fobvalue,
      @EndUserText.label: 'Expected Container Recd. Dt.'
      Empretdt,
      @EndUserText.label: 'Bank'
      BankName                                                        as bank,
      @EndUserText.label: 'Bank Ref No.'
      Bankrefno,
      @EndUserText.label: 'Docs Submit to Bank'
      Docpresentbnkdt,
      @EndUserText.label: 'Swift/TT Date'
      Swiftdate,
      @EndUserText.label: 'Intimation Date'
      inwarddate,
      @EndUserText.label: 'Payment Process'
      Paymentprocess,
      @EndUserText.label: 'Due Date'
      NetDueDate,
      @EndUserText.label: 'Inco Terms'
      IncotermsClassification,
      @EndUserText.label: 'Last Recon Date'
      recondt,
      @EndUserText.label: 'Bill Closed'
      Billcloseflag,
      @EndUserText.label: 'Payment Term'
      CustomerPaymentTermsName,
      @EndUserText.label: 'Planning'
      planning,
      @EndUserText.label: 'Inward Receipt Status'
      Inwardrecordstatus,
      @EndUserText.label: 'Inward Value Recd-FC'
      inwardamt,
      @EndUserText.label: 'Inward Recd Dt'
      inrecdt,
      @EndUserText.label: 'Document Sending Cust Dt'
      Docsentcustdt,
      @EndUserText.label: 'Tentative ETA Date'
      Etadt,
      @EndUserText.label: 'Actual ETA Date'
      Etddt,
      @EndUserText.label: 'Empty Cont. Pick Up Date'
      Conliftdt,
      @EndUserText.label: 'Empty Cont. return date'
      conretdt,
      @EndUserText.label: 'Destination Country'
      Cod,
      @EndUserText.label: 'HSN Code'
      hsncode,
      @EndUserText.label: 'Sales Person'
      salesperson                                                     as salesper,
      @EndUserText.label: 'Type'
      AccountGroupName,
      @EndUserText.label: 'Location/Plant'
      BusinessPlace,
      @EndUserText.label: 'State Name'
      RegionName,
      @EndUserText.label: 'GST No'
      TaxNumber3,
      @EndUserText.label: 'EBRC No'
      Ebrcno,
      @EndUserText.label: 'B/L Recd Dt'
      Drftblrcvdt,
      @EndUserText.label: 'IRM No'
      Irmno
}
