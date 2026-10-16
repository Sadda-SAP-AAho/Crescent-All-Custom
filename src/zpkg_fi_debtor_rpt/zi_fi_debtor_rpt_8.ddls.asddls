@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_8
  as select from ZI_FI_DEBTOR_RPT          as a
    inner join   I_OperationalAcctgDocItem as b on  b.InvoiceReference           = a.AccountingDocument
                                                and b.InvoiceReferenceFiscalYear = a.FiscalYear
{
  a.AccountingDocument,
  a.FiscalYear,
  max( b.PostingDate ) as postingdate
}
group by
  a.AccountingDocument,
  a.FiscalYear
