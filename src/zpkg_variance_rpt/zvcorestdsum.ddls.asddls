@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Core STD SUM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVCORESTDSUM
  as select from ZRCORE03
{
  key mmyyyy,
      prctrclub,
      CompanyCodeCurrency,
//      sum(AmountInCompanyCodeCurrency) as core
 sum( cast(AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as core
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
