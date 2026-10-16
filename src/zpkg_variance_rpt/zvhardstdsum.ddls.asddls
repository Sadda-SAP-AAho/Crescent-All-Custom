@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hard Coke Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZVHARDSTDSUM
  as select from ZRHARDCOKE03
{
  key mmyyyy,
      prctrclub,
      CompanyCodeCurrency,
//      sum(AmountInCompanyCodeCurrency) as amt
 sum( cast(AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as amt
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
