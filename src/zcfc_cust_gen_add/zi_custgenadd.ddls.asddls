@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer General Address'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_CUSTGENADD
  as select distinct from I_Customer          as a
//    left outer join       I_CountryText       as b on  a.Country  = b.Country
//                                                   and b.Language = 'E'
//
//    left outer join       I_RegionText        as c on  a.Region   = c.Region
//                                                   and c.Language = 'E'

{
  key a.Customer,
      a.CustomerName,
      a.CreatedByUser,
      a.CreationDate,
      a.AddressID,
      a.CustomerAccountGroup,
      a.TaxNumber3,
      a.Supplier,
      a.Country,
      a.CityName,
      a.PostalCode,
      a.StreetName,
      a.SortField,
      a.FaxNumber,
      a.Region,
      a.TelephoneNumber1,
      a.TelephoneNumber2,
      a.DeletionIndicator,
      a.Language

}
