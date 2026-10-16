@EndUserText.label: 'TMG table for Cost Center Type'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForCostCent
  as select from ZDT_CC_TYPE
  association to parent ZI_TmgTableForCostCent_S as _TmgTableForCostCAll on $projection.SingletonID = _TmgTableForCostCAll.SingletonID
{
  key KOSTL as Kostl,
  CCTYPE as Cctype,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForCostCAll
  
}
