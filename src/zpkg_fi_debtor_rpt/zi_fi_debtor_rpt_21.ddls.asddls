@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtor Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_21
  as select from ZI_FI_DEBTOR_RPT_20
{
  key CompanyCode,
  key AccountingDocument,
  key FiscalYear,
  key AccountingDocumentItem,
  key arinv,
  key DocumentDate,
  key taxinv,
      taxinvref,
      DocumentReferenceID,
      BillingDocumentType,
      AssignmentReference,
      AccountingDocumentType,
      AccountingDocumentTypeName,
      Planingweek,
      Planingmonth,
      Customer,
      CustomerName,
      TransactionCurrency,
      Salesnoteref,
      AbsoluteAmountInTransacCrcy,
      AbsoluteExchangeRate,
      AmountInCompanyCodeCurrency,
      paidamt,
      FCInvoice,
      FCPaid,
      case when AccountingDocumentType = 'UE'
      then cast( ( coalesce( abs( FCInvoice ), 0 ) - coalesce( abs( FCPaid ), 0 ) ) as abap.dec(23,2) )
      else cast( ( coalesce( FCInvoice , 0 ) - coalesce( FCPaid , 0 ) ) as abap.dec(23,2) )
      end as FCbalamt,
      Ladingno,
      Ladingdt,
      shippingbill,
      shippingbilldate,
      fobvalue,
      Empretdt,
      BankName,
      Bankrefno,
      Docpresentbnkdt,
      Swiftdate,
      inwarddate,
      Paymentprocess,
      NetDueDate,
      IncotermsClassification,
      recondt,
      Billcloseflag,
      CustomerPaymentTermsName,
      planning,
      Inwardrecordstatus,
      inwardamt,
      inrecdt,
      Docsentcustdt,
      Etadt,
      Etddt,
      Conliftdt,
      conretdt,
      Cod,
      hsncode,
      salesperson,
      AccountGroupName,
      BusinessPlace,
      RegionName,
      TaxNumber3,
      Ebrcno,
      Drftblrcvdt,
      Irmno
}
