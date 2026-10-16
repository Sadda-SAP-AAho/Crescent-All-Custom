@EndUserText.label: 'TMG GL DPR DI'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgGlDprDi
  as select from ZDT_GL_DPR_DI
  association to parent ZI_TmgGlDprDi_S as _TmgGlDprDiAll on $projection.SingletonID = _TmgGlDprDiAll.SingletonID
{
  key COSTTYPE as Costtype,
  key HKONT as Hkont,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgGlDprDiAll
  
}
