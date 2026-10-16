@EndUserText.label: 'DPR CI MAT GRP'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_DprCiMatGrp
  as select from ZDT_MG_DPR_CI
  association to parent ZI_DprCiMatGrp_S as _DprCiMatGrpAll on $projection.SingletonID = _DprCiMatGrpAll.SingletonID
{
  key COSTTYPE as Costtype,
  key MATKL as Matkl,
  @Consumption.hidden: true
  1 as SingletonID,
  _DprCiMatGrpAll
}
