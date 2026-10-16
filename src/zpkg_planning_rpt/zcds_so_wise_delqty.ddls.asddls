@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO wise Delivery Quantity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SO_WISE_DELQTY 
as select from I_DeliveryDocumentItem
{
    ReferenceSDDocument,
    ReferenceSDDocumentItem,
    @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
    sum( ActualDeliveryQuantity ) as sodelqty,
    DeliveryQuantityUnit
}
group by
ReferenceSDDocument,
ReferenceSDDocumentItem,
DeliveryQuantityUnit
