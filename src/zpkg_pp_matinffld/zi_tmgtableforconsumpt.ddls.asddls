@EndUserText.label: 'TMG table for Consumption Base'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForConsumpt
  as select from ZDT_CONBASE_TMG
  association to parent ZI_TmgTableForConsumpt_S as _TmgTableForConsuAll on $projection.SingletonID = _TmgTableForConsuAll.SingletonID
{
  key CONBASE as Conbase,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForConsuAll
  
}
