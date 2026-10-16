@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_9

  with parameters
    p_begin : begda,
    p_end   : endda

  as select from ZV_COSTINGPL_8( p_begin: $parameters.p_begin, p_end: $parameters.p_end )
{
  key FiscalPeriod,
  key FiscalYear,
      sum( cast( AmountInCompanyCodeCurrency as abap.dec(31,2) ) ) as Amount
}

group by
  FiscalPeriod,
  FiscalYear
