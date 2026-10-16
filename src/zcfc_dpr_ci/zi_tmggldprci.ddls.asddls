@EndUserText.label: 'TMG GL DPR CI'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgGlDprCi
  as select from ZDT_GL_DPR_CI
  association to parent ZI_TmgGlDprCi_S as _TmgGlDprCiAll on $projection.SingletonID = _TmgGlDprCiAll.SingletonID
{
  key COSTTYPE as Costtype,
  key HKONT as Hkont,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgGlDprCiAll
}
