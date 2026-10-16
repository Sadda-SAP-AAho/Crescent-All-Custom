@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view : BRC item details'
@Metadata.allowExtensions: true

define view entity ZC_BRC
  as projection on ZI_BRC

{
  key Id,
      @EndUserText.label: 'Shipping Bill'
  key ShippingBill,
      @EndUserText.label: 'BRC No.'
      Brcno,
      @EndUserText.label: 'BRC Date'
      Brcdate,
      @EndUserText.label: 'BRC Value'
      Brcvalue,
      @EndUserText.label: 'Upload Status'
      Updstatus,
      @UI.hidden: true
      Criticality,
      @UI.hidden: true
      Status,
      @EndUserText.label: 'Validation Message'
      Message,
      /* Associations */
      _BrcHead : redirected to parent ZC_BRC_HEAD
}
