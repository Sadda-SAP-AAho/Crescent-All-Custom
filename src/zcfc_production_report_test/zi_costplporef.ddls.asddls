@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing PL PO Ref'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_COSTPLPOREF
  as select from ZI_PONOOURREF as a

{

  key a.CompanyCode,
  key a.AccountingDocument,
  key a.FiscalYear,
  key a.AccountingDocumentItem,
  key a.AssignmentReference,
      a.zCase,
      a.AccountingDocumentItemType,
      a.GLAccount,
      a.PurchasingDocument,
      a.CompanyCodeCurrency,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      a.AmountInCompanyCodeCurrency

}

where
  a.Status = 'Y'
