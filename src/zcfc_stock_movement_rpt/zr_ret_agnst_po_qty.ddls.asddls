@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Return Against PO Qty'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_RET_AGNST_PO_QTY
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date

  as select from ZR_NET_QTY_CALC_PO(
                 p_date_low  : $parameters.p_date_low,
                 p_date_high : $parameters.p_date_high
                 )

{
  key ProductGroup,
  key Plant,
      //@Semantics.quantity.unitOfMeasure: 'UNIT'
      sum( GdsMvtQty ) as ret_po_qty
}
where
  (
       GoodsMovementType = '161'
    or GoodsMovementType = '162'
    or GoodsMovementType = '122'
    or GoodsMovementType = '123'
  )


group by
  ProductGroup,
  Plant
