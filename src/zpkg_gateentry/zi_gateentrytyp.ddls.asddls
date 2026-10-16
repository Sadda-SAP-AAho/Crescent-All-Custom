@EndUserText.label: 'GateEntry Typ'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_GateentryTyp
  as select from ZDT_GATEENTRYTYP
  association to parent ZI_GateentryTyp_S as _GateentryTypeAll on $projection.SingletonID = _GateentryTypeAll.SingletonID
{
  key GATEENTRYTYPE as Gateentrytype,
  @Consumption.hidden: true
  1 as SingletonID,
  _GateentryTypeAll
  
}
