@EndUserText.label: 'TMG Table for Work Code'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForWorkCode
  as select from ZDT_WORKCODE
  association to parent ZI_TmgTableForWorkCode_S as _TmgTableForWorkCAll on $projection.SingletonID = _TmgTableForWorkCAll.SingletonID
{
  key WORKCODE as Workcode,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForWorkCAll
}
