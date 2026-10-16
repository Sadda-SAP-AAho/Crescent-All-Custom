@EndUserText.label: 'gate weighbridge table'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_GateWeighbridgeTabl
  as select from ZDT_GATETABLE
  association to parent ZI_GateWeighbridgeTabl_S as _GateWeighbridgeTAll on $projection.SingletonID = _GateWeighbridgeTAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key GATENO as Gateno,
  key WEIGHBRIDGE as Weighbridge,
  OBJECT as Object,
  @ObjectModel.text.association: '_ConfignDeprecationCodeText'
  CONFIGDEPRECATIONCODE as ConfigDeprecationCode,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _GateWeighbridgeTAll,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
