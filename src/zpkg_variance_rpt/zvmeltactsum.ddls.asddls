@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Activiry Melting Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVMELTACTSUM
  as select from ZRMELTINGLOSSORDER02
{
  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
//      sum(AmountInCompanyCodeCurrency) as amt,
       sum( cast(AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as amt
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
