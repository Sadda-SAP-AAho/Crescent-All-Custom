@EndUserText.label: 'Table for PSA Indicator'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_TableForPsaIndicato
  as select from zdt_psa_indc
  association to parent ZI_TableForPsaIndicato_S as _TableForPsaIndicAll on $projection.SingletonID = _TableForPsaIndicAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key psa_indc as PsaIndc,
  psa_desc as PsaDesc,
  @ObjectModel.text.association: '_ConfignDeprecationCodeText'
  configdeprecationcode as ConfigDeprecationCode,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  local_last_changed_at as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _TableForPsaIndicAll,
  case when configdeprecationcode = 'W' then 2 when configdeprecationcode = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
