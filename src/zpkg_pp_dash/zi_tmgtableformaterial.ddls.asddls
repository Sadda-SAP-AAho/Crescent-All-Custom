@EndUserText.label: 'TMG table for Material Grp vs Operation'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZI_TmgTableForMaterial
  as select from ZDT_OPR_MGRP_TMG
  association to parent ZI_TmgTableForMaterial_S as _TmgTableForMaterAll on $projection.SingletonID = _TmgTableForMaterAll.SingletonID
{
  key ZOPN as Zopn,
  key MATKL as Matkl,
  @Consumption.hidden: true
  1 as SingletonID,
  _TmgTableForMaterAll
  
}
