@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SAP Vendor List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_SAP_VENDOR_LIST
  as select distinct from I_Supplier         as a
    left outer join       ZTBL_SUPPLIER_BANK as b on a.Supplier = b.BusinessPartner
    left outer join       I_CountryText      as c on  c.Country  = a.Country
                                                  and c.Language = 'E'
    left outer join       I_RegionText       as d on  d.Country  = a.Country
                                                  and d.Region   = a.Region
                                                  and d.Language = 'E'                                            

{
  key a.Supplier,
      a.SupplierName,
      a.PhoneNumber1             as PhoneNo,
      a.StreetName               as Address,
      a.CityName                 as City,
      d.RegionName               as State,
      c.CountryName              as Country,
      a.PostalCode               as PinCode,
      a.BusinessPartnerPanNumber as PANNo,
      a.TaxNumber3               as GSTNo,
      b.BankAccount              as BankAcNo,
      b.BankAccountHolderName    as BankAcName,
      b.BankNumber               as IFSC,
      a.PurchasingIsBlocked      as PurchaseBlock,
      a.PostingIsBlocked         as CentralBlock
}
