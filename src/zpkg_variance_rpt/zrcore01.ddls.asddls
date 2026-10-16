@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Core 01'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRCORE01 as select from ZVCORESTD
{
     key mmyyyy,
    key prctrclub,
    key OrderID,
    CompanyCodeCurrency,
    sum(AmountInCompanyCodeCurrency) as AmountInCompanyCodeCurrency,
    sum( quantity ) as quantity
}
group by     mmyyyy,
    prctrclub,
    OrderID,
    CompanyCodeCurrency
