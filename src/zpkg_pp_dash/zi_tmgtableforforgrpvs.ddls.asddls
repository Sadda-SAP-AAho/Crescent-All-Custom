@EndUserText.label: 'TMG table for for Grp vs Operation'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForForGrpVs
  as select from ZDT_CC_PC_COMB
  association to parent ZI_TmgTableForForGrpVs_S as _TmgTableForForGrAll on $projection.SingletonID = _TmgTableForForGrAll.SingletonID
{
  key COMPCODE as Compcode,
  key CCCODE as Cccode,
  key CCNAME as Ccname,
  key PCCODE as Pccode,
  key PCNAME as Pcname,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForForGrAll
}
