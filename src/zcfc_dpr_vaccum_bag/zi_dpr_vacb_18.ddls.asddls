@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR VACUUM BAG - Activity Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_VACB_18
  as select from    zdt_confpost_hdr           as a
    inner join      zdt_confpost_itm           as b  on a.shpflrno = b.shpflrno
    inner join      I_MfgBOOMaterialAssignment as c  on  c.Product = b.matnr
                                                     and c.Plant   = a.plant
    left outer join ZR_BOMCOST_RPT_R_5         as d  on d.ProductionRoutingGroup = c.BillOfOperationsGroup
    inner join      ZI_mfgorder                as e  on  e.BillOfOperationsGroup   = c.BillOfOperationsGroup
                                                     and e.BillOfOperationsVariant = d.ProductionRouting
                                                     and e.Plant                   = c.Plant
    inner join      ZI_workcostcenter          as f  on  f.WorkCenterInternalID = e.WorkCenterInternalID
                                                     and f.WorkCenterTypeCode   = e.WorkCenterTypeCode
                                                     and f.Plant                = e.Plant
    inner join      ZV_ROUTING                 as z1 on  z1.ProductionRoutingGroup = c.BillOfOperationsGroup
                                                     and z1.WorkCenterInternalID   = e.WorkCenterInternalID
                                                     and z1.WorkCenterTypeCode     = e.WorkCenterTypeCode
    left outer join ZCDS_TBLFUNC_VIEW          as g  on  g.ActivityType = f.CostCtrActivityType
                                                     and g.CostCenter   = f.CostCenter

{
  key a.plant,
  key b.matnr,
      g.ActivityType,
      f.CostCenterActivityTypeFormula,
      g.Currency,
      /** CASE logic for cost calculation **/
      @Semantics.amount.currencyCode: 'Currency'
      case
        when f.CostCenterActivityTypeFormula = 'ZCON1' or f.CostCenterActivityTypeFormula ='ZCON2' or f.CostCenterActivityTypeFormula = 'ZCON3' or f.CostCenterActivityTypeFormula = 'ZCON4' or f.CostCenterActivityTypeFormula = 'ZCON5'
          then(g.CostRateFixedAmount / 100 )
        when ( f.CostCenterActivityTypeFormula = g.ActivityType )
          then ( g.CostRateFixedAmount / 100) *  z1.StandardWorkQuantity1
        when f.CostCenterActivityTypeFormula = 'ZCON6'
          then ( g.CostRateFixedAmount / 100) *  z1.StandardWorkQuantity1
        when f.CostCenterActivityTypeFormula = 'ZCON7'
          then case
               when z1.StandardWorkQuantity2 <> 0
                 then ((g.CostRateFixedAmount / 100) * (z1.StandardWorkQuantity1 / z1.StandardWorkQuantity2))
               else 0
             end
        else 0
      end as CalculatedCost

}
where
  g.ActivityType is not initial
group by
  a.plant,
  b.matnr,
  g.ActivityType,
  f.CostCenterActivityTypeFormula,
  g.CostRateFixedAmount,
  g.Currency,
  z1.StandardWorkQuantity1,
  z1.StandardWorkQuantity2
