@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Other Issue Qty'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_OTH_ISS_QTY
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
      //@Semantics.quantity.unitOfMeasure: 'UNIT'
      sum( GdsMvtQty ) as oth_iss_qty
}

where
  (
       GoodsMovementType = '201'
    or GoodsMovementType = '202'
    or GoodsMovementType = '541'
    or GoodsMovementType = '542'
  )

group by
  ProductGroup,
  Plant
