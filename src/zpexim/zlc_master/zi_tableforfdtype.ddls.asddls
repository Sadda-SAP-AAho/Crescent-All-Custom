@EndUserText.label: 'Table for FD Type'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_TableForFdType
  as select from zdt_fd_type
  association to parent ZI_TableForFdType_S as _TableForFdTypeAll on $projection.SingletonID = _TableForFdTypeAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key fd_type as FdType,
  fd_desc as FdDesc,
  @ObjectModel.text.association: '_ConfignDeprecationCodeText'
  configdeprecationcode as ConfigDeprecationCode,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  local_last_changed_at as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _TableForFdTypeAll,
  case when configdeprecationcode = 'W' then 2 when configdeprecationcode = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
