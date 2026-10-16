@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Address'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_SUPPLIER_ADDRESS
  provider contract transactional_query
  as projection on I_BusinessPartnerAddressTP_3 as a
{
  key a.BusinessPartner,
  key a.AddressNumber,
      a.StreetName,
      a.CityName,
      a.Region,
      a.Country,
      a.PostalCode
}
