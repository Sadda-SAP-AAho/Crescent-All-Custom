@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_PRODUCTGROUPMAP
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_PRODUCTGROUPMAP
{
  key Productgroup,
  Producttype,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
  LastChangedAt
  
}
