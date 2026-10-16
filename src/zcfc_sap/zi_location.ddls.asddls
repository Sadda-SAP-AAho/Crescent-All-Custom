@EndUserText.label: 'Location'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_Location
  as select from ZDT_LOCATION
  association to parent ZI_Location_S as _LocationAll on $projection.SingletonID = _LocationAll.SingletonID
{
  key LOCTNCD as Loctncd,
  LOCTNNAM as Loctnnam,
  @Consumption.hidden: true
  1 as SingletonID,
  _LocationAll
  
}
