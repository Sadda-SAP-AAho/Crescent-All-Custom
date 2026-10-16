@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inspection Material Document Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_INSP_MAT_DOC_DETAILS
  as select distinct from I_MaterialDocumentItem_2 as d

    left outer join       I_InspLotMatlDocItem     as f on  d.MaterialDocument     = f.MaterialDocument
                                                        and d.MaterialDocumentYear = f.MaterialDocumentYear
                                                        and d.MaterialDocumentItem = f.MaterialDocumentItem

{
  key d.Material             as Product,
  key d.Plant,
  key d.MaterialDocument     as InspMatlDocNo,
  key d.MaterialDocumentYear as InspMatlDocYr,
  key d.MaterialDocumentItem as InsMatlDocItm,
  key f.InspectionLot,

      d.PostingDate          as InspMatlDocDate,
      d.GoodsMovementType,
      d.MaterialBaseUnit,

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      d.QuantityInBaseUnit   as InspQty
}
where
       d.GoodsMovementType = '321'
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
