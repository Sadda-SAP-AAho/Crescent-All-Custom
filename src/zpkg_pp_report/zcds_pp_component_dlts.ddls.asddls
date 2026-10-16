@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Component Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity zcds_pp_component_dlts
  as select distinct from ZI_CONF_ORD                   as a
    left outer join       I_ManufacturingOrderOperation as b on b.ManufacturingOrder = a.Prodord
{
  key a.Prodord,
      a.Meins,
      b.ManufacturingOrder,
      b.ManufacturingOrderOperation,
      b.WorkCenterInternalID,

      b.CostCtrActivityType1 as CostCtrActivityType,
      @Semantics.quantity.unitOfMeasure: 'MEINS'
      //            b.WorkCenterStandardWorkQty1 as WorkCenterStandardWorkQty

      // Old Logic - Subhajit Dey(06.10.2026) //

      //      case when b.OpTotalConfirmedYieldQty > 0 then
      //      cast( cast( b.OpConfirmedWorkQuantity1 / b.OpTotalConfirmedYieldQty as abap.quan( 13, 3 ) )
      //      as abap.quan( 13, 3 ) ) end as WorkCenterStandardWorkQty

      // New Logic - Subhajit Dey(06.10.2026) //

      case when b.OpTotalConfirmedYieldQty > 0 then
              case when b.CostCtrActivityType1 = 'GLGN26'
                   then cast(b.WorkCenterStandardWorkQty1 as abap.quan(13,3))
              else cast( b.OpConfirmedWorkQuantity1 / b.OpTotalConfirmedYieldQty as abap.quan(13,3) )
              end
      end                    as WorkCenterStandardWorkQty
}

where
  b.CostCtrActivityType1 is not initial


union


select distinct from ZI_CONF_ORD                   as a
  left outer join    I_ManufacturingOrderOperation as b on b.ManufacturingOrder = a.Prodord
{
  key a.Prodord,
      a.Meins,
      b.ManufacturingOrder,
      b.ManufacturingOrderOperation,
      b.WorkCenterInternalID,

      b.CostCtrActivityType2 as CostCtrActivityType,
      //      b.WorkCenterStandardWorkQty2 as WorkCenterStandardWorkQty

      // Old Logic - Subhajit Dey(06.10.2026) //

      //      case when b.OpTotalConfirmedYieldQty > 0 then
      //      cast( cast( b.OpConfirmedWorkQuantity2 / b.OpTotalConfirmedYieldQty as abap.quan( 13, 3 ) )
      //      as abap.quan( 13, 3 ) ) end as WorkCenterStandardWorkQty

      // New Logic - Subhajit Dey(06.10.2026) //

      case when b.OpTotalConfirmedYieldQty > 0 then
              case when b.CostCtrActivityType2 = 'GLGN26'
                   then cast(b.WorkCenterStandardWorkQty1 as abap.quan(13,3))
              else cast( b.OpConfirmedWorkQuantity2 / b.OpTotalConfirmedYieldQty as abap.quan(13,3) )
              end
      end                    as WorkCenterStandardWorkQty
}

where
  b.CostCtrActivityType2 is not initial


union


select distinct from ZI_CONF_ORD                   as a
  left outer join    I_ManufacturingOrderOperation as b on b.ManufacturingOrder = a.Prodord
{
  key a.Prodord,
      a.Meins,
      b.ManufacturingOrder,
      b.ManufacturingOrderOperation,
      b.WorkCenterInternalID,

      b.CostCtrActivityType3 as CostCtrActivityType,
      //      b.WorkCenterStandardWorkQty3 as WorkCenterStandardWorkQty

      // Old Logic - Subhajit Dey(06.10.2026) //

      //      case when b.OpTotalConfirmedYieldQty > 0 then
      //      cast( cast( b.OpConfirmedWorkQuantity3 / b.OpTotalConfirmedYieldQty as abap.quan( 13, 3 ) )
      //      as abap.quan( 13, 3 ) ) end as WorkCenterStandardWorkQty

      // New Logic - Subhajit Dey(06.10.2026) //

      case when b.OpTotalConfirmedYieldQty > 0 then
              case when b.CostCtrActivityType3 = 'GLGN26'
                   then cast(b.WorkCenterStandardWorkQty1 as abap.quan(13,3))
              else cast( b.OpConfirmedWorkQuantity3 / b.OpTotalConfirmedYieldQty as abap.quan(13,3) )
              end
      end                    as WorkCenterStandardWorkQty
}

where
  b.CostCtrActivityType3 is not initial


union


select distinct from ZI_CONF_ORD                   as a
  left outer join    I_ManufacturingOrderOperation as b on b.ManufacturingOrder = a.Prodord
{
  key a.Prodord,
      a.Meins,
      b.ManufacturingOrder,
      b.ManufacturingOrderOperation,
      b.WorkCenterInternalID,

      b.CostCtrActivityType4 as CostCtrActivityType,
      //      b.WorkCenterStandardWorkQty4 as WorkCenterStandardWorkQty

      // Old Logic - Subhajit Dey(06.10.2026) //

      //      case when b.OpTotalConfirmedYieldQty > 0 then
      //      cast( cast( b.OpConfirmedWorkQuantity4 / b.OpTotalConfirmedYieldQty as abap.quan( 13, 3 ) )
      //      as abap.quan( 13, 3 ) ) end as WorkCenterStandardWorkQty

      // New Logic - Subhajit Dey(06.10.2026) //

      case when b.OpTotalConfirmedYieldQty > 0 then
              case when b.CostCtrActivityType4 = 'GLGN26'
                   then cast(b.WorkCenterStandardWorkQty1 as abap.quan(13,3))
              else cast( b.OpConfirmedWorkQuantity4 / b.OpTotalConfirmedYieldQty as abap.quan(13,3) )
              end
      end                    as WorkCenterStandardWorkQty
}

where
  b.CostCtrActivityType4 is not initial


union


select distinct from ZI_CONF_ORD                   as a
  left outer join    I_ManufacturingOrderOperation as b on b.ManufacturingOrder = a.Prodord
{
  key a.Prodord,
      a.Meins,
      b.ManufacturingOrder,
      b.ManufacturingOrderOperation,
      b.WorkCenterInternalID,

      b.CostCtrActivityType5 as CostCtrActivityType,
      //      b.WorkCenterStandardWorkQty5 as WorkCenterStandardWorkQty

      // Old Logic - Subhajit Dey(06.10.2026) //

      //      case when b.OpTotalConfirmedYieldQty > 0 then
      //      cast( cast( b.OpConfirmedWorkQuantity5 / b.OpTotalConfirmedYieldQty as abap.quan( 13, 3 ) )
      //      as abap.quan( 13, 3 ) ) end as WorkCenterStandardWorkQty

      // New Logic - Subhajit Dey(06.10.2026) //

      case when b.OpTotalConfirmedYieldQty > 0 then
              case when b.CostCtrActivityType5 = 'GLGN26'
                   then cast(b.WorkCenterStandardWorkQty1 as abap.quan(13,3))
              else cast( b.OpConfirmedWorkQuantity5 / b.OpTotalConfirmedYieldQty as abap.quan(13,3) )
              end
      end                    as WorkCenterStandardWorkQty
}

where
  b.CostCtrActivityType5 is not initial


union


select distinct from ZI_CONF_ORD                   as a
  left outer join    I_ManufacturingOrderOperation as b on b.ManufacturingOrder = a.Prodord
{
  key a.Prodord,
      a.Meins,
      b.ManufacturingOrder,
      b.ManufacturingOrderOperation,
      b.WorkCenterInternalID,

      b.CostCtrActivityType6 as CostCtrActivityType,
      //      b.WorkCenterStandardWorkQty6 as WorkCenterStandardWorkQty

      // Old Logic - Subhajit Dey(06.10.2026) //

      //      case when b.OpTotalConfirmedYieldQty > 0 then
      //      cast( cast( b.OpConfirmedWorkQuantity6 / b.OpTotalConfirmedYieldQty as abap.quan( 13, 3 ) )
      //      as abap.quan( 13, 3 ) ) end as WorkCenterStandardWorkQty

      // New Logic - Subhajit Dey(06.10.2026) //

      case when b.OpTotalConfirmedYieldQty > 0 then
              case when b.CostCtrActivityType6 = 'GLGN26'
                   then cast(b.WorkCenterStandardWorkQty1 as abap.quan(13,3))
              else cast( b.OpConfirmedWorkQuantity6 / b.OpTotalConfirmedYieldQty as abap.quan(13,3) )
              end
      end                    as WorkCenterStandardWorkQty
}

where
  b.CostCtrActivityType6 is not initial
