@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Daily Production Casting Report-Rej Qty(Baroda)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PP_CAST_REJ_BARODA
  as select distinct from ZI_PP_CAST_REJ_BARODA_1

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
      MaterialDocumentNo,
      MovementType,
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
      amount
}

where
  Rejcast > 0
