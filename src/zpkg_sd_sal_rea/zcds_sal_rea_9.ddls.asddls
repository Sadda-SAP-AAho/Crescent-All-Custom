@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exchange Rate Sales order wise'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_9 
as select from ZCDS_SAL_REA_8 as a
inner join    I_ExchangeRateRawData   as c   on c.ValidityStartDate = a.ValidityStartDate
                                            and c.SourceCurrency = 'USD' and c.TargetCurrency = 'INR'
{
    a.SalesOrder,
    a.SalesOrderItem,
    c.ExchangeRate
}
