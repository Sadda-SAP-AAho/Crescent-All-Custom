@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base CDS for MaT Net Qty Calc SO'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_NET_QTY_CALC_SO
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date
  as select from ZR_NET_QTY_CALC_BASE(
                 p_date_low  : $parameters.p_date_low,
                 p_date_high : $parameters.p_date_high
                 )
{
  key ProductGroup,
  key Plant,
      GoodsMovementType,

      // @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum(GdsMvtQty) as GdsMvtQty
}
where
  (
       GoodsMovementType = '601'
    or GoodsMovementType = '602'
    or GoodsMovementType = '651'
    or GoodsMovementType = '652'
    or GoodsMovementType = '653'
  )
  //and  SalesOrder        is not initial
group by
  ProductGroup,
  Plant,
  GoodsMovementType
