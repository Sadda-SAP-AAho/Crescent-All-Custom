@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing PL SES'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_COSTPLSES
  as select from ZV_COSTINGPL_32 as a

{
  key a.CompanyCode,
  key a.AccountingDocument,
  key a.FiscalYear,
  key a.AccountingDocumentItem,
  key a.AssignmentReference,
      '2'             as zCase,
      a.AccountingDocumentItemType,
      a.GLAccount,
      a.PurchaseOrder as PurchasingDocument,
      a.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency

}
