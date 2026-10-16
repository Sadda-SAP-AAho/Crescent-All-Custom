@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Machine Cost STD SUM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZVMACHCOSTSUM
  as select from ZRMACHCOST03
{
  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
//      sum(AmountInCompanyCodeCurrency) as mach
 sum( cast(AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as mach

}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
