@EndUserText.label: 'BG Address'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_BgAddress
  as select from ZDB_BGADDRESS
  association to parent ZI_BgAddress_S as _BgAddressAll on $projection.SingletonID = _BgAddressAll.SingletonID
{
  key BUKRS as Bukrs,
  STREET as Street,
  CITY as City,
  STATE as State,
  POSTCODE as Postcode,
  COUNTRY as Country,
  @Consumption.hidden: true
  1 as SingletonID,
  _BgAddressAll
  
}
