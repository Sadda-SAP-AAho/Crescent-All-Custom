@EndUserText.label: 'TMG DPR BARODA COST CENTER'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgDprBarodaCostCen
  as select from ZDT_DPR_BARD_CC
  association to parent ZI_TmgDprBarodaCostCen_S as _TmgDprBarodaCostAll on $projection.SingletonID = _TmgDprBarodaCostAll.SingletonID
{
  key COSTTYPE as Costtype,
  key KOSTL as Kostl,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgDprBarodaCostAll
}
