@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base CDS for MaT Net Qty Calc MO'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_NET_QTY_CALC_MO
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

      //@Semantics.quantity.unitOfMeasure: 'BaseUnit'
      sum(GdsMvtQty) as GdsMvtQty

}

where
  (
       GoodsMovementType  = '101'
    or GoodsMovementType  = '102'
    or GoodsMovementType  = '349'
    or GoodsMovementType  = '350'
    or GoodsMovementType  = '343'
    or GoodsMovementType  = '344'
    or GoodsMovementType  = '261'
    or GoodsMovementType  = '262'
  )
  and  ManufacturingOrder is not initial
  
group by
  ProductGroup,
  Plant,
  GoodsMovementType
