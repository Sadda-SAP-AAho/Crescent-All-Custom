@EndUserText.label: 'TMG DPR VAC KUL Cost Center'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgDprVacKulCostCen
  as select from ZDT_DPR_VCKL_CC
  association to parent ZI_TmgDprVacKulCostCen_S as _TmgDprVacKulCostAll on $projection.SingletonID = _TmgDprVacKulCostAll.SingletonID
{
  key COSTTYPE as Costtype,
  key KOSTL as Kostl,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgDprVacKulCostAll
}
