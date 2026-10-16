@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Daily Production Casting Report-Rej Qty(Baroda)-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PP_CAST_REJ_BARODA_1
  as select distinct from ZI_PP_CAST_REJ_BARODA_2
{
  key Shpflrno,
  key ManufacturingOrder,
  key ManufacturingOrderOperation_2,
  key MaterialDocument,
  key MaterialDocumentItem,
      Shpflrdt,
      Dept,
      Deptname,
      Plant,
      Cont,
      Contname,
      MaterialDocument          as MaterialDocumentNo,
      GoodsMovementType         as MovementType,
      Meins,
      Matnr,
      Maktx,
      @Semantics.quantity.unitOfMeasure: 'MEINS'
      Rejcast,
      Wtunit,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      NetWeight,
      CostCtrActivityType,
      FiscalPeriod,
      WorkCenterStandardWorkQtyUnit1,
      @Semantics.quantity.unitOfMeasure: 'WorkCenterStandardWorkQtyUnit1'
      WorkCenterStandardWorkQty,
      CostCtrActivityTypeDesc,
      currency,
      CostRateFixedAmount,
      costcenter,
      amount1,
      @Semantics.amount.currencyCode: 'currency'
      cast( cast( amount1 as abap.dec( 13, 3 ) ) * cast( CostRateFixedAmount as abap.dec( 13, 3 ) )
         as abap.dec( 13, 3 ) ) as amount
}
