@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_BOM_DETAILS
  provider contract transactional_query
  as projection on I_BillOfMaterialItemTP_3 as bomdetails
{
  key BillOfMaterial,
  key BillOfMaterialCategory,
  key BillOfMaterialVariant        as BillOfMaterialVariant,
  key BillOfMaterialVersion,
  key BillOfMaterialItemNodeNumber as BillOfMaterialItemNodeNumber,
  key HeaderChangeDocument,
  key Material                     as Material,
  key Plant                        as Plant,
      BillOfMaterialItemNumber,
      BillOfMaterialComponent,
      ComponentDescription,
      BillOfMaterialItemCategory,
      BillOfMaterialItemUnit,
      @Semantics.quantity.unitOfMeasure: 'BillOfMaterialItemUnit'
      BillOfMaterialItemQuantity
}
