@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Schedule line details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PLANING_RPT_V4
  as select from I_SalesOrderScheduleLine
{
  SalesOrder,
  SalesOrderItem,
  max( DeliveryDate ) as DeliveryDate
}
group by
  SalesOrder,
  SalesOrderItem
