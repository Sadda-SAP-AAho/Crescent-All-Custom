@EndUserText.label: 'TMG table for Rejection Reason'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForRejectio
  as select from ZDT_REJREA_TMG
  association to parent ZI_TmgTableForRejectio_S as _TmgTableForRejecAll on $projection.SingletonID = _TmgTableForRejecAll.SingletonID
{
  key ZREJ1 as Zrej1,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForRejecAll
  
}
