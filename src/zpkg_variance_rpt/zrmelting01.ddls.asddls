@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Melting 01'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRMELTING01 as select from ZVMELTINGSTD
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
