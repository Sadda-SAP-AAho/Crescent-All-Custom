@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Balance Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@AbapCatalog.sqlViewName: 'ZI_GHJ'
define view ZR_BALANCEQTY_1
  as select from    I_PurchaseOrderItemAPI01 as c
    left outer join ZI_GITEM                 as a on(
      c.PurchaseOrder         = a.Ebeln
      and c.PurchaseOrderItem = a.Ebelp
    )
    left outer join zi_ghead                 as b on(
      a.Id = b.Id
    )

{
  key c.PurchaseOrder     as Ebeln,
  key c.PurchaseOrderItem as Ebelp,
      sum( a.Challanqty ) as challanqty,
      c.OrderQuantity
}
where
      b.Deleted is initial
  and b.Cancel  is initial
group by
  c.PurchaseOrder,
  c.PurchaseOrderItem,
  c.OrderQuantity
