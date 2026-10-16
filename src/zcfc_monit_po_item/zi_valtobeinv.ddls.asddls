@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value to be Invoiced'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_VALTOBEINV
  as select distinct from I_PurchaseOrderAPI01     as a
    inner join            I_PurchaseOrderItemAPI01 as b on a.PurchaseOrder = b.PurchaseOrder
    left outer join       ZI_INVQT                 as g on  b.PurchaseOrder     = g.PurchaseOrder
                                                        and b.PurchaseOrderItem = g.PurchaseOrderItem
{
  key a.PurchaseOrder,
  key b.PurchaseOrderItem,
      (case when ( b.PurchaseOrder = g.PurchaseOrder and b.PurchaseOrderItem = g.PurchaseOrderItem ) then cast(b.NetAmount as abap.dec(12,3) ) - cast(g.InvVal as abap.dec(12,3) )
            else cast(b.NetAmount as abap.dec(12,3) ) end ) as AmttobeInv
}
