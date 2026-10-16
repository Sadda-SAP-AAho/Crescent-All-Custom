@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Received From Prodn Order Qty( Rej.Sloc)'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_RCVD_PROD_QTY_RESL
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date
  as select from ZR_NET_QTY_CALC_MO(
                 p_date_low  : $parameters.p_date_low,
                 p_date_high : $parameters.p_date_high
                 ) 

{
  key ProductGroup,
  key Plant,
      //@Semantics.quantity.unitOfMeasure: 'UNIT'
      sum( GdsMvtQty ) as rcvd_mo_qty_resl
}

where
     GoodsMovementType = '350'
  or GoodsMovementType = '349'
  or GoodsMovementType = '343'
  or GoodsMovementType = '344'


group by
  ProductGroup,
  Plant
