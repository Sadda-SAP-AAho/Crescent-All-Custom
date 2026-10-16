@EndUserText.label: 'TMG DPR DI Cost Center'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgDprDiCostCenter
  as select from ZDT_DPR_DI_CC
  association to parent ZI_TmgDprDiCostCenter_S as _TmgDprDiCostCentAll on $projection.SingletonID = _TmgDprDiCostCentAll.SingletonID
{
  key COSTTYPE as Costtype,
  key KOSTL as Kostl,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgDprDiCostCentAll
  
}
