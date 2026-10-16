@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_INPUTREG12
  as select distinct from I_JournalEntryItem
{
  key AccountingDocument,
  key FiscalYear,
  key CompanyCode,

      case when GLAccount = '0000251013' or GLAccount = '0000251012'
      then 1
      else 0 end as GLAccount
}

where
  Ledger = '0L'
