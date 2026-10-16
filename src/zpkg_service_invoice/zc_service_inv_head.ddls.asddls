@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Consumption ~ Header'
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #XXL,
    dataClass: #TRANSACTIONAL
}
define root view entity ZC_SERVICE_INV_HEAD
  // provider contract transactional_query
  as projection on ZI_SERVICE_INV_HEAD
{
        @Search.defaultSearchElement: true
        @EndUserText.label: 'Accounting Document' //'Invoice No'
  key   InvoiceNo,
        @EndUserText.label: 'Fiscal Year'
  key   FiscalYear,
        @EndUserText.label: 'Invoice No'
        InvoiceReference,
        @EndUserText.label: 'Invoice Date'
        InvoiceDate,
        @EndUserText.label: 'Supplier GSTIN'
        InvoiceGSTIN,
        @EndUserText.label: 'Company Name'
        CompanyName,
        @EndUserText.label: 'Supplier Address 1'
        Address1,
        @EndUserText.label: 'Supplier Address 2'
        Address2,
        @EndUserText.label: 'Currency'
        Currency,
        @EndUserText.label: 'Customer'
        Customer,
        @EndUserText.label: 'Customer Name'
        CustomerName,
        @EndUserText.label: 'Street Name'
        CustomerStreetName,
        @EndUserText.label: 'Postal Code'
        CustomerPostalCode,
        @EndUserText.label: 'City'
        CustomerCity,
        @EndUserText.label: 'Country'
        CustomerCountry,
        @EndUserText.label: 'Customer GSTIN'
        CustomerGSTIN,
        @EndUserText.label: 'Bank Details'
        Bankdetails,
        @EndUserText.label: 'Bank Name'
        BankName,
        @EndUserText.label: 'Print'
        tprint,
        /* Associations */
        _Item : redirected to composition child ZC_SERVICE_INV_ITEM
}
