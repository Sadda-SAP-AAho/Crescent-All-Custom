@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption view for Cust Sell Exp-Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_CUSTSLEXPITM
  as projection on ZI_CUSTSLEXPITM
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Date From'
      Datefrom,
      @EndUserText.label: 'Date To'
      Dateto,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Rate'
      Rate,
      /* Associations */
      _Head : redirected to parent ZC_CUSTSLEXPHDR
}
