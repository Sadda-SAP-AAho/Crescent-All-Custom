@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GR Material Document Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_GR_MAT_DOC_DETAILS
  as select from    I_MaterialDocumentItem_2 as d
    left outer join I_InspLotMatlDocItem     as f on  d.MaterialDocument     = f.MaterialDocument
                                                  and d.MaterialDocumentYear = f.MaterialDocumentYear
                                                  and d.MaterialDocumentItem = f.MaterialDocumentItem
{
  key d.Material             as Product,
  key d.Plant,
  key d.MaterialDocument     as MatlDocNo,
  key d.MaterialDocumentYear as MatlDocYr,
  key d.MaterialDocumentItem as MatlDocItm,
  key f.InspectionLot,

      d.PostingDate          as MatlDocDate,
      d.GoodsMovementType,
      d.MaterialBaseUnit,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      d.QuantityInBaseUnit   as GRQty
}
where
       d.GoodsMovementType = '101'
  and(
       d.StorageLocation   = 'SASG'
    or d.StorageLocation   = 'KUSG'
    or d.StorageLocation   = 'BGSG'
    or d.StorageLocation   = 'BASG'
    or d.StorageLocation   = 'SAFG'
    or d.StorageLocation   = 'KUFG'
    or d.StorageLocation   = 'BGFG'
    or d.StorageLocation   = 'BAFG'
  )
