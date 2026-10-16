@EndUserText.label: 'Maintain UserID for Edit & Delete'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_MaintainUseridForEd
  as select from ZDT_USERID
  association to parent ZI_MaintainUseridForEd_S as _MaintainUseridFoAll on $projection.SingletonID = _MaintainUseridFoAll.SingletonID
{
  key USERID as Userid,
  EDIT as Edit,
  DELETEABLE as Deleteable,
  @Consumption.hidden: true
  1 as SingletonID,
  _MaintainUseridFoAll
  
}
