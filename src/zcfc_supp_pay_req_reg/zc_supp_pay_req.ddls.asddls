@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption View for Supplier Payment Request'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_SUPP_PAY_REQ
  provider contract transactional_query
  as projection on ZI_SUPP_PAY_REQ
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Keyid'
      Keyid,
      @EndUserText.label: 'Fiscsal Year'
      fisyear,
      @EndUserText.label: 'Creation Date'
      Creon,
      @EndUserText.label: 'Document Number'
      DocNum,
      @EndUserText.label: 'Document Date'
      DocDate,
      @EndUserText.label: 'Created By'
      CreatedBy,
      @EndUserText.label: 'Created By Name'
      CreatedByName,
      @EndUserText.label: 'Vendor Code'
      VendorCode,
      @EndUserText.label: 'Vendor Name'
      VendorName,
      @EndUserText.label: 'Payment Amount'
      PaymentAmount
}
