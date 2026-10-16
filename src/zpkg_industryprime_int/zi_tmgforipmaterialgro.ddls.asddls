@EndUserText.label: 'TMG for IP Material Group'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_TmgForIpMaterialGro
  as select from ZDT_IP_MATGRPTMG
  association to parent ZI_TmgForIpMaterialGro_S as _TmgForIpMaterialAll on $projection.SingletonID = _TmgForIpMaterialAll.SingletonID
{
  key MATKL as Matkl,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgForIpMaterialAll
  
}
