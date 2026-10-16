@EndUserText.label: 'Database table for Doc Type TMG'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_DatabaseTableForDoc
  as select from ZDT_DOCTYPE_TMG
  association to parent ZI_DatabaseTableForDoc_S as _DatabaseTableForAll on $projection.SingletonID = _DatabaseTableForAll.SingletonID
{
  key DOCTYPE as Doctype,
  @Consumption.hidden: true
  1 as SingletonID,
  _DatabaseTableForAll
  
}
