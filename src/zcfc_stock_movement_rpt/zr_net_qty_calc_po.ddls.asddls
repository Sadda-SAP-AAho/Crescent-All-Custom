@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base CDS for MaT Net Qty Calc PO'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_NET_QTY_CALC_PO
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date
  as select from ZR_NET_QTY_CALC_BASE   (
                 p_date_low  : $parameters.p_date_low,
                 p_date_high : $parameters.p_date_high
                 )
{
  key ProductGroup,
  key Plant,
      GoodsMovementType,

      //@Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum(GdsMvtQty) as GdsMvtQty
}

where
  (
       GoodsMovementType = '101'
    or GoodsMovementType = '102'
    or GoodsMovementType = '161'
    or GoodsMovementType = '162'
    or GoodsMovementType = '122'
    or GoodsMovementType = '123'
  )
  and  PurchaseOrder     is not initial
group by
  ProductGroup,
  Plant,
  GoodsMovementType
