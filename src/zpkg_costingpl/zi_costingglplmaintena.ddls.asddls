@EndUserText.label: 'Costing GL PL Maintenance Table'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_CostingGlPlMaintena
  as select from ZDT_COST_GLPL
  association to parent ZI_CostingGlPlMaintena_S as _CostingGlPlMaintAll on $projection.SingletonID = _CostingGlPlMaintAll.SingletonID
{
  key GLTYPE as Gltype,
  key GL as Gl,
  @Consumption.hidden: true
  1 as SingletonID,
  _CostingGlPlMaintAll
  
}
