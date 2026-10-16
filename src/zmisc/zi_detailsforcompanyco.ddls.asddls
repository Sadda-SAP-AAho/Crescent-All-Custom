@EndUserText.label: 'Details For Company Code & Plant'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_DetailsForCompanyCo
  as select from ZDT_MM_PC_TMG
  association to parent ZI_DetailsForCompanyCo_S as _DetailsForCompanAll on $projection.SingletonID = _DetailsForCompanAll.SingletonID
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
  _DetailsForCompanAll,
  case when CONFIGDEPRECATIONCODE = 'W' then 2 when CONFIGDEPRECATIONCODE = 'E' then 1 else 3 end as ConfigDeprecationCode_Critlty,
  _ConfignDeprecationCodeText
  
}
