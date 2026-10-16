@EndUserText.label: 'TMG table for Type of Moulding type'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForTypeOfMo
  as select from ZDT_MOLDTYP_TMG
  association to parent ZI_TmgTableForTypeOfMo_S as _TmgTableForTypeOAll on $projection.SingletonID = _TmgTableForTypeOAll.SingletonID
{
  key MCODE as Mcode,
  MNANE as Mnane,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForTypeOAll
  
}
