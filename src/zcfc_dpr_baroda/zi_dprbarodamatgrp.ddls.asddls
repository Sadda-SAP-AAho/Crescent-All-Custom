@EndUserText.label: 'DPR BARODA MAT GRP'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_DprBarodaMatGrp
  as select from ZDT_MG_DPR_BARD
  association to parent ZI_DprBarodaMatGrp_S as _DprBarodaMatGrpAll on $projection.SingletonID = _DprBarodaMatGrpAll.SingletonID
{
  key COSTTYPE as Costtype,
  key MATKL as Matkl,
  @Consumption.hidden: true
  1 as SingletonID,
  _DprBarodaMatGrpAll
}
