@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing PL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_36
  as select from ZV_COSTINGPL_35
{
  key BillingDocument,
  key ServiceEntrySheet,
  key ServiceEntrySheetItem,
  key SupplierInvoice,
  key FiscalYear,
      OriginalReference,
      ServiceEntrySheetName,
      PurchaseOrder,
      PurchaseOrderItem,
      MaterialDocument,
      MaterialDocumentYear,
      ServiceEntrySheetItem1,
      concat( FiscalYear, concat( ServiceEntrySheet, ServiceEntrySheetItem1 ) ) as Reference3
}
