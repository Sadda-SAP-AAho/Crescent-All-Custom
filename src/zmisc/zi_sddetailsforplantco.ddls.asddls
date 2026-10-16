@EndUserText.label: 'SD details For Plant & Company'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_SdDetailsForPlantCo
  as select from ZDT_SD_PC_TMG
  association to parent ZI_SdDetailsForPlantCo_S as _SdDetailsForPlanAll on $projection.SingletonID = _SdDetailsForPlanAll.SingletonID
  association [0..*] to I_ConfignDeprecationCodeText as _ConfignDeprecationCodeText on $projection.ConfigDeprecationCode = _ConfignDeprecationCodeText.ConfigurationDeprecationCode
{
  key COCODE as Cocode,
  key PLANT as Plant,
  NAME as Name,
  TIN as Tin,
  CINNO as Cinno,
  PANNO as Panno,
  GSTIN as Gstin,
  IEC as Iec,
  PLANTADDR1 as Plantaddr1,
  PLANTADDR2 as Plantaddr2,
  PLANTADDR3 as Plantaddr3,
  CEMAIL as Cemail,
  CMOBILE as Cmobile,
  PLANTNAME as Plantname,
  CADDRESS1 as Caddress1,
  CADDRESS2 as Caddress2,
  CADDRESS3 as Caddress3,
  TELNUMBER1 as Telnumber1,
  TELNUMBER2 as Telnumber2,
  TEL_NUMBER3 as TelNumber3,
  VAR6 as Var6,
  VAR1 as Var1,
  VAR2 as Var2,
  VAR3 as Var3,
  VAR4 as Var4,
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
  _SdDetailsForPlanAll,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
