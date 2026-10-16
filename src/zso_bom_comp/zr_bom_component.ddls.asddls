@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Component'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_BOM_COMPONENT as select from I_MaterialBOMLink as _MATERIALBOMLINK
inner join I_BillOfMaterialItemBasic as _BILLOFMATERIALITEMBASIC on _MATERIALBOMLINK.BillOfMaterial = _BILLOFMATERIALITEMBASIC.BillOfMaterial
{
    key _MATERIALBOMLINK.BillOfMaterial,
    key _MATERIALBOMLINK.BillOfMaterialVariant,
    key _MATERIALBOMLINK.Material,
    key _MATERIALBOMLINK.Plant
    
    
}
