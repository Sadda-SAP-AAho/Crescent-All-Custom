@EndUserText.label: 'DPR VAC BAG MAT GRP'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_DprVacBagMatGrp
  as select from ZDT_MG_DPR_VACB
  association to parent ZI_DprVacBagMatGrp_S as _DprVacBagMatGrpAll on $projection.SingletonID = _DprVacBagMatGrpAll.SingletonID
{
  key COSTTYPE as Costtype,
  key MATKL as Matkl,
  @Consumption.hidden: true
  1 as SingletonID,
  _DprVacBagMatGrpAll
}
