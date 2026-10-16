@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity View for Packing List Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_PACKING_LIST_ITM as select from ZR_PACKING_LIST_ITM as _PackingListItm
association to parent ZI_PACKING_LIST_HDR as _PackingListHdr on $projection.DeliveryDocument = _PackingListHdr.DeliveryDocument
{
    key _PackingListItm.DeliveryDocument,
    key _PackingListItm.DeliveryDocumentItem,
    _PackingListItm.Material,
    _PackingListItm.DeliveryDocumentItemText,
    _PackingListItm.ConsumptionTaxCtrlCode,
    _PackingListItm.PurchaseOrderByCustomer,
    _PackingListItm.CustomerPurchaseOrderDate,
    @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
    _PackingListItm.ActualDeliveryQuantity,
    _PackingListItm.DeliveryQuantityUnit,
    @Semantics.quantity.unitOfMeasure: 'Meins'
    _PackingListItm.PackageNumber,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    _PackingListItm.EachNetWeight,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    _PackingListItm.EachGrossWeight,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    _PackingListItm.NetWeight,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    _PackingListItm.GrossWeight,
    _PackingListItm.PackageType,
    _PackingListItm.WeightUnit,
    _PackingListItm.Meins,
    _PackingListHdr
}where _PackingListItm.control_code <> '';
