@EndUserText.label: 'Database table for bank TMG'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_DatabaseTableForBan
  as select from ZDT_FOREX_BNKTMG
  association to parent ZI_DatabaseTableForBan_S as _DatabaseTableForAll on $projection.SingletonID = _DatabaseTableForAll.SingletonID
{
  key BANKNAME as Bankname,
  @Consumption.hidden: true
  1 as SingletonID,
  _DatabaseTableForAll
  
}
