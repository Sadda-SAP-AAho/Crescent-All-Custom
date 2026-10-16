@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Component'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_BOM_COMP
  provider contract transactional_query
  as projection on I_BillOfMaterialItemTP_2 as bomcomp
{
  key      bomcomp.BillOfMaterial,
  key      bomcomp.BillOfMaterialCategory,
  key      bomcomp.BillOfMaterialVariant,
  key      bomcomp.BillOfMaterialVersion,
  key      bomcomp.BillOfMaterialItemNodeNumber,
  key      bomcomp.HeaderChangeDocument,
  key      bomcomp.Material,
  key      bomcomp.Plant,
           bomcomp.BillOfMaterialComponent
}
