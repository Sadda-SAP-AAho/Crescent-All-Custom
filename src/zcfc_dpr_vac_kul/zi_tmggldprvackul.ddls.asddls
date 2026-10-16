@EndUserText.label: 'TMG GL DPR VAC KUL'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgGlDprVacKul
  as select from ZDT_GL_DPR_VCKL
  association to parent ZI_TmgGlDprVacKul_S as _TmgGlDprVacKulAll on $projection.SingletonID = _TmgGlDprVacKulAll.SingletonID
{
  key COSTTYPE as Costtype,
  key HKONT as Hkont,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgGlDprVacKulAll
}
