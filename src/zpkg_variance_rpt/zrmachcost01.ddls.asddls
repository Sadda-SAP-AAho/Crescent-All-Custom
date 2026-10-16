@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Machine Cost 01'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRMACHCOST01 as select from ZVmachinecoststd
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
