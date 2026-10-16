@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Freight Exchange Rate'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_8 
as select from    I_SalesOrderItem        as a
    inner join    I_SalesOrder            as b   on b.SalesOrder = a.SalesOrder
    inner join    I_ExchangeRateRawData   as c   on c.ValidityStartDate <= b.CreationDate
                                                and c.SourceCurrency = 'USD' and c.TargetCurrency = 'INR'
{
    a.SalesOrder,
    a.SalesOrderItem,
    max( c.ValidityStartDate ) as ValidityStartDate 
}
group by
a.SalesOrder,
a.SalesOrderItem
