@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_WORK_HEADER
  as select from zwork_header
association to ZVH_PLANT as _plant on $projection.PlantCode = _plant.PLANT_CODE
composition [0..*] of ZR_WORK_ITEMS as _items  
{
  key plant_code as PlantCode,
  key work_code as WorkCode,
  plant_name as PlantName,
  work_name as WorkName,
  begin_date as BeginDate,
  end_date as EndDate,
  created_by as CreatedBy,
  created_at as CreatedAt,
  last_changed_by as LastChangedBy,
  last_changed_at as LastChangedAt,
  @Semantics.user.createdBy: true
  localcreatedby as Localcreatedby,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locallastchangedby as Locallastchangedby,
  @Semantics.user.createdBy: true
  localcreatedat as Localcreatedat,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locallastchangedat as Locallastchangedat,
  @Semantics.systemDateTime.lastChangedAt: true
  lastchangeat as Lastchangeat,
  _plant,
  _items
  
}
