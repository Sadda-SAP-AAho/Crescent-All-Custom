@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Activity View'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZCDS_ACTIVITY

  as select distinct from ZCDS_POSTINGDATE           as z

    inner join            zdt_confpost_hdr           as a  on a.shpflrno = z.shpflrno

    inner join            zdt_confpost_itm           as b  on b.id = a.id

    inner join            I_MfgBOOMaterialAssignment as c  on  c.Product = b.matnr
                                                           and c.Plant   = a.plant

    inner join            ZR_BOMCOST_RPT_R_5         as d  on  d.ProductionRoutingGroup = c.BillOfOperationsGroup
                                                           and d.ProductionRouting      = c.BillOfOperationsVariant

    inner join            ZI_mfgorder                as e  on  e.BillOfOperationsGroup   = c.BillOfOperationsGroup
                                                           and e.BillOfOperationsVariant = d.ProductionRouting
                                                           and e.Plant                   = c.Plant

    inner join            ZI_workcostcenter          as f  on  f.WorkCenterInternalID = e.WorkCenterInternalID
                                                           and f.WorkCenterTypeCode   = e.WorkCenterTypeCode
                                                           and f.Plant                = e.Plant

    inner join            ZV_ROUTING                 as z1 on  z1.ProductionRoutingGroup = c.BillOfOperationsGroup
                                                           and z1.WorkCenterInternalID   = e.WorkCenterInternalID
                                                           and z1.WorkCenterTypeCode     = e.WorkCenterTypeCode
                                                           and z1.ProductionRouting      = c.BillOfOperationsVariant

    inner join            ZCDS_TBLFUNC_VIEW          as g  on  g.ActivityType =       f.CostCtrActivityType
                                                           and g.CostCenter   =       f.CostCenter
                                                           and z.PostingDate  between g.ValidityStartDate and g.ValidityEndDate

{
  key z.PostingDate as shpflrdt,
  key a.opr,
  key a.plant,
  key a.dept,
  key a.cont,
  key b.matnr,

      g.ActivityType,
      f.CostCenterActivityTypeFormula,
      g.Currency,

      /** CASE logic for cost calculation **/
      @Semantics.amount.currencyCode: 'Currency'
      case
        when f.CostCenterActivityTypeFormula = 'ZCON1' or f.CostCenterActivityTypeFormula ='ZCON2' or f.CostCenterActivityTypeFormula = 'ZCON3' or f.CostCenterActivityTypeFormula = 'ZCON4' or f.CostCenterActivityTypeFormula = 'ZCON5'
          then(g.CostRateFixedAmount / 100 ) // cast((g.CostRateFixedAmount / 100) as abap.dec(23,3))
        when ( f.CostCenterActivityTypeFormula = g.ActivityType )
          then ( g.CostRateFixedAmount / 100) *  z1.StandardWorkQuantity1 //cast(((g.CostRateFixedAmount / 100) *  z1.StandardWorkQuantity1) as abap.dec(23,3))
        when f.CostCenterActivityTypeFormula = 'ZCON6'
          then ( g.CostRateFixedAmount / 100) *  z1.StandardWorkQuantity1 // cast(((g.CostRateFixedAmount / 100) *  z1.StandardWorkQuantity1) as abap.dec(23,3))
        when f.CostCenterActivityTypeFormula = 'ZCON7'
          then case
               when z1.StandardWorkQuantity2 <> 0
                 then ((g.CostRateFixedAmount / 100) * (z1.StandardWorkQuantity1 / z1.StandardWorkQuantity2))  // cast(((g.CostRateFixedAmount / 100) * (z1.StandardWorkQuantity1 / z1.StandardWorkQuantity2)) as abap.dec(23,3))
               else 0
             end
        else 0
      end           as CalculatedCost,

      g.ValidityStartDate,
      g.ValidityEndDate
}
