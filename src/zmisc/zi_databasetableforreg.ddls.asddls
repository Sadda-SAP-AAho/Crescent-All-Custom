@EndUserText.label: 'Database table for region'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_DatabaseTableForReg
  as select from ZDT_REGION_TMG
  association to parent ZI_DatabaseTableForReg_S as _DatabaseTableForAll on $projection.SingletonID = _DatabaseTableForAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key REGION as Region,
  key REGIONCODE as Regioncode,
  REGIONNAME as Regionname,
  COUNTRY as Country,
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
  _DatabaseTableForAll,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
