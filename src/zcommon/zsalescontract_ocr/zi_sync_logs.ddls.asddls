@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view entity'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SYNC_LOGS 
as select from zsync_logs
{
 key uuid as Uuid,
 ref_object_type as RefObjectType,
 ref_object_key as RefObjectKey,
 errorlog as Errorlog,
 sync_timestamp as SyncTimestamp,
 created_by as CreatedBy,
 created_at as CreatedAt,
 last_changed_by as LastChangedBy,
 last_changed_at as LastChangedAt,
 local_last_changed_at as LocalLastChangedAt
}
