@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PO_QTY
  as select distinct from I_PurchaseOrderAPI01     as a
    inner join            I_PurchaseOrderItemAPI01 as b on a.PurchaseOrder = b.PurchaseOrder
    inner join            ZI_QTYTOBEDEL            as h on  b.PurchaseOrder     = h.PurchaseOrder
                                                        and b.PurchaseOrderItem = h.PurchaseOrderItem

{

  key b.Material,
  key b.Plant,
      b.PurchaseOrderQuantityUnit, //hide

      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
      sum( ( case when b.IsReturnsItem is not initial then  b.OrderQuantity * (-1)
             else b.OrderQuantity end ) )             as POQty,

      sum( ( case when b.IsReturnsItem is initial then h.QtytobeDel
             else cast( 0 as abap.dec(12,3) ) end ) ) as QtytobeDel

}

group by
  b.Material,
  b.Plant,
  b.PurchaseOrderQuantityUnit
