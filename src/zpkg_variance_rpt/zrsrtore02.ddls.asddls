@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Store 02'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRSRTORE02 as select from ZRSRTORE01 as a
left outer join ZR_REJECTED_QTY_RATIO as c on a.OrderID = c.OrderID
{
    key a.mmyyyy,
    key a.prctrclub,
    a.CompanyCodeCurrency,
    a.AmountInCompanyCodeCurrency,
    c.ratio as ratio
}
