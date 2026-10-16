@EndUserText.label: 'DPR DI MAT GRP'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_DprDiMatGrp
  as select from ZDT_MG_DPR_DI
  association to parent ZI_DprDiMatGrp_S as _DprDiMatGrpAll on $projection.SingletonID = _DprDiMatGrpAll.SingletonID
{
  key COSTTYPE as Costtype,
  key MATKL as Matkl,
  @Consumption.hidden: true
  1 as SingletonID,
  _DprDiMatGrpAll
  
}
