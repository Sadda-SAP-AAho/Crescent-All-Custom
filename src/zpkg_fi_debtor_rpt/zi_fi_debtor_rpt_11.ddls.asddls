@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_11 
as select from ZI_FI_DEBTOR_RPT as a
    inner join   ZI_NOSTRO_hed    as b on  b.Invoiceno  = a.AccountingDocument
                                       and b.fiscalyear = a.FiscalYear
    inner join   ZI_NOSTRO_ITM2    as c on  c.Id                     = b.Id
                                       and c.Accountingdocumentitem = a.AccountingDocumentItem
{
  a.AccountingDocument,
  a.AccountingDocumentItem,
  a.FiscalYear,
  sum( cast( c.Inwardamount as abap.dec( 23, 2 ) ) ) as inwardamt
}
group by
  a.AccountingDocument,
  a.AccountingDocumentItem,
  a.FiscalYear
