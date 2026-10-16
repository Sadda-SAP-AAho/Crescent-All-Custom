@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Order Reference'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_DELV_ORDER_REF as select distinct from I_DeliveryDocumentItem as _DeliveryDocumentItem
left outer join I_SalesDocument as _SalesDocument on _DeliveryDocumentItem.ReferenceSDDocument = _SalesDocument.SalesDocument
{
    key _DeliveryDocumentItem.DeliveryDocument,
        _DeliveryDocumentItem.ReferenceSDDocument,
        _SalesDocument.PurchaseOrderByCustomer,
        _SalesDocument.CustomerPurchaseOrderDate
}
