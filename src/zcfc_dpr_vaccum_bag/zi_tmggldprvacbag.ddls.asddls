@EndUserText.label: 'TMG GL DPR VAC BAG'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgGlDprVacBag
  as select from ZDT_GL_DPR_VACB
  association to parent ZI_TmgGlDprVacBag_S as _TmgGlDprVacBagAll on $projection.SingletonID = _TmgGlDprVacBagAll.SingletonID
{
  key COSTTYPE as Costtype,
  key HKONT as Hkont,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgGlDprVacBagAll
}
