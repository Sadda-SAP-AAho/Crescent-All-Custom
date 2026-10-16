@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Return Qty'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_SLS_RET_QTY
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date
  as select from ZR_NET_QTY_CALC_SO(
                 p_date_low  : $parameters.p_date_low,
                 p_date_high : $parameters.p_date_high
                 ) 
{
  key ProductGroup,
  key Plant,
      //@Semantics.quantity.unitOfMeasure: 'UNIT'
      sum( GdsMvtQty ) as sls_ret_qty
}

where
  (
    GoodsMovementType = '652'
    or GoodsMovementType = '651'
    or GoodsMovementType = '653'
  )
group by
  ProductGroup,
  Plant
