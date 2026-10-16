@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for house business place'
define view entity ZR_BUSINESS 
as select distinct from I_BusinessPlaceVH
{
  key CompanyCode,
  key BusinessPlace,
  key BusinessPlaceDescription
}
where CompanyCode = '1000'
