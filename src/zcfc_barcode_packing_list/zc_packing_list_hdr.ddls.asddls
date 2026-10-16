@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Packing List Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_PACKING_LIST_HDR
  provider contract transactional_query as projection on ZI_PACKING_LIST_HDR
{
    key DeliveryDocument,
    ActualGoodsMovementDate,
    ShipToParty,
    CustomerName,
    Street,
    StreetName,
    CityName,
    DistrictName,
    Region,
    Country,
    PostalCode,
    PurchaseOrderByCustomer,
    CustomerPurchaseOrderDate,
    PreCarriageBy,
    ShippingCityName,
    ShippingCountry,
    DestinationCountry,
    PortofLoading,
    DeliveryTerm,
    PlaceofDelivery,
    PortofDischarge,
    GoodsDescription,
    MarksContainer,
    As_per_sales_note_no,
    /* Associations */
    _PackingListItm : redirected to composition child ZC_PACKING_LIST_ITM 
}
