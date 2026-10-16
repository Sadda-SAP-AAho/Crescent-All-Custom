@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Costing P&L'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_COSTINGPL_14

  with parameters
    p_begin : begda,
    p_end   : endda

  as select from ZV_COSTINGPL_13( p_begin: $parameters.p_begin, p_end: $parameters.p_end )
{

  key    FiscalYear,
  key    FiscalPeriod,
         cast( sum( CalcInterest ) as abap.dec( 15,5 ) ) as CalcInterest
}
group by
  FiscalYear,
  FiscalPeriod
