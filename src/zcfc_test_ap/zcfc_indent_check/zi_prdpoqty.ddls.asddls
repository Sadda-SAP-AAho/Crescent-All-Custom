@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Purchase Quantity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PRDPOQTY
  as select from I_PurchaseOrderItemAPI01 as a
{
  key a.Material,
  key a.Plant,
      sum(cast(a.OrderQuantity as abap.dec(12,3))) as po_qty

}
group by
  Material,
  Plant
