@EndUserText.label: 'GL Code Maintainence TMG'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_GlCodeMaintainenceT
  as select from ZDT_EXPEXPBOOK
  association to parent ZI_GlCodeMaintainenceT_S as _GlCodeMaintainenAll on $projection.SingletonID = _GlCodeMaintainenAll.SingletonID
{
  key EXPTYP as Exptyp,
  key DESCR as Descr,
  key PSC as Psc,
  key GLA as Gla,
  key GLC1 as Glc1,
  key GLC2 as Glc2,
  @Consumption.hidden: true
  1 as SingletonID,
  _GlCodeMaintainenAll
}
