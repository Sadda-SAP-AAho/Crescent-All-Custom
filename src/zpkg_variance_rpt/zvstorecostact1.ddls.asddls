@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZVSTORECOSTACT1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVSTORECOSTACT1
  as select from ZVSTORECOSTACT
{
  key    mmyyyy,
  key    prctrclub,
         CompanyCodeCurrency,
         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         sum( store ) as store
}

group by
  CompanyCodeCurrency,
  mmyyyy,
  prctrclub
