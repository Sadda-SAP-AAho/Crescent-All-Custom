@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reverse Material Document Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_REV_MATL_DOC
  as select distinct from I_MaterialDocumentHeader_2 as a
    inner join            I_MaterialDocumentItem_2   as b on  a.MaterialDocument     = b.MaterialDocument
                                                          and a.MaterialDocumentYear = b.MaterialDocumentYear
{
  key b.ReversedMaterialDocumentYear  as MaterialDocumentYear,
  key b.ReversedMaterialDocument      as MaterialDocument,
  key b.ReversedMaterialDocumentItem  as MaterialDocumentItem,
  key a.PostingDate,
  key b.DeliveryDocument,
  key b.DeliveryDocumentItem,
  key b.Material,
      b.MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      ( b.QuantityInBaseUnit * (-1) ) as QuantityInBaseUnit

}

where
  b.GoodsMovementType = '602'
