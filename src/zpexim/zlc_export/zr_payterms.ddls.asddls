@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Terms '
define view entity ZR_PAYTERMS 
       as select distinct from I_CustomerPaymentTermsText
{
  key CustomerPaymentTerms,
  CustomerPaymentTermsName
}
where Language = 'E'
