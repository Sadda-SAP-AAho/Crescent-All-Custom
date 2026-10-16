@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Tax Code'
define view entity ZCDS_TAXC 
as select distinct from ZR_TAXCODE
{
  key TaxCode,
  key TaxCodeName
}
