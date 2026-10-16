@EndUserText.label: 'Table for LC Type'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_TableForLcType
  as select from zdt_lctypef4
  association to parent ZI_TableForLcType_S as _TableForLcTypeAll on $projection.SingletonID = _TableForLcTypeAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key type as Type,
  type_desc as TypeDesc,
  @ObjectModel.text.association: '_ConfignDeprecationCodeText'
  configdeprecationcode as ConfigDeprecationCode,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  local_last_changed_at as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _TableForLcTypeAll,
  case when configdeprecationcode = 'W' then 2 when configdeprecationcode = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
