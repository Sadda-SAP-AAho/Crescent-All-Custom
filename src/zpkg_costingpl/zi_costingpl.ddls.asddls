@EndUserText.label: 'Costing PL'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_CostingPl
  as select from ZDT_COSTINGPL_PC
  association to parent ZI_CostingPl_S as _CostingPlAll on $projection.SingletonID = _CostingPlAll.SingletonID
{
  key PRCTR as Prctr,
  key PRCTRCLUB as Prctrclub,
  @Consumption.hidden: true
  1 as SingletonID,
  _CostingPlAll
  
}
