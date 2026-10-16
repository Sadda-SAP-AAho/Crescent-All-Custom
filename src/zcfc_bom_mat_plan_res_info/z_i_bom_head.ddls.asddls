@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOM-Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_I_BOM_HEAD
  provider contract transactional_query
  as projection on I_BillOfMaterialTP_2 as bomhead

{
  key BillOfMaterial,
  key BillOfMaterialCategory,
  key BillOfMaterialVariant,
  key BillOfMaterialVersion,
  key EngineeringChangeDocument,
  key Material,
  key Plant,
      BillOfMaterialHeaderUUID,
      BillOfMaterialVariantUsage,
      EngineeringChangeDocForEdit,
      IsMultipleBOMAlt,
      BOMHeaderInternalChangeCount,
      BOMUsagePriority,
      BillOfMaterialAuthsnGrp,
      BOMVersionStatus,
      IsVersionBillOfMaterial,
      IsLatestBOMVersion,
      IsConfiguredMaterial,
      BOMTechnicalType,
      BOMGroup,
      BOMHeaderText,
      BOMAlternativeText,
      BillOfMaterialStatus,
      HeaderValidityStartDate,
      HeaderValidityEndDate,
      ChgToEngineeringChgDocument,
      IsMarkedForDeletion,
      IsALE,
      BOMHeaderBaseUnit,
      RecordCreationDate,
      LastChangeDate,
      CreatedByUser,
      LastChangedByUser,
      BOMIsToBeDeleted,
      DocumentIsCreatedByCAD,
      LaboratoryOrDesignOffice,
      LastChangeDateTime,
      ProductDescription,
      PlantName,
      BillOfMaterialHdrDetailsText,
      SelectedBillOfMaterialVersion

}
