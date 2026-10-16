@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Daily Production Report of Casting'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_pp_casting_sorted
  as select from zcds_amount_calculation
{
  key Shpflrno,
  key ManufacturingOrder,
  key ManufacturingOrderOperation_2,
  key MaterialDocument,
  key MaterialDocumentYear,
  key MaterialDocumentItem,
      Shpflrdt,
      Dept,
      Deptname,
      Plant,
      Cont,
      Contname,
      GoodsMovementType,
      Meins,
      Matnr,
      Maktx,
  //    MaterialDocument,
      @Semantics.quantity.unitOfMeasure: 'MEINS'
      Goodcast,
      Wtunit,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      NetWeight,
      CostCtrActivityType,
      FiscalPeriod,
      WorkCenterStandardWorkQtyUnit1,
      @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit1'
      WorkCenterStandardWorkQty,
      CostCtrActivityTypeDesc,
      cast( ' ' as abap.cuky ) as currency,
      CostRateFixedAmount,
      costcenter,
      amount1,
      @Semantics.amount.currencyCode: 'currency'
      cast( cast( amount1 as abap.dec( 23, 3 ) ) * cast( CostRateFixedAmount as abap.dec( 13, 3 ) )
      as abap.dec( 23, 3 ) )   as amount
}
