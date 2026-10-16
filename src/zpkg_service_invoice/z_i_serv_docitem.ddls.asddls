@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Service Doc Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_SERV_DOCITEM
  as select from ZV_SERV_DocItem
{
  key CompanyCode,
  key AccountingDocument,
  key FiscalYear,
  key AccountingDocumentItem,
      Customer,
      TaxItemAcctgDocItemRef,
      DocumentItemText,
      IN_HSNOrSACCode,
      TransactionCurrency,
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      AmountInTransactionCurrency,
      AccountingDocumentItemType,
      FinancialAccountType
}
