@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Del Qty Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_INVQT
  as select distinct from ZI_INVQT_BASIC
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      PurchaseOrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure:'PurchaseOrderQuantityUnit'
      sum(InvQty) as InvQty,
      DocumentCurrency,
      sum(InvVal) as InvVal

}

group by
  PurchaseOrder,
  PurchaseOrderItem,
  PurchaseOrderQuantityUnit,
  DocumentCurrency
