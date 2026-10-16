@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PACKING_LIST_HDR
  as select from    I_DeliveryDocument         as _DeliveryDocument
    left outer join I_Customer                 as _Customer                 on _DeliveryDocument.ShipToParty = _Customer.Customer
    left outer join I_AddrOrgNamePostalAddress as _PostalAddress            on _PostalAddress.AddressID = _Customer.AddressID
    left outer join ZR_DELV_ORDER_REF          as _DelvRef                  on _DeliveryDocument.DeliveryDocument = _DelvRef.DeliveryDocument
    left outer join I_ShippingPoint            as _ShippingPoint            on _DeliveryDocument.ShippingPoint = _ShippingPoint.ShippingPoint
    left outer join I_ShippingPointText        as _ShippingPointText        on  _DeliveryDocument.ShippingPoint = _ShippingPointText.ShippingPoint
                                                                            and _ShippingPointText.Language     = $session.system_language
    left outer join I_AddrOrgNamePostalAddress as _PostalAddressShipping    on _ShippingPoint.AddressID = _PostalAddressShipping.AddressID
    left outer join I_AddrOrgNamePostalAddress as _PostalAddressShiptoParty on _Customer.AddressID = _PostalAddressShiptoParty.AddressID
    left outer join I_ShippingConditionText    as _ShippingConditionText    on  _DeliveryDocument.ShippingCondition = _ShippingConditionText.ShippingCondition
                                                                            and _ShippingConditionText.Language     = $session.system_language
    left outer join ZI_DELDASH_HDR             as _GoodsDesc                on _DeliveryDocument.DeliveryDocument = _GoodsDesc.Delivery                                                      
{
  key _DeliveryDocument.DeliveryDocument           as DeliveryDocument,
      _DeliveryDocument.ActualGoodsMovementDate    as ActualGoodsMovementDate,
      _DeliveryDocument.ShipToParty                as ShipToParty,
      _Customer.CustomerName                       as CustomerName,
      _PostalAddress.Street                        as Street,
      _PostalAddress.StreetName                    as StreetName,
      _PostalAddress.CityName                      as CityName,
      _PostalAddress.DistrictName                  as DistrictName,
      _PostalAddress.Region                        as Region,
      _PostalAddress.Country                       as Country,
      _PostalAddress.PostalCode                    as PostalCode,
      _DelvRef.PurchaseOrderByCustomer             as PurchaseOrderByCustomer,
      _DelvRef.CustomerPurchaseOrderDate           as CustomerPurchaseOrderDate,
      _ShippingPointText.ShippingPointName         as PreCarriageBy,
//      _PostalAddressShipping.CityName              as ShippingCityName,
        _GoodsDesc.Por          as ShippingCityName,
//      _PostalAddressShipping.Country               as ShippingCountry,
      _GoodsDesc.Coo                               as ShippingCountry,
//      _PostalAddressShiptoParty.Country            as DestinationCountry,
      _GoodsDesc.Cod                               as DestinationCountry,
//      _PostalAddressShipping.CityName              as PortofLoading,
      _GoodsDesc.Pol                               as PortofLoading,
      _ShippingConditionText.ShippingConditionName as DeliveryTerm,
//      concat_with_space( _PostalAddress.CityName, _PostalAddress.Country , 1 ) as PlaceofDelivery,
        _GoodsDesc.Placedel as PlaceofDelivery,
//      concat_with_space( _PostalAddress.CityName, _PostalAddress.Country , 1 ) as PortofDischarge,
      _GoodsDesc.Pod as PortofDischarge,
      _GoodsDesc.Descgoods                       as GoodsDescription,
      concat_with_space(_GoodsDesc.Cusmar,_GoodsDesc.Contno , 1) as MarksContainer,
      _GoodsDesc.Salesnoteref as As_per_sales_note_no
      

}
