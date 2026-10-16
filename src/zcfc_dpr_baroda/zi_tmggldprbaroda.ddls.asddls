@EndUserText.label: 'TMG GL DPR BARODA'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgGlDprBaroda
  as select from ZDT_GL_DPR_BARD
  association to parent ZI_TmgGlDprBaroda_S as _TmgGlDprBarodaAll on $projection.SingletonID = _TmgGlDprBarodaAll.SingletonID
{
  key COSTTYPE as Costtype,
  key HKONT as Hkont,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgGlDprBarodaAll
}
