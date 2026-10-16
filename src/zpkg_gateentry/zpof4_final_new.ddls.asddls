@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Final F4 for PO'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZPOF4_FINAL_NEW as select from ZPOF4_FINAL_N
{
  key PurchaseOrder,
  key PurchaseOrderItem,
  key deliverydocument,
  key deliverydocumentitem,
  key DeliveryDocumentBySupplier,
  key BillOfLading,
  key Meins,
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  key NetAmount,
  @Semantics.amount.currencyCode: 'DocumentCurrency'
  key NetPriceAmount,
  key DocumentCurrency,
  @Semantics.quantity.unitOfMeasure : 'Meins'
  key bal_qty,
  key Plant,
  key PurchaseOrderItemText,
  key PurchaseOrderQuantityUnit,
  key Material,
  @Semantics.quantity.unitOfMeasure : 'Meins'
  key OrderQuantity,
  key OverallSDProcessStatus,
  key Vendorcode,
  key PO,
  key UnloadingPointName,
  @Semantics.quantity.unitOfMeasure : 'Meins'
  ActualDeliveryQuantity   
}
