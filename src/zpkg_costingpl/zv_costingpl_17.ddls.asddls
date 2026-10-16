@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_17

  with parameters
    p_begin : begda,
    p_end   : endda

  as select from ZV_COSTINGPL_16( p_begin: $parameters.p_begin, p_end: $parameters.p_end )

{
  key prctrclub,
      ItemWeightUnit,
      sum( cast( ItemNetWeight as abap.dec(23,3) )  ) as BillingNetWeight
}
group by
  prctrclub,
  ItemWeightUnit
