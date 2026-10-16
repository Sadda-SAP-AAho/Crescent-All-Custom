@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer General Address'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_CUSTGENADD
  provider contract transactional_query
  as projection on ZI_CUSTGENADD
{
    @EndUserText.label: 'Customer'
    @Search.defaultSearchElement: true
    key Customer,
    @EndUserText.label: 'Customer Name'
    CustomerName,
    @EndUserText.label: 'Created By User'
    CreatedByUser,
    @EndUserText.label: 'Creation Date'    
    CreationDate,
    @EndUserText.label: 'Address Id'    
    AddressID,
    @EndUserText.label: 'Customer Account Group'    
    CustomerAccountGroup,
    @EndUserText.label: 'Tax Number 3'  
    TaxNumber3,
    @EndUserText.label: 'Supplier'     
    Supplier,
    @EndUserText.label: 'Country'     
    Country,
    @EndUserText.label: 'City'     
    CityName,
    @EndUserText.label: 'Postal Code'     
    PostalCode,
    @EndUserText.label: 'Street Name'     
    StreetName,
    @EndUserText.label: 'Sort Field'
    SortField,
    @EndUserText.label: 'Fax Number'     
    FaxNumber,
    @EndUserText.label: 'Region'    
    Region,
    @EndUserText.label: 'Telephone No. 1'     
    TelephoneNumber1,
    @EndUserText.label: 'Telephone No. 2'     
    TelephoneNumber2,
    @EndUserText.label: 'Deletion Indicator'
    DeletionIndicator,
    @EndUserText.label: 'Language'    
    Language
}
