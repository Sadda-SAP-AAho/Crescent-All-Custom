@EndUserText.label: 'SHIPMENT TYPE'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_ShipmentType
  as select from ZDT_SHIPMENTTYPE
  association to parent ZI_ShipmentType_S as _ShipmentTypeAll on $projection.SingletonID = _ShipmentTypeAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key SHIPMENTTYPE as Shipmenttype,
  @ObjectModel.text.association: '_ConfignDeprecationCodeText'
  CONFIGDEPRECATIONCODE as ConfigDeprecationCode,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _ShipmentTypeAll,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
