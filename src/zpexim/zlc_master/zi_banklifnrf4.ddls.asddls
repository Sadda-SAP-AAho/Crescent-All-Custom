@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 Help for Bank Vendor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_banklifnrF4 
as select from I_Supplier as supp
{
    supp.Supplier,
    supp.SupplierAccountGroup,
    supp.SupplierName,
    supp.SupplierFullName,
    supp.BPSupplierName,
    supp.BPSupplierFullName,
    supp.BPAddrCityName,
    supp.BPAddrStreetName,
    supp.AddressSearchTerm1,
    supp.AddressSearchTerm2,
    supp.DistrictName,
    supp.POBoxDeviatingCityName,
    supp.BusinessPartnerFormOfAddress,
    supp.IsBusinessPurposeCompleted,
    supp.CreatedByUser,
    supp.CreationDate,
    supp.IsOneTimeAccount,
    supp.AuthorizationGroup,
    supp.VATRegistration,
    supp.AccountIsBlockedForPosting,
    supp.TaxJurisdiction,
    supp.SupplierStandardCarrierAccess,
    supp.SupplierFwdAgentFreightGroup,
    supp.SupplierAgentProcedureGroup,
    supp.SupplIsSocialInsuranceRegtrd,
    supp.SocialInsuranceActivityCode,
    supp.SupplierCorporateGroup,
    supp.Customer,
    supp.Industry,
    supp.TaxNumber1,
    supp.PostingIsBlocked,
    supp.PurchasingIsBlocked,
    supp.InternationalLocationNumber1,
    supp.InternationalLocationNumber2,
    supp.InternationalLocationNumber3,
    supp.AddressID,
    supp.Region,
    supp.OrganizationBPName1,
    supp.OrganizationBPName2,
    supp.CityName,
    supp.PostalCode,
    supp.StreetName,
    supp.Country
 
}
