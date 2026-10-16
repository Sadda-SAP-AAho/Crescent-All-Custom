@AbapCatalog.sqlViewName: 'ZVCUSTOMER'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Customer details'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_CUSTOMER
  as select from I_Customer
{
  key Customer,
      CustomerName,
      CustomerFullName,
      BPCustomerName,
      BPCustomerFullName,
      CreatedByUser,
      CreationDate,
      StreetName,
      PostalCode,
      CityName,
      Country,
      TaxNumber3 

}
