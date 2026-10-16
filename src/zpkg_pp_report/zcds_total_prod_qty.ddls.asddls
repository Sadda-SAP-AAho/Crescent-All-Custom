@AbapCatalog.sqlViewName: 'ZTTLPRODQTY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View of Total Production Qty'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_TOTAL_PROD_QTY
  as select distinct from I_MfgOrderWithStatus as a

{
  key a.Material,
      a.ProductionUnit,
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      sum( a.MfgOrderPlannedTotalQty )   as Total_Ord_Qty,
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      sum( a.MfgOrderConfirmedYieldQty ) as Total_Del_Qty
}
where
      a.OrderIsDeleted              is initial
  and a.OrderIsClosed               is initial
  and a.OrderIsTechnicallyCompleted is initial

group by
  a.Material,
  a.ProductionUnit
