@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'CONSUMPTION FOR POWER READING HEADER'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_POWERRDNGH 
provider contract transactional_query
as projection on ZI_POWERRDNGH
{
  @EndUserText.label: 'ID'
  key Id,
  @EndUserText.label: 'Document No.'
  Docnum,
  @EndUserText.label: 'Reading Date'
  Readdate,
  @EndUserText.label: 'Location Code'
  Readloccd,
  @EndUserText.label: 'Location Name'
  Readlocnm,
  @EndUserText.label: 'Department'
  Readdept,
  @EndUserText.label: 'Unit Rate in Rs.'
  UnitRate,
  /* Associations */
  _Item : redirected to composition child ZC_POWERRDNGL
}
