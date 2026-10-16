@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CITI Bank Payment Item 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_PAYMENT_ITEM_CITI_1
  as select from ZV_PAYMENT_ITEM_CITI
{
  key AccountingDocument,
  key FiscalYear,
  key CompanyCode,
  key SupplierInvoice,
      AccountingDocumentType,
      SpecialGLCode,
      DocumentDate,
      PostingDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case when AmountInCompanyCodeCurrency < 0
           then AmountInCompanyCodeCurrency * -1
           else AmountInCompanyCodeCurrency end as AmountInCompanyCodeCurrency,
      CompanyCodeCurrency,
      NetDueDate,
      PaymentTerms,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case when WithholdingTaxAmount < 0
           then WithholdingTaxAmount * -1
           else WithholdingTaxAmount end        as WithholdingTaxAmount,
      PurchasingDocument
}
where
  AccountingDocument <> SupplierInvoice
