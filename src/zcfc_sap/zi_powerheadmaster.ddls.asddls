@EndUserText.label: 'Power Head Master'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_PowerHeadMaster
  as select from zdt_powerhead
  association to parent ZI_PowerHeadMaster_S as _PowerHeadMasterAll on $projection.SingletonID = _PowerHeadMasterAll.SingletonID
{
  key subheadcd as Subheadcd,
  subheadnm as Subheadnm,
  headcd as Headcd,
  headnm as Headnm,
  metertyp as Metertyp,
  ciprcnt as Ciprcnt,
  diprcnt as Diprcnt,
  msprcnt as Msprcnt,
  vacprcnt as Vacprcnt,
  othrprcnt as Othrprcnt,
  meterread as Meterread,
  @Consumption.hidden: true
  1 as SingletonID,
  _PowerHeadMasterAll
  
}
