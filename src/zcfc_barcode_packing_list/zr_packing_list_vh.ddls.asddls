@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PACKING_LIST_VH as select distinct from ZR_PACKING_LIST_HDR as _PackingListHdr
{
    @EndUserText.label: 'Delivery (Outbound No)'
    key _PackingListHdr.DeliveryDocument,
    @EndUserText.label: 'Consignee(Ship To Party No)'
    _PackingListHdr.ShipToParty,
    @EndUserText.label: 'Buyer Order No'
    _PackingListHdr.PurchaseOrderByCustomer
}
