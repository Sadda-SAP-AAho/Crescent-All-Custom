@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier Basic Data'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE

define root view entity ZC_SUPP_DATA_BASIC
  provider contract transactional_query
  as projection on ZI_SUPP_DATA_BASIC
{
      @EndUserText.label: 'Supplier Code'
  key Supplier,

      @EndUserText.label: 'Supplier Name'
      SupplierName,

      @EndUserText.label: 'Address'
      StreetName,

      @EndUserText.label: 'City'
      CityName,

      @EndUserText.label: 'Region'
      Region,

      @EndUserText.label: 'Country'
      Country,

      @EndUserText.label: 'Postal Code'
      PostalCode,

      @EndUserText.label: 'GST No.'
      GSTNo,
      
      @EndUserText.label: 'PAN No.'
      PANNo,

      @EndUserText.label: 'Bank IFSC'
      IFSC,

      @EndUserText.label: 'Bank Account No.'
      AcNo,

      @EndUserText.label: 'Bank Account Name'
      AcName,

      @EndUserText.label: 'Last PO No.'
      pono,

      @EndUserText.label: 'Last PO Date'
      podate,

      @EndUserText.label: 'Last PO Created By'
      createby
}
