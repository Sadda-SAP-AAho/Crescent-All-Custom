@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivered Quantity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SAL_REA_2
  as select from I_DeliveryDocumentItem as a
  inner join I_DeliveryDocument as b on b.DeliveryDocument = a.DeliveryDocument
{
  a.ReferenceSDDocument,
  a.ReferenceSDDocumentItem,
  @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
  sum( a.ActualDeliveryQuantity ) as sodelqty,
  a.DeliveryQuantityUnit
}
where b.ActualGoodsMovementDate is not initial
group by
  a.ReferenceSDDocument,
  a.ReferenceSDDocumentItem,
  a.DeliveryQuantityUnit
