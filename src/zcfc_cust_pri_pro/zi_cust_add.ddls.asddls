@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Customer Address'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_CUST_ADD
  as select distinct from I_Customer as a

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
