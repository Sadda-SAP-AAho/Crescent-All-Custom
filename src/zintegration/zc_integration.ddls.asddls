@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_INTEGRATION
  provider contract transactional_query
  as projection on ZR_INTEGRATION
{
  key Intgmodule,
  Intgpath,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt
}
