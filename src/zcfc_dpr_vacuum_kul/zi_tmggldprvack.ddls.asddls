@EndUserText.label: 'TMG GL DPR VAC KUL'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgGlDprVACK
  as select from ZDT_GL_DPR_VACK
  association to parent ZI_TmgGlDprVACK_S as _TmgGlDprVACKAll on $projection.SingletonID = _TmgGlDprVACKAll.SingletonID
{
  key COSTTYPE as Costtype,
  key HKONT as Hkont,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgGlDprVACKAll
}
