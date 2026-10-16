@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zcds_pp_component_dlts_main'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_pp_component_dlts_main
  as select distinct from ZI_CONF_ORD                   as a
    inner join            I_ManufacturingOrderOperation as b on b.ManufacturingOrder = a.Prodord
    left outer join       zcds_pp_component_dlts        as c on  c.Prodord                     = b.ManufacturingOrder
                                                             and c.ManufacturingOrderOperation = b.ManufacturingOrderOperation_2
    left outer join       zcds_pp_component_dlts1       as d on  d.Prodord              = b.ManufacturingOrder
                                                             and d.WorkCenterInternalID = c.WorkCenterInternalID
{
  key a.Shpflrno,
  key b.ManufacturingOrder,
  key b.ManufacturingOrderOperation_2,
      c.CostCtrActivityType,
      d.WorkCenterStandardWorkQtyUnit1,
      @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit1'

      // Old Logic - Subhajit Dey(06.10.2026) //

      //      ( case when ( cast( c.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) ) = cast( 0 as abap.quan( 13, 3 ) )
      //                   or cast( c.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) ) is null )
      //             then cast( d.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) )
      //
      //             else cast( d.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) ) end ) as WorkCenterStandardWorkQty

      // New Logic - Subhajit Dey(06.10.2026) //

      ( case when ( cast( c.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) ) = cast( 0 as abap.quan( 13, 3 ) )
                 or cast( c.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) ) is null )
           then cast( d.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) )

           else cast( c.WorkCenterStandardWorkQty as abap.quan( 13, 3 ) ) end ) as WorkCenterStandardWorkQty
}
