@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Document Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_MATDOCITEM 
  provider contract transactional_query
  as projection on I_MaterialDocumentItemTP as matdoc
{
  key MaterialDocumentYear,
  key MaterialDocument,
  key MaterialDocumentItem,


      MaterialDocumentLine,
      MaterialDocumentParentLine,

      GoodsMovementType,
      YY1_ChallanNumber_MMI,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      YY1_NetWeight_MMI
}
