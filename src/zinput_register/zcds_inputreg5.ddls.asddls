@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_INPUTREG5
  as select distinct from I_JournalEntryItem
{
  key AccountingDocument,
  key FiscalYear,
  key CompanyCode,
      Plant
}
where
      Plant        is not initial
  and SourceLedger = '0L'
  and Ledger       = '0L'
