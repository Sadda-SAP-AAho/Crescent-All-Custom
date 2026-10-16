@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Confirm Delivery Date'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CONDELDATE
  as select from I_SalesOrderScheduleLine as a
{
  key a.SalesOrder,
  key a.SalesOrderItem,
      max( a.ConfirmedDeliveryDate ) as ConfirmedDeliveryDate
}
where
  a.OpenConfdDelivQtyInOrdQtyUnit is not initial
group by
  a.SalesOrder,
  a.SalesOrderItem
