@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Labour Std Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZVLABOURSTDS
  as select from ZRLABOUR03
{
  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
//      sum(AmountInCompanyCodeCurrency) as labour
      sum( cast(AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as labour
      
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
