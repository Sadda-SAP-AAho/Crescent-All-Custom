@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for Debtor Report'
@Search.searchable: true
define root view entity zc_debitor
  provider contract transactional_query
  as projection on ZI_DEBTOR
{
           @EndUserText.label: 'Accounting Document'
  key      AccountingDocument,
           @EndUserText.label: 'Invoice Number'
  key      InvoiceNumber,
           @EndUserText.label: 'Invoice Date'
  key      InvoiceDate,
           @EndUserText.label: 'Tax Invoice'
  key      TaxInvoice,
           @EndUserText.label: 'Company Code'
  key         CompanyCode,

           @EndUserText.label: 'Planing Week'
  key         Planingweek,
           @EndUserText.label: 'Planing Month'
  key         Planingmonth,
           @EndUserText.label: 'Customer Number'
  key         CustomerNumber,
           @EndUserText.label: 'Customer Name'
  key         CustomerName,
           @EndUserText.label: 'Document Currency'
  key         DocumentCurrency,
           @EndUserText.label: 'Sales Note Ref No.'
  key         Salesnoteref,
           @EndUserText.label: 'Total Amount'
  key         TotalAmount,
           @EndUserText.label: 'Invoice Value'
  key         InvoiceValue,
           @EndUserText.label: 'B/L No.'
           BLNo,
           @EndUserText.label: 'B/L Date'
           BLDate,
           @EndUserText.label: 'Shipping Bill No.'
           ShippingBillNo,
           @EndUserText.label: 'Shipping Bill Date'
           ShippingBillDate,
           @EndUserText.label: 'FOB Value'
           FOB_Value,
           @EndUserText.label: 'Expected Container Recd. Date'
           ExpContRecdDt,
           @EndUserText.label: 'Bank Ref. No.'
           BankRefNo,
           @EndUserText.label: 'Docs Submit to Bank'
           DocsSubtToBnkDt,
           @EndUserText.label: 'Payment Process'
           Paymentprocess,
           @EndUserText.label: 'Incoterms'
           IncotermsClassification,
           @EndUserText.label: 'Bill Closed'
           BillClosed,
           @EndUserText.label: 'Payment Term'
           PaymentTerm,
           @EndUserText.label: 'Document Sending Cust'
           DocSendCust,
           @EndUserText.label: 'Tentative ETA Date'
           TentETADt,
           @EndUserText.label: 'Actual ETA Date'
           ActETADt,
           @EndUserText.label: 'Customer Group'
           CustomerGrpName,
           @EndUserText.label: 'State Name'
           StateName,
           @EndUserText.label: 'GST No'
           GSTNo,
           @EndUserText.label: 'EBRC No'
           Ebrcno,
           @EndUserText.label: 'B/L Recd Dt'
           BLRecdDt
}
