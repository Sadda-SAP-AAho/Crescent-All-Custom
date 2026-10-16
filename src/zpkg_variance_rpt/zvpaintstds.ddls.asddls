@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Paint Std Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZVPAINTSTDS
  as select from ZRPAINT03
{
  key mmyyyy,
      prctrclub,
      CompanyCodeCurrency,
//      sum(AmountInCompanyCodeCurrency) as paint
      sum( cast(AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as paint
      
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
