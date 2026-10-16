@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Input Register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_INPUTREG6
  as select from I_JournalEntryItem
{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,

  key Ledger,
  key TransactionCurrency,
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      sum(AmountInTransactionCurrency) as AmountInTransactionCurrency
}
where
      FinancialAccountType = 'K'
  and SourceLedger         = '0L'
  and Ledger               = '0L'
group by
  SourceLedger,
  CompanyCode,
  FiscalYear,
  AccountingDocument,

  Ledger,
  TransactionCurrency
