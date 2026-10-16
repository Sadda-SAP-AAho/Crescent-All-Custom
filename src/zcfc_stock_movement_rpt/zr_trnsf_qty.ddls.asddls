@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transfer In Qty'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_TRNSF_QTY
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
      sum( GdsMvtQty ) as transf_qty
}

where
  (
       GoodsMovementType = '301'
    or GoodsMovementType = '302'
   
  )
  
  and IsConsumptionMovement is initial

group by
  ProductGroup,
  Plant
