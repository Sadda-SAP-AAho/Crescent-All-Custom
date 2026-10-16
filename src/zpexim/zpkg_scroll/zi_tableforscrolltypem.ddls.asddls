@EndUserText.label: 'Table for Scroll Type Maintenance'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TableForScrollTypeM
  as select from ZDT_SCTYPE_TMG
  association to parent ZI_TableForScrollTypeM_S as _TableForScrollTyAll on $projection.SingletonID = _TableForScrollTyAll.SingletonID
{
  key TYPE as Type,
  DESCRIPTION as Description,
  GLACCOUNT as Glaccount,
  @Consumption.hidden: true
  1 as SingletonID,
  _TableForScrollTyAll
  
}
