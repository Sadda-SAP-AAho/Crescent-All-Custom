@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ship To details for Sales Credit Note'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZSD_SALES_CDN_SHIP_TO
as select from    I_BillingDocument        as a
    left outer join I_BillingDocItemPartner as b on a.BillingDocument = b.BillingDocument
    left outer join I_Address_2              as c on b.AddressID = c.AddressID
{
  key a.BillingDocument,
      b.Customer,
      c.AddresseeFullName,
      c.Building,
      c.HouseNumber,
      c.Street,
      c.StreetName,
      c.CityName,
      c.DistrictName,
      c.Region,
      c.Country

}

where
  b.PartnerFunction = 'WE' 
