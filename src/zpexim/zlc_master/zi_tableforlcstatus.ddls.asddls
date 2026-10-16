@EndUserText.label: 'Table for LC Status'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_TableForLcStatus
  as select from zdt_lcstatusf4
  association to parent ZI_TableForLcStatus_S as _TableForLcStatus on $projection.SingletonID = _TableForLcStatus.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key doc_status as DocStatus,
  status_text as StatusText,
  @ObjectModel.text.association: '_ConfignDeprecationCodeText'
  configdeprecationcode as ConfigDeprecationCode,
  @Consumption.hidden: true
  1 as SingletonID,
  _TableForLcStatus,
  case when configdeprecationcode = 'W' then 2 when configdeprecationcode = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
