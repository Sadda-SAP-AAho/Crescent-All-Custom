@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COGS Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVCOGSRPT_8

  as select from I_MaterialDocumentItem_2

{

  key MaterialDocument,
  key cast( ltrim( MaterialDocumentItem, '0' ) as abap.char( 6 ) ) as MaterialDocumentItem,
  key MaterialDocumentYear,
      DeliveryDocument,
      DeliveryDocumentItem,
      PostingDate,
      Material,
      Plant,
      GoodsMovementType,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      QuantityInBaseUnit

}
