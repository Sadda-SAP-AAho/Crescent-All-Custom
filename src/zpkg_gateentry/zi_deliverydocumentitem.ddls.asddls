@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Document Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_deliverydocumentitem
  as select from I_DeliveryDocumentItem
{
  key DeliveryDocument,
  key substring( DeliveryDocumentItem , 1 , 6 ) as DeliveryDocumentItem,
      Product,
      DeliveryDocumentItemText,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      ActualDeliveryQuantity,
      DeliveryQuantityUnit,
      ReferenceSDDocument,
      ReferenceSDDocumentItem,
      Plant,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      ItemNetWeight
}
