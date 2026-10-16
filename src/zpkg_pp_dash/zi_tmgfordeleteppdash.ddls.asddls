@EndUserText.label: 'Tmg for Delete PP Dash'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgForDeletePpDash
  as select from ZDT_PP_DELUSR
  association to parent ZI_TmgForDeletePpDash_S as _TmgForDeletePpDaAll on $projection.SingletonID = _TmgForDeletePpDaAll.SingletonID
{
  key USERID as Userid,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgForDeletePpDaAll
  
}
