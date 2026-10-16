@EndUserText.label: 'DPR VAC KUL MAT GRP'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_DprVACKMatGrp
  as select from ZDT_MG_DPR_VACK
  association to parent ZI_DprVACKMatGrp_S as _DprVACKMatGrpAll on $projection.SingletonID = _DprVACKMatGrpAll.SingletonID
{
  key COSTTYPE as Costtype,
  key MATKL as Matkl,
  @Consumption.hidden: true
  1 as SingletonID,
  _DprVACKMatGrpAll
}
