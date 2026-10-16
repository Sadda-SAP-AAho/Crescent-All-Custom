@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Resource Master'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z_I_Resource_Master
  as select from zrsrc_mastr_head

{
  key requestuuid as Requestuuid,
 resource_code as Resource_code ,
      resource_name as Resource_name,
      plant as Plant,
      no_of_resource as No_of_resource,
      available_hours_per_day,
      capacity_hrs_in_kg as Capacity_hrs_in_kg,
      set_up_time as Set_up_time,
      lead_time as Lead_time,
      no_of_shift as No_of_shift,
      extra1 as Extra1,
      extra2 as Extra2,
    @Semantics.systemDateTime.createdAt: true
  created_at     as Created_at,
 @Semantics.user.createdBy: true
  created_by    as Created_by,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at    as Last_changed_at,
  @Semantics.user.localInstanceLastChangedBy: true
  last_changed_by    as Last_changed_by

}
