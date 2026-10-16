@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DPR BARODA _ Schedule line details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DPR_BARD_11 
  as select from I_SalesOrderScheduleLine as a
{
  a.SalesOrder,
  a.SalesOrderItem,
  max( a.ConfirmedDeliveryDate ) as ConfirmedDeliveryDate
}
where
  a.OpenConfdDelivQtyInOrdQtyUnit is not initial
group by
  a.SalesOrder,
  a.SalesOrderItem
