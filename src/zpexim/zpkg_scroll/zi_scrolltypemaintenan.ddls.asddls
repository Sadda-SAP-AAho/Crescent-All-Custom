@EndUserText.label: 'Scroll Type Maintenance'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_ScrollTypeMaintenan
  as select from ZDT_SCROTYPE_TMG
  association to parent ZI_ScrollTypeMaintenan_S as _ScrollTypeMainteAll on $projection.SingletonID = _ScrollTypeMainteAll.SingletonID
{
  key TYPE as Type,
  DESCRIPTION as Description,
  GLACCOUNT as Glaccount,
  @Consumption.hidden: true
  1 as SingletonID,
  _ScrollTypeMainteAll
  
}
