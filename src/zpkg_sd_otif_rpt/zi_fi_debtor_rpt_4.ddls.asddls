@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OTIF Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_4 
as select from I_SalesOrderItem as a
inner join I_SalesOrderScheduleLine as b on b.SalesOrder = a.SalesOrder and b.SalesOrderItem = a.SalesOrderItem
{
    key a.SalesOrder,
    key a.SalesOrderItem,
    max( b.ScheduleLine ) as ScheduleLine
}
group by
a.SalesOrder,
a.SalesOrderItem
