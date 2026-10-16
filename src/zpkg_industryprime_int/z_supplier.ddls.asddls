@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier master'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z_SUPPLIER
  as select from    I_Supplier            as Supplier
    left outer join I_BusinessPartnerBank as bnk on Supplier.Supplier = bnk.BusinessPartner
{
  key Supplier.Supplier,
      Supplier.BPSupplierFullName,
      Supplier.Region,
      Supplier.Country,
      Supplier.PhoneNumber1,
      Supplier.PhoneNumber2,
      Supplier.PostalCode,
      Supplier.CityName,
      Supplier.BPAddrStreetName,
      Supplier.StreetName,
      Supplier.BusinessPartnerPanNumber,
      Supplier.TaxNumber3,

      bnk.BankAccount,
      bnk.BankControlKey as BankNumber,
      bnk.BankName
}
