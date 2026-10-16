@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Felting STD SUM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZVFLETINGSTDS
  as select from ZRFELTING03
{
  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
//      sum(AmountInCompanyCodeCurrency) as feltsum
      sum( cast(AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as feltsum
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
