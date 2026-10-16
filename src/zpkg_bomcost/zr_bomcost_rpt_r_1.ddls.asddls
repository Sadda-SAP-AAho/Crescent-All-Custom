@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for BOM Cost Report - Routing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_BOMCOST_RPT_R_1
  as select from    I_MfgBOOMaterialAssignment   as a
    left outer join ZR_BOMCOST_RPT_R_5           as g on  g.ProductionRoutingGroup  = a.BillOfOperationsGroup
                                                      and a.BillOfOperationsVariant = g.ProductionRouting
    inner join      I_MfgBOOOperationChangeState as b on  b.BillOfOperationsGroup   = a.BillOfOperationsGroup
                                                      and b.BillOfOperationsVariant = g.ProductionRouting
    inner join      I_WorkCenterCostCenter       as c on c.WorkCenterInternalID = b.WorkCenterInternalID
    inner join      I_CostCenterActivityTypeText as d on  d.CostCtrActivityType = c.CostCtrActivityType
                                                      and d.Language            = 'E'
    left outer join ZR_BOMCOST_RPT_R_2           as e on  e.CostCenter   = c.CostCenter
                                                      and e.ActivityType = c.CostCtrActivityType
    left outer join ZR_BOMCOST_RPT_R_4           as f on  f.ProductionRoutingGroup = a.BillOfOperationsGroup
                                                      and f.ProductionRouting      = g.ProductionRouting
                                                      and f.WorkCenterInternalID   = b.WorkCenterInternalID
{
  a.Product,
  a.Plant,
  a.BillOfOperationsGroup,
  a.BillOfOperationsVariant,
  g.ProductionRouting,
  c.CostCtrActivityType,
  d.CostCtrActivityTypeName,
  c.CostCenter,
  c.CostCenterActivityTypeFormula,
  e.costamt,
  e.factor,
  f.StandardWorkQuantityUnit1,
  case when f.StandardWorkQuantity1 > 0 then
      case c.CostCenterActivityTypeFormula
      when 'ZCON3' then cast( f.StandardWorkQuantity1 / ( 1 - cast( f.StandardWorkQuantity2 / 100 as abap.dec( 13, 3 ) ) )  as abap.dec( 13, 3 ) )
      when 'ZCON4' then cast( f.StandardWorkQuantity1 / ( 1 - cast( f.StandardWorkQuantity2 / 100 as abap.dec( 13, 3 ) ) ) as abap.dec( 13, 3 ) )
      when 'ZCON7' then ( case when f.StandardWorkQuantity2 is not initial
                          then cast( f.StandardWorkQuantity1 / f.StandardWorkQuantity2 as abap.dec( 13, 3 ) )
                          else 0 end )
      when 'ZCON8' then  ( case when f.StandardWorkQuantity2 is not initial
                           then cast( f.StandardWorkQuantity1 / f.StandardWorkQuantity2 as abap.dec( 13, 3 ) )
                           else 0 end )
      else cast( f.StandardWorkQuantity1 as abap.dec( 13, 3 ) ) end
      else cast( f.StandardWorkQuantity1 as abap.dec( 13, 3 ) ) end as WorkCenterStandardWorkQty
}
group by
  a.Product,
  a.Plant,
  a.BillOfOperationsGroup,
  a.BillOfOperationsVariant,
  g.ProductionRouting,
  c.CostCtrActivityType,
  d.CostCtrActivityTypeName,
  c.CostCenter,
  c.CostCenterActivityTypeFormula,
  e.costamt,
  e.factor,
  f.StandardWorkQuantityUnit1,
  f.StandardWorkQuantity1,
  f.StandardWorkQuantity2
