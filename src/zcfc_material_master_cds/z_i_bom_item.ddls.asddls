@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM ITEM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_I_BOM_ITEM
  provider contract transactional_query
  as projection on I_BillOfMaterialTP_2 as bomitem
{
  key    bomitem.BillOfMaterial            as BillOfMaterial,
  key    bomitem.BillOfMaterialCategory    as BillOfMaterialCategory,
  key    bomitem.BillOfMaterialVariant     as BillOfMaterialVariant,
  key    bomitem.BillOfMaterialVersion     as BillOfMaterialVersion,
  key    bomitem.EngineeringChangeDocument as EngineeringChangeDocument,
  key    bomitem.Material                  as Material,
  key    bomitem.Plant                     as Plant
}
