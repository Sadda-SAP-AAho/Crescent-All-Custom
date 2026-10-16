@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Basic Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_SUPP_DATA_BASIC
  as select distinct from I_Supplier                 as a
    left outer join       ZTBL_SUPPLIER_ADDRESS      as b on a.Supplier = b.suppcode
    left outer join       I_Businesspartnertaxnumber as c on  a.Supplier  = c.BusinessPartner
                                                          and c.BPTaxType = 'IN3'
    left outer join       ZTBL_SUPPLIER_BANK         as d on a.Supplier = d.BusinessPartner
    left outer join       ZTBL_SUPPLIER_LAST_PO      as e on a.Supplier = e.suppcode
    left outer join       I_CountryText              as f on  f.Country  = b.Country
                                                          and f.Language = 'E'
    left outer join       I_RegionText               as g on  g.Country  = b.Country
                                                          and g.Region   = b.Region
                                                          and g.Language = 'E'

{
  key a.Supplier,
      a.SupplierName,
      b.StreetName,
      b.CityName,
      g.RegionName               as Region,
      f.CountryName              as Country,
      b.PostalCode,
      c.BPTaxNumber              as GSTNo,
      a.BusinessPartnerPanNumber as PANNo,
      d.BankNumber               as IFSC,
      d.BankAccount              as AcNo,
      d.BankAccountHolderName    as AcName,
      e.pono,
      e.podate,
      e.createby

}
