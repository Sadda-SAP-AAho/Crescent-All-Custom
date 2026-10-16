@EndUserText.label: 'TMG DPR CI Cost Center'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgDprCiCostCenter
  as select from ZDT_DPR_CI_CC
  association to parent ZI_TmgDprCiCostCenter_S as _TmgDprCiCostCentAll on $projection.SingletonID = _TmgDprCiCostCentAll.SingletonID
{
  key COSTTYPE as Costtype,
  key KOSTL as Kostl,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgDprCiCostCentAll
}
