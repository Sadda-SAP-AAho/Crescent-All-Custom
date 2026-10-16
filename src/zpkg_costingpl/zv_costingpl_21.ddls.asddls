@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_21


  with parameters
    p_begin : begda,
    p_end   : endda

  as select from ZV_COSTINGPL_20( p_begin:$parameters.p_begin , p_end: $parameters.p_end )
{
  key BillingDocument,
  key BillingDocumentItem,
      ProfitCenter,
      prctrclub,
      ItemNetWeight,
      BillingNetWeight,
      AmountInCompanyCodeCurrency,
      DerivedRatio,
      case when ItemNetWeight > 0 then
      cast( division( AmountInCompanyCodeCurrency, BillingNetWeight, 2 ) as abap.dec(31, 2) )
      else 0 end as VarianceperKg
}
