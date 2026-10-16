@EndUserText.label: 'DPR VAC KUL MAT GRP'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_DprVacKulMatGrp
  as select from ZDT_MG_DPR_VCKL
  association to parent ZI_DprVacKulMatGrp_S as _DprVacKulMatGrpAll on $projection.SingletonID = _DprVacKulMatGrpAll.SingletonID
{
  key COSTTYPE as Costtype,
  key MATKL as Matkl,
  @Consumption.hidden: true
  1 as SingletonID,
  _DprVacKulMatGrpAll
}
