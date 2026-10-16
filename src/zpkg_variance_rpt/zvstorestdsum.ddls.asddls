@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Store Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZVSTORESTDSUM
  as select from ZRSRTORE03
{
  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
//      sum(AmountInCompanyCodeCurrency) as storestd
 sum( cast(AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as storestd
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
