@EndUserText.label: 'Organization Mail id base of Vendor Grp'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_OrganizationMailIdB
  as select from ZDT_ORGEMAIL
  association to parent ZI_OrganizationMailIdB_S as _OrganizationMailAll on $projection.SingletonID = _OrganizationMailAll.SingletonID
{
  key KTOKK as Ktokk,
  key EMAIL as Email,
  @Consumption.hidden: true
  1 as SingletonID,
  _OrganizationMailAll
  
}
