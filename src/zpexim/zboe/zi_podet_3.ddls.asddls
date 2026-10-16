@AbapCatalog.sqlViewName: 'ZIPODET3'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Details'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZI_PODet_3

  as select from ZI_PODet_2
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      Material,
      PurchaseOrderItemText,
      OrderQuantity,
      PurchaseOrderQuantityUnit,
      DocumentCurrency,
      NetAmount,
      Supplier,
      SupplierName,
      BaseUnit
}
