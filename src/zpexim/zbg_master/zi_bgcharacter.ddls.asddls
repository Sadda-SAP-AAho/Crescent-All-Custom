@EndUserText.label: 'bg character'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_BgCharacter
  as select from ZBG_CHARACTER
  association to parent ZI_BgCharacter_S as _BgCharacterAll on $projection.SingletonID = _BgCharacterAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key BGCHARACTER as Bgcharacter,
  @ObjectModel.text.association: '_ConfignDeprecationCodeText'
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_ConfignDeprecationCode', 
      element: 'ConfigurationDeprecationCode'
    }
  } ]
  CONFIGDEPRECATIONCODE as ConfigDeprecationCode,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _BgCharacterAll,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
