@EndUserText.label: 'TMG table for Operation'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForOperatio
  as select from ZDT_OPR_TMG
  association to parent ZI_TmgTableForOperatio_S as _TmgTableForOperaAll on $projection.SingletonID = _TmgTableForOperaAll.SingletonID
{
  key ZOPN as Zopn,
  ZOPD as Zopd,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForOperaAll
  
}
