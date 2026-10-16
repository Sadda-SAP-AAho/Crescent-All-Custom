@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Other Receipt Qty'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_OTH_RCVD_QTY
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
      sum( GdsMvtQty ) as oth_rcvd_qty

}

where
  (
       GoodsMovementType        =  '501'
    or GoodsMovementType        =  '502'
    or GoodsMovementType        =  '561'
    or GoodsMovementType        =  '562'
    or GoodsMovementType        =  '701'
    or GoodsMovementType        =  '702'
  )

group by
ProductGroup,
Plant
