@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material BOM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_MATERIALBOMLINKDEX as select from I_MaterialBOMLinkDEX
{
    key BillOfMaterial,
    key BillOfMaterialVariant,
    key Material,
    key Plant,
    key BillOfMaterialVariantUsage,
    BillOfMaterialCategory,
    BOMHeaderBaseUnit,
     @Semantics.quantity.unitOfMeasure: 'BOMHeaderBaseUnit'
    MatFromLotSizeQuantity,
     @Semantics.quantity.unitOfMeasure: 'BOMHeaderBaseUnit'
    MaterialToLotSizeQuantity,
    IsConfiguredMaterial,
    MaterialBOMObjectID,
    CreatedByUser,
    LastChangedByUser,
    LastChangeDate,
    /* Associations */
    _BillOfMaterialUsage
}
