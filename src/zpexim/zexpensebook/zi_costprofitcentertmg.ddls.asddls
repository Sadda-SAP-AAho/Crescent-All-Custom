@EndUserText.label: 'Cost & Profit Center TMG'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_CostProfitCenterTmg
  as select from ZDT_EXP_COSTC
  association to parent ZI_CostProfitCenterTmg_S as _CostProfitCenterAll on $projection.SingletonID = _CostProfitCenterAll.SingletonID
{
  key PROFITCENTER as Profitcenter,
  key COSTCENTER as Costcenter,
  @Consumption.hidden: true
  1 as SingletonID,
  _CostProfitCenterAll
  
}
