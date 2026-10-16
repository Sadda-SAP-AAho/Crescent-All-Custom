@EndUserText.label: 'TMG DPR VAC KUL COST CENTER'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgDprVACKCostCen
  as select from ZDT_DPR_VACK_CC
  association to parent ZI_TmgDprVACKCostCen_S as _TmgDprVACKCostAll on $projection.SingletonID = _TmgDprVACKCostAll.SingletonID
{
  key COSTTYPE as Costtype,
  key KOSTL as Kostl,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgDprVACKCostAll
}
