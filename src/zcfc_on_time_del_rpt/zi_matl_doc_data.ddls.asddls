@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Document Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MATL_DOC_DATA
  as select distinct from ZI_MATL_DOC_DATA_1

{

  key MaterialDocumentYear,
  key MaterialDocument,
  key MaterialDocumentItem,
  key PostingDate,
  key DeliveryDocument,
  key DeliveryDocumentItem,
  key Material,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      QuantityInBaseUnit
}
