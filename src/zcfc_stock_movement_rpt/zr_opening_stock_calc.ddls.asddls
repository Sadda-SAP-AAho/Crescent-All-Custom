@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Entity for Opening Stock Calc against Mat.Grp'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_OPENING_STOCK_CALC
  with parameters
    p_date_low  : zde_date,
    p_date_high : zde_date
  as select from ZR_OPENING_STOCK_BASE(
                   p_date_low  : $parameters.p_date_low,
                   p_date_high : $parameters.p_date_high
                   )
{

  key ProductGroup,
  key Plant,
      sum(OpenStkQty) as openstock
}

group by
  ProductGroup,
  Plant
