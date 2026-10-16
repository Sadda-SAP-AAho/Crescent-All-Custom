@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Modelling Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZVMODELSTDSUM
  as select from ZRMODEL03
{
  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
//      sum(AmountInCompanyCodeCurrency) as model
 sum( cast(AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as model
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
