@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 Help for Vendor Code'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_lifnrF4 
as select from I_Supplier as sup
{
    key sup.Supplier,
        sup.SupplierAccountGroup,
        sup.SupplierName,
        sup.SupplierFullName,
        sup.BPSupplierName,
        sup.BPSupplierFullName,
        sup.BusinessPartnerName1,
        sup.BusinessPartnerName2,
        sup.BusinessPartnerName3,
        sup.BusinessPartnerName4,
        sup.BPAddrCityName,
        sup.BPAddrStreetName,
        sup.AddressSearchTerm1,
        sup.AddressSearchTerm2,
        sup.DistrictName
       
}
