@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing PL PO SER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_COSTPLPOSER
  as select from I_OperationalAcctgDocItem as c

    inner join   ZV_COSTINGPL_36           as a on  c.PurchasingDocument            = a.PurchaseOrder
                                                and c.PurchasingDocumentItem        = a.PurchaseOrderItem
                                                and c.Reference3IDByBusinessPartner = a.Reference3

{

  key c.CompanyCode,
  key c.AccountingDocument,
  key c.FiscalYear,
  key c.AccountingDocumentItem,
  key a.ServiceEntrySheetName as AssignmentReference,
      '4'                     as zCase,
      c.AccountingDocumentItemType,
      c.GLAccount,
      a.PurchaseOrder         as PurchasingDocument,
      c.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      c.AmountInCompanyCodeCurrency

}
where
  c.AccountingDocumentType = 'RE'
