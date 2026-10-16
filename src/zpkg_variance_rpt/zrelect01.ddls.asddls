@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Electricity Cost'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRELECT01

  as select from ZVELECACT
{
  key mmyyyy,
  key prctrclub,
  key OrderID,
      CompanyCodeCurrency,
      sum(AmountInCompanyCodeCurrency) as AmountInCompanyCodeCurrency,
      sum( quantity )                  as quantity
}
group by
  mmyyyy,
  prctrclub,
  OrderID,
  CompanyCodeCurrency
