@EndUserText.label: 'GL Account Maintenance'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_GlAccountMaintenanc
  as select from ZDT_GLACC_TMG
  association to parent ZI_GlAccountMaintenanc_S as _GlAccountMaintenAll on $projection.SingletonID = _GlAccountMaintenAll.SingletonID
{
  key GLACCOUNT as Glaccount,
  @Consumption.hidden: true
  1 as SingletonID,
  _GlAccountMaintenAll
  
}
