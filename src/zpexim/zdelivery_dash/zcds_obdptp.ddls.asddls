@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for I_OUTBOUNDDELIVERYPARTNERTP'
define view entity ZCDS_OBDPTP
 as select distinct from I_DeliveryDocument as a
 //inner join I_OutboundDeliveryPartnerTP as b on b.OutboundDelivery = a.DeliveryDocument
 //                                               and b.PartnerFunction = 'WE'
 //                                               inner join I_BusinessPartnerAddressTP_3 as c on c.BusinessPartner = b.Customer and
 //                                               c.AddressNumber = b.AddressID
 // inner join I_Customer as d on d.Customer = b.Customer
{
    key a.DeliveryDocument
//        b.Customer,
//        b.AddressID,
//        c.StreetName,
//        c.PostalCode,
//        c.CityName,
//        c.Country,
//        d.CustomerName
}
