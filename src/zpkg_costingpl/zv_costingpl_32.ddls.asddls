@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing PL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_32

  as select from ZV_COSTINGPL_29           as a

    inner join   I_OperationalAcctgDocItem as d on  d.PurchasingDocument        = a.PurchaseOrder
                                                and d.OriginalReferenceDocument = a.OriginalReference

    inner join   zdt_cost_glpl             as e on e.gl = d.GLAccount

{

  key    d.CompanyCode,
  key    d.AccountingDocument,
  key    d.FiscalYear,
  key    d.AccountingDocumentItem,
  key    a.ServiceEntrySheetName as AssignmentReference,
  key    a.PurchaseOrder,
  key    a.ServiceEntrySheetName,
  key    a.ServiceEntrySheet,
         d.AccountingDocumentItemType,
         d.GLAccount,
         d.CompanyCodeCurrency,
         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         d.AmountInCompanyCodeCurrency

}

