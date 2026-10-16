@EndUserText.label: 'TMG table for Mould Details'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForMouldDet
  as select from ZDT_MOULD
  association to parent ZI_TmgTableForMouldDet_S as _TmgTableForMouldAll on $projection.SingletonID = _TmgTableForMouldAll.SingletonID
{
  key MOULD as Mould,
  RATE1 as Rate1,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForMouldAll
  
}
