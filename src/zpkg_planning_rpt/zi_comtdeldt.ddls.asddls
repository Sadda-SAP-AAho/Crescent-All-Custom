@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO Item wise Committed Delivery Date'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_COMTDELDT
  as select distinct from I_SalesOrder     as a
    left outer join       I_SalesOrderItem as b on a.SalesOrder = b.SalesOrder
{
  key a.SalesOrder,
  key b.SalesOrderItem,
      ( case when b.YY1_OTIFDate_SDI is initial then b.CommittedDeliveryDate
               else b.YY1_OTIFDate_SDI end ) as CommittedDeliveryDate
}
