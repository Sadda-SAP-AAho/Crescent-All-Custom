@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Balance Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@AbapCatalog.sqlViewName: 'ZIGJ'
define view ZR_BALANCEQTY_2
  as select from I_PurchaseOrderItemAPI01 as a
    left outer join   ZR_BALANCEQTY_1          as b on(
      b.Ebeln     = a.PurchaseOrder
      and b.Ebelp = a.PurchaseOrderItem
    )
{
  key a.PurchaseOrder     as Ebeln,
  key a.PurchaseOrderItem as Ebelp,
      a.OrderQuantity,
      b.challanqty


}
