@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Testing Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZVMETINGSTDS
  as select from ZRMELTING03
{

  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
//      sum(AmountInCompanyCodeCurrency) as meting
 sum( cast(AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as meting

}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
