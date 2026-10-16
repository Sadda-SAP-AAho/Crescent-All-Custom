@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Daily Production Report of Casting'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_pp_casting_report
  as select distinct from ZTF_PP_CASTING_REPORT_sort
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
      MaterialDocument         as MaterialDocumentNo,
      GoodsMovementType        as MovementType,
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
      amount
}
