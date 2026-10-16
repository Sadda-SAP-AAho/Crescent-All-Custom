@EndUserText.label: 'TMG DPR VAC BAG COST CENTER'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgDprVacBagCostCen
  as select from ZDT_DPR_VACB_CC
  association to parent ZI_TmgDprVacBagCostCen_S as _TmgDprVacBagCostAll on $projection.SingletonID = _TmgDprVacBagCostAll.SingletonID
{
  key COSTTYPE as Costtype,
  key KOSTL as Kostl,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgDprVacBagCostAll
}
