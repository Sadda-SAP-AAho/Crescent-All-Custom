@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_10
  as select from ZI_FI_DEBTOR_RPT as a
    inner join   ZI_NOSTRO_hed    as b on  b.Invoiceno  = a.AccountingDocument
                                       and b.fiscalyear = a.FiscalYear
    inner join   ZI_NOSTRO_ITM2    as c on  c.Id                     = b.Id
                                       and c.Accountingdocumentitem = a.AccountingDocumentItem
{
  a.AccountingDocument,
  a.AccountingDocumentItem,
  a.FiscalYear,
  max( c.Inwarddate ) as inwarddate,
  max( c.Swiftdate )  as Swiftdate
}
group by
  a.AccountingDocument,
  a.AccountingDocumentItem,
  a.FiscalYear
