@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View for Authorization'
define root view entity ZR_appauthotp
  as select from zex_app_autho
{
  key internal_auth         as InternalAuth,
      app_name              as AppName,
      user_id               as UserId,
      auth_type             as AuthType,
      created_at            as CreatedAt,
      created_by            as CreatedBy,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
