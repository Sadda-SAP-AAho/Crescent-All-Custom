@EndUserText.label: 'TMG Price Val Exc User'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgPriceValExcUser
  as select from ZDT_EXP_PEC_USR
  association to parent ZI_TmgPriceValExcUser_S as _TmgPriceValExcUsAll on $projection.SingletonID = _TmgPriceValExcUsAll.SingletonID
{
  key USERID as Userid,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgPriceValExcUsAll
  
}
