@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Quantity Against SO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SOPENSO_DELQTY
  as select from    I_SalesOrderItem       as c
    left outer join I_DeliveryDocumentItem as a on  c.SalesOrder     = a.ReferenceSDDocument
                                                and c.SalesOrderItem = a.ReferenceSDDocumentItem
    left outer join I_DeliveryDocument     as b on b.DeliveryDocument = a.DeliveryDocument


{
  c.SalesOrder                    as ReferenceSDDocument,
  c.SalesOrderItem                as ReferenceSDDocumentItem,
  c.OrderQuantityUnit,
  @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
  c.OrderQuantity,
  @Semantics.quantity.unitOfMeasure : 'DeliveryQuantityUnit'
  sum( a.ActualDeliveryQuantity ) as delivqty,
  a.DeliveryQuantityUnit
}
where
  b.OverallGoodsMovementStatus = 'C'
group by
  c.SalesOrder,
  c.SalesOrderItem,
  c.OrderQuantityUnit,
  c.OrderQuantity,
  a.DeliveryQuantityUnit
