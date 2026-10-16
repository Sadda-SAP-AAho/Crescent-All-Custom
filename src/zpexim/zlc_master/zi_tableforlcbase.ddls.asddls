@EndUserText.label: 'Table for LC Base'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_TableForLcBase
  as select from zdt_lcbasef4
  association to parent ZI_TableForLcBase_S as _TableForLcBaseAll on $projection.SingletonID = _TableForLcBaseAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key base as Base,
  base_desc as BaseDesc,
  @ObjectModel.text.association: '_ConfignDeprecationCodeText'
  configdeprecationcode as ConfigDeprecationCode,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  local_last_changed_at as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _TableForLcBaseAll,
  case when configdeprecationcode = 'W' then 2 when configdeprecationcode = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
