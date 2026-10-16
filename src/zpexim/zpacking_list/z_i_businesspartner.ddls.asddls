@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Copy of i_businesspartneraddresstp_3'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_businesspartner provider contract transactional_query as projection on I_BusinessPartnerAddressTP_3
{
   
   key BusinessPartner,
 
   key AddressNumber,
  
   AddressIDForEdit,
   BusinessPartnerAddressUUID,
  
   ValidityStartDate,
 
   ValidityEndDate,
   CareOfName,
   StreetPrefixName,
   AdditionalStreetPrefixName,
   HouseNumber,
   StreetName,
   HouseNumberSupplementText,
   StreetSuffixName,
   AdditionalStreetSuffixName,
   HomeCityName,
   District,
   DistrictName,
   PostalCode,
   CityName,
   Country,
   Region,
   AddressTimeZone,
   TransportZone,
   TaxJurisdiction,
   CompanyPostalCode,
   DeliveryServiceTypeCode,
   DeliveryServiceNumber,
   POBox,
   POBoxIsWithoutNumber,
   POBoxPostalCode,
   POBoxLobbyName,
   POBoxDeviatingCityName,
   POBoxDeviatingRegion,
   POBoxDeviatingCountry,
   CorrespondenceLanguage,
   PrfrdCommMediumType,

   AddressLine1Text,

   FormattedAddress,

   CompleteAddress,
   BPAddressIsProtected, 
   StandardUsage,
   AddressNonDeliverableReason,
   PostBoxNonDeliverableReason,
   Building,
   Floor,
   RoomNumber,

   County, 
   BPCountyText,
   
   ////////////// Start of Datacontroller 10+1 fields -  Not to be consumed by any other views//////////
  
          DataControllerSet,
 
          DataController1,


          DataController2,

          DataController3,

          DataController4,
   
          DataController5,

          DataController6,
  
          DataController7,

          DataController8,

          DataController9,

          DataController10,
             _BPProtectedAddress,
              _CountryText
    
}
