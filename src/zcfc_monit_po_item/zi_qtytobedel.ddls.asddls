@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quantity to be Delivered'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_QTYTOBEDEL
  as select distinct from I_PurchaseOrderAPI01     as a
    inner join            I_PurchaseOrderItemAPI01 as b on a.PurchaseOrder = b.PurchaseOrder
    inner join       ZI_DELQT                 as f on  b.PurchaseOrder     = f.PurchaseOrder
                                                        and b.PurchaseOrderItem = f.PurchaseOrderItem
{
  key a.PurchaseOrder,
  key b.PurchaseOrderItem,
      cast( ( case when b.IsCompletelyDelivered is initial
                   then ( coalesce(b.OrderQuantity,0) - coalesce(f.delqty,0) )
                   else cast( '0' as abap.dec(12,3) ) end ) as abap.dec(12,3) ) as QtytobeDel
}
