@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Elec. Stand. Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZVELECSTDSUM
  as select from ZRELECT03
{
  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
//      sum(AmountInCompanyCodeCurrency) as elect
 sum( cast(AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as elect
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
