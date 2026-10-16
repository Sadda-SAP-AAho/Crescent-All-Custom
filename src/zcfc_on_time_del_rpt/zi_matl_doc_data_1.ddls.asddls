@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Document Data-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MATL_DOC_DATA_1
  as select distinct from I_MaterialDocumentHeader_2 as a
    inner join            I_MaterialDocumentItem_2   as b on  a.MaterialDocument     = b.MaterialDocument
                                                          and a.MaterialDocumentYear = b.MaterialDocumentYear
{
  key a.MaterialDocumentYear,
  key a.MaterialDocument,
  key b.MaterialDocumentItem,
  key a.PostingDate,
  key b.DeliveryDocument,
  key b.DeliveryDocumentItem,
  key b.Material,
      b.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      b.QuantityInBaseUnit as QuantityInBaseUnit

}

where
      b.ReversedMaterialDocument is initial
  and b.GoodsMovementType        = '601'

union all

select distinct from ZI_REV_MATL_DOC

{

  key MaterialDocumentYear,
  key MaterialDocument,
  key MaterialDocumentItem,
  key PostingDate,
  key DeliveryDocument,
  key DeliveryDocumentItem,
  key Material,
      MaterialBaseUnit,
      QuantityInBaseUnit

}
