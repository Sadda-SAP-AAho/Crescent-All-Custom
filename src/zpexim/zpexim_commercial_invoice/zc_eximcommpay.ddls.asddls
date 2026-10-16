@EndUserText.label: 'Commercial Payment'
@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_EXIMCOMMPAY

  as projection on ZI_EXIMCOMMPAY

{

      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Payment Terms'
      Paymentterms,
      @EndUserText.label: 'Payment Terms Desc.'
      Paymenttermsdesc,
      @EndUserText.label: 'Bank Name'
      Bankname,
      @EndUserText.label: 'Bank Account No.'
      Bankaccountno,
      @EndUserText.label: 'Bank IFSC'
      Bankifsc,
      @EndUserText.label: 'Bank Swift'
      Bankswift,
      @EndUserText.label: 'Bank Address'
      Bankaddress,
      @EndUserText.label: 'Issuing Bank'
      Issuingbank,
      @EndUserText.label: 'Negotiating Bank'
      Negotiatingbank,
      @EndUserText.label: 'LC Number'
      Lcnumber,
      @EndUserText.label: 'LUT ARN No.'
      Lutarnno,
      @EndUserText.label: 'LUT ARN Date'
      Lutarndate,
      @EndUserText.label: 'AD Code'
      Adcode,
      /* Associations */
      _head : redirected to parent ZC_EXIMCOMMHDR

}
