@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity for Foundary Return Qty Calc'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_FOUNDARY_RET_CALC
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date
  as select from ZR_FOUNDARY_RET_BASE(
                     p_date_low  : $parameters.p_date_low,
                     p_date_high : $parameters.p_date_high
                     )
{
  key ProductGroup,
  key Plant,
  sum( GdsMvtQty ) as foundary_ret_qty
}

group by
  ProductGroup,
  Plant
