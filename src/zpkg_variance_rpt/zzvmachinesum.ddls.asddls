//@AbapCatalog.sqlViewName: 'ZVMACHSTDSUM'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Machine STD SUM'
//@Metadata.ignorePropagatedAnnotations: true

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Testing Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity  ZZVMACHINESUM
  as select from ZRMACHINE03
{
  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
//      sum(AmountInCompanyCodeCurrency) as machine
      sum( cast(AmountInCompanyCodeCurrency as abap.dec(23,2)) ) as machine
      
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
