@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Component Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity zcds_pp_component_dlts1
  as select distinct from ZI_CONF_ORD                   as a
    left outer join       I_ManufacturingOrderOperation as b on b.ManufacturingOrder = a.Prodord
    inner join            ZI_CONF_HDR                   as c on  c.Id       = a.Id
                                                             and c.Shpflrno = a.Shpflrno
    left outer join       I_WorkCenterCostCenter        as d on d.WorkCenterInternalID = b.WorkCenterInternalID
  //                                                             and d.CostCenter           = c.Dept
    left outer join       ZTF_PP_CASTING_REPORT_QTY     as e on  e.ProductionRoutingGroup = b.BillOfOperationsGroup
                                                             and e.WorkCenterInternalID   = b.WorkCenterInternalID
{
  key a.Prodord,
      a.Meins,
      b.ManufacturingOrder,
      b.ManufacturingOrderOperation,
      b.WorkCenterInternalID,
      //      b.WorkCenterStandardWorkQtyUnit1,
      e.StandardWorkQuantityUnit1                                   as WorkCenterStandardWorkQtyUnit1,
      d.CostCenter,
      d.CostCenterActivityTypeFormula,

      //     @Semantics.quantity.unitOfMeasure: 'MEINS'
      //*Begin of Change - Surajit Ghosh - 05/06/2025
      //      case when b.WorkCenterStandardWorkQty2 > 0 then
      //      case d.CostCenterActivityTypeFormula
      //      when 'ZCON3' then cast( b.WorkCenterStandardWorkQty1 / ( 1 - cast( b.WorkCenterStandardWorkQty2 / 100 as abap.dec( 13, 3 ) ) )  as abap.dec( 13, 3 ) )
      //      when 'ZCON4' then cast( b.WorkCenterStandardWorkQty1 / ( 1 - cast( b.WorkCenterStandardWorkQty2 / 100 as abap.dec( 13, 3 ) ) ) as abap.dec( 13, 3 ) )
      //      when 'ZCON7' then cast( b.WorkCenterStandardWorkQty1 / b.WorkCenterStandardWorkQty2 as abap.dec( 13, 3 ) )
      //      when 'ZCON8' then cast( b.WorkCenterStandardWorkQty1 / b.WorkCenterStandardWorkQty2 as abap.dec( 13, 3 ) )
      //      else cast( b.WorkCenterStandardWorkQty1 as abap.dec( 13, 3 ) ) end
      //      else cast( b.WorkCenterStandardWorkQty1 as abap.dec( 13, 3 ) ) end as WorkCenterStandardWorkQty
      case when e.StandardWorkQuantity2 > 0 then
      case d.CostCenterActivityTypeFormula
      when 'ZCON3' then cast( e.StandardWorkQuantity1 / ( 1 - cast( e.StandardWorkQuantity2 / 100 as abap.dec( 13, 3 ) ) )  as abap.dec( 13, 3 ) )
      when 'ZCON4' then cast( e.StandardWorkQuantity1 / ( 1 - cast( e.StandardWorkQuantity2 / 100 as abap.dec( 13, 3 ) ) ) as abap.dec( 13, 3 ) )
      when 'ZCON7' then cast( e.StandardWorkQuantity1 / e.StandardWorkQuantity2 as abap.dec( 13, 3 ) )
      when 'ZCON8' then cast( e.StandardWorkQuantity1 / e.StandardWorkQuantity2 as abap.dec( 13, 3 ) )
      else cast( e.StandardWorkQuantity1 as abap.dec( 13, 3 ) ) end
      else cast( e.StandardWorkQuantity1 as abap.dec( 13, 3 ) ) end as WorkCenterStandardWorkQty

      //*End   of Change - Surajit Ghosh - 05/06/2025
}
where
  d.CostCenterActivityTypeFormula is not initial
