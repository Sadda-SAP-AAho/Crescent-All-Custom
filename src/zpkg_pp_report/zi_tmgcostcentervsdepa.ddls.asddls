@EndUserText.label: 'TMG Cost Center Vs Department'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgCostCenterVsDepa
  as select from ZDT_CC_DEPT
  association to parent ZI_TmgCostCenterVsDepa_S as _TmgCostCenterVsDAll on $projection.SingletonID = _TmgCostCenterVsDAll.SingletonID
{
  key KOSTL as Kostl,
  DEPT as Dept,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgCostCenterVsDAll
  
}
