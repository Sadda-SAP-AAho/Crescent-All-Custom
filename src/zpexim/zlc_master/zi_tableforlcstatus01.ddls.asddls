@EndUserText.label: 'Table for LC Status'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_TableForLcStatus01
  as select from ZDT_LCSTATUSF4
  association to parent ZI_TableForLcStatus_S01 as _TableForLcStatus01 on $projection.SingletonID = _TableForLcStatus01.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key DOC_STATUS as DocStatus,
  STATUS_TEXT as StatusText,
  @ObjectModel.text.association: '_ConfignDeprecationCodeText'
  CONFIGDEPRECATIONCODE as ConfigDeprecationCode,
  @Consumption.hidden: true
  1 as SingletonID,
  _TableForLcStatus01,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
