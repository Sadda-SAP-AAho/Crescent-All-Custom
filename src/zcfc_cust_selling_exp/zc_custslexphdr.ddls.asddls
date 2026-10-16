@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Consumption view for Cust Sell Exp-Head'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_CUSTSLEXPHDR
  provider contract transactional_query
  as projection on ZI_CUSTSLEXPHDR
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Customer Code'
      Custcode,
      @EndUserText.label: 'Customer Name'
      Custname,
      @EndUserText.label: 'Selling Expense Code'
      Expcode,
      @EndUserText.label: 'Selling Expense Name'
      Expname,
      /* Associations */
      _Item : redirected to composition child ZC_CUSTSLEXPITM
}
