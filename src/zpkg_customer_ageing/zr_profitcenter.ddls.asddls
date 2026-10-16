@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Profit center'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PROFITCENTER
  as select distinct from I_JournalEntryItem
{

  key AccountingDocument,
  key FiscalYear,
  key CompanyCode,
      max(ProfitCenter) as profitcenter
}
where
  ProfitCenter is not initial
group by
  AccountingDocument,
  FiscalYear,
  CompanyCode
