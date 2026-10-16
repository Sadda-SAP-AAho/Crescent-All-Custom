@EndUserText.label: 'TMG table for Cost Center Vs Profit Cent'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForCCPC
  as select from ZDT_CC_PC_COMB
  association to parent ZI_TmgTableForCCVsPC_S as _TmgTableForCCPC_1 on $projection.SingletonID = _TmgTableForCCPC_1.SingletonID
{
  key COMPCODE as Compcode,
  key CCCODE as Cccode,
  key CCNAME as Ccname,
  key PCCODE as Pccode,
  key PCNAME as Pcname,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForCCPC_1
}
