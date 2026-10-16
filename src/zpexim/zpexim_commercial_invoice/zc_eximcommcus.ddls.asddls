@EndUserText.label: 'Commercial Customer'
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_EXIMCOMMCUS

  as projection on ZI_EXIMCOMMCUS

{

      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Address Type'
      Addresstype,
      @EndUserText.label: 'Address Type desc.'
      Addresstypedesc,
      @EndUserText.label: 'Name 1'
      Name1,
      @EndUserText.label: 'Name 2'
      Name2,
      @EndUserText.label: 'Address 1'
      Address1,
      @EndUserText.label: 'Address 2'
      Address2,
      @EndUserText.label: 'Address 3'
      Address3,
      @EndUserText.label: 'Street 1'
      Street1,
      @EndUserText.label: 'Street 2'
      Street2,
      @EndUserText.label: 'Country'
      Country,
      @EndUserText.label: 'Pincode'
      Pincode,

      _head : redirected to parent ZC_EXIMCOMMHDR

}
