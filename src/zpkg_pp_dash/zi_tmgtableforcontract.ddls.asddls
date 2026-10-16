@EndUserText.label: 'TMG table for Contractor'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForContract
  as select from ZDT_CONTRACT_TMG
  association to parent ZI_TmgTableForContract_S as _TmgTableForContrAll on $projection.SingletonID = _TmgTableForContrAll.SingletonID
{
  key ZCON as Zcon,
  ZCOD as Zcod,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForContrAll
  
}
