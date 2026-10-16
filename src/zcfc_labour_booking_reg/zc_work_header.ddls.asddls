@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_WORK_HEADER
  provider contract transactional_query
  as projection on ZR_WORK_HEADER
{
  key PlantCode,
  key WorkCode,
  PlantName,
  WorkName,
  BeginDate,
  EndDate,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  Localcreatedby,
  Locallastchangedby,
  Localcreatedat,
  Locallastchangedat,
  Lastchangeat,
  _plant,
  _items : redirected to composition child ZC_WORK_ITEMS
  
}
