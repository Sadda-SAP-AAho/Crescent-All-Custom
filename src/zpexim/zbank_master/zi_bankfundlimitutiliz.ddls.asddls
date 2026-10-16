@EndUserText.label: 'Bank Fund Limit Utilization of TMG'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_BankFundLimitUtiliz
  as select from ZDT_FUNDGL_BNK
  association to parent ZI_BankFundLimitUtiliz_S as _BankFundLimitUtiAll on $projection.SingletonID = _BankFundLimitUtiAll.SingletonID
{
  key HBKID as Hbkid,
  key HKTID as Hktid,
  key LOANTYPE as Loantype,
  key GLACCOUNT as Glaccount,
  @Consumption.hidden: true
  1 as SingletonID,
  _BankFundLimitUtiAll
}
