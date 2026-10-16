@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for Resource Master'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z_C_RESOURCE_MASTER provider contract transactional_query as projection on Z_I_Resource_Master
{
  key Requestuuid,
 Resource_code,
      Resource_name,
      Plant,
      No_of_resource,
      available_hours_per_day,
      Capacity_hrs_in_kg,
      Set_up_time,
      Lead_time,
      No_of_shift,
      Extra1,
      Extra2,
@Semantics.systemDateTime.createdAt: true
      Created_at,
@Semantics.user.createdBy: true      
      Created_by,
@Semantics.systemDateTime.localInstanceLastChangedAt: true      
      Last_changed_at,
@Semantics.user.lastChangedBy: true      
      Last_changed_by,
  
      
  @UI.lineItem: [{ position: 80,criticality: 'statuscriticallity', criticalityRepresentation: #WITH_ICON }]
  @UI.identification: [{ position: 160 }]
  @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_STAT'
  @EndUserText.label: 'Status'
  virtual UpdateStatus : abap.char( 10 ),
  
  @UI.hidden: true
  @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_STAT'
  virtual statuscriticallity : abap.int4
  
}
