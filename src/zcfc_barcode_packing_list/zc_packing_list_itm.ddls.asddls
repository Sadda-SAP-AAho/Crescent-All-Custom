@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Packing List Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_PACKING_LIST_ITM
  as projection on ZI_PACKING_LIST_ITM
{
    key DeliveryDocument,
    key DeliveryDocumentItem,
    Material,
    DeliveryDocumentItemText,
    ConsumptionTaxCtrlCode,
    PurchaseOrderByCustomer,
    CustomerPurchaseOrderDate,
    @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
    ActualDeliveryQuantity,
    DeliveryQuantityUnit,
    @Semantics.quantity.unitOfMeasure: 'Meins'
    PackageNumber,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    EachNetWeight,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    EachGrossWeight,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    NetWeight,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    GrossWeight,
    PackageType,
    WeightUnit,
    Meins,
    /* Associations */
    _PackingListHdr : redirected to parent ZC_PACKING_LIST_HDR
}
