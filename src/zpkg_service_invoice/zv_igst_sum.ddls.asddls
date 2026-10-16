@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum of Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_IGST_SUM
  as select from I_OperationalAcctgDocItem
{
  key AccountingDocument                        as InvoiceNo,
  key FiscalYear,
      TaxItemAcctgDocItemRef,
      TransactionCurrency                       as UOM,
      @Semantics: { amount : {currencyCode: 'UOM'} }
      sum( abs( AmountInTransactionCurrency ) ) as IGSTAmount
}
where
  //  FinancialAccountType = 'S'
  AccountingDocumentItemType = 'T'
group by
  AccountingDocument,
  FiscalYear,
  TransactionCurrency,
  TaxItemAcctgDocItemRef
