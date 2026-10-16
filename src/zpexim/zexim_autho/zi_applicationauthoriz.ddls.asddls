@EndUserText.label: 'Application Authorization'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZI_ApplicationAuthoriz
  as select from zex_app_autho
  association to parent ZI_ApplicationAuthoriz_S as _ApplicationAuthoAll on $projection.SingletonID = _ApplicationAuthoAll.SingletonID
{
  key internal_auth         as InternalAuth,
      app_name              as AppName,
      user_id               as UserId,
      auth_type             as AuthType,
      created_at            as CreatedAt,
      created_by            as CreatedBy,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt,
      @Consumption.hidden: true
      1                     as SingletonID,
      _ApplicationAuthoAll

}
