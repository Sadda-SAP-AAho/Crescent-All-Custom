@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity View for Packing List Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PACKING_LIST_HDR as select from ZR_PACKING_LIST_HDR as _PackingListHdr
composition [0..*] of ZI_PACKING_LIST_ITM as _PackingListItm
{
    key _PackingListHdr.DeliveryDocument,
    _PackingListHdr.ActualGoodsMovementDate,
    _PackingListHdr.ShipToParty,
    _PackingListHdr.CustomerName,
    _PackingListHdr.Street,
    _PackingListHdr.StreetName,
    _PackingListHdr.CityName,
    _PackingListHdr.DistrictName,
    _PackingListHdr.Region,
    _PackingListHdr.Country,
    _PackingListHdr.PostalCode,
    _PackingListHdr.PurchaseOrderByCustomer,
    _PackingListHdr.CustomerPurchaseOrderDate,
    _PackingListHdr.PreCarriageBy,
    _PackingListHdr.ShippingCityName,
    _PackingListHdr.ShippingCountry,
    _PackingListHdr.DestinationCountry,
    _PackingListHdr.PortofLoading,
    _PackingListHdr.DeliveryTerm,
    _PackingListHdr.PlaceofDelivery,
    _PackingListHdr.PortofDischarge,
    _PackingListHdr.GoodsDescription,
    _PackingListHdr.MarksContainer,
    _PackingListHdr.As_per_sales_note_no,
    _PackingListItm
}
