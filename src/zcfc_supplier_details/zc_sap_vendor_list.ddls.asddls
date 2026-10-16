@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SAP Vendor LIst'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE

define root view entity ZC_SAP_VENDOR_LIST
  provider contract transactional_query
  as projection on ZI_SAP_VENDOR_LIST

{
      @EndUserText.label: 'Supplier Code'
  key Supplier,

      @EndUserText.label: 'Supplier Name'
      SupplierName,

      @EndUserText.label: 'Phone No.'
      PhoneNo,

      @EndUserText.label: 'Address'
      Address,

      @EndUserText.label: 'City'
      City,

      @EndUserText.label: 'State'
      State,

      @EndUserText.label: 'Country'
      Country,

      @EndUserText.label: 'PIN Code'
      PinCode,

      @EndUserText.label: 'PAN No.'
      PANNo,

      @EndUserText.label: 'GST No.'
      GSTNo,

      @EndUserText.label: 'Bank Account No.'
      BankAcNo,

      @EndUserText.label: 'Bank Account Name'
      BankAcName,

      @EndUserText.label: 'Bank IFSC'
      IFSC,

      @EndUserText.label: 'Purchase Block'
      PurchaseBlock,

      @EndUserText.label: 'Central Block'
      CentralBlock

}
