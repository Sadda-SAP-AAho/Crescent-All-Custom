@EndUserText.label: 'TMG - Fixed Cost Calculation Details'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgFixedCostCalcula
  as select from ZDT_FXDCSTCAL
  association to parent ZI_TmgFixedCostCalcula_S as _TmgFixedCostCalcAll on $projection.SingletonID = _TmgFixedCostCalcAll.SingletonID
{
  key MOULD as Mould,
  FXDCSTRATE as Fxdcstrate,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgFixedCostCalcAll
}
