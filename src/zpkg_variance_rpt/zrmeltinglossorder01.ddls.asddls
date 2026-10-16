@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Melting Loss Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRMELTINGLOSSORDER01 as select from ZRMELTINGLOSSORDER as a
 left outer join ZR_REJECTED_QTY_RATIO as c on a.OrderID = c.OrderID

{
    key a.mmyyyy,
    key a.prctrclub,
//    key a.OrderID,
    a.CompanyCodeCurrency,
    a.AmountInCompanyCodeCurrency,
    c.ratio as ratio
}
