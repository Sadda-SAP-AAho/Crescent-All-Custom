@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Partner Function Address'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUSFUNCADD
  provider contract transactional_query
  as projection on I_BusinessPartnerAddressTP_3
{

       @EndUserText.label: 'Business Partner'
       @Search.defaultSearchElement: true
  key  BusinessPartner,
       @EndUserText.label: 'AddressNumber'
       @Search.defaultSearchElement: true
  key  AddressNumber,
       @EndUserText.label: 'Validity Start Date'
       ValidityStartDate,
       @EndUserText.label: 'Validity End Date'
       ValidityEndDate,
       @EndUserText.label: 'House Number'
       HouseNumber,
       @EndUserText.label: 'Street Name'
       StreetName,
       @EndUserText.label: 'District Name'
       DistrictName,
       @EndUserText.label: 'Postal Code'
       PostalCode,
       @EndUserText.label: 'City Name'
       HomeCityName,
       @EndUserText.label: 'Country'
       Country,
       @EndUserText.label: 'Region'
       Region,
       @EndUserText.label: 'Address Time Zone'
       AddressTimeZone,
       @EndUserText.label: 'Correspondence Language'
       CorrespondenceLanguage,
       @EndUserText.label: 'Street Suffix Name'
       StreetSuffixName,
       @EndUserText.label: 'Additional Street Suffix Name'
       AdditionalStreetSuffixName





}
