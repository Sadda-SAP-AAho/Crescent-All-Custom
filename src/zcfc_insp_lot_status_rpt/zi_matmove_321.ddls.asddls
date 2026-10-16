@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Movement-321'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_MATMOVE_321
  as select distinct from I_InspLotMatlDocItem        as a

    inner join            I_MaterialDocumentItem_2    as b on  a.MaterialDocumentYear   = b.MaterialDocumentYear
                                                           and a.MaterialDocument       = b.MaterialDocument
                                                           and a.MaterialDocumentItem   = b.MaterialDocumentItem
                                                           and b.GoodsMovementType      = '321'
                                                           and b.IsAutomaticallyCreated is initial

    inner join            I_SerialNumberMaterialDoc_2 as c on  a.MaterialDocument     = c.MaterialDocument
                                                           and a.MaterialDocument     = c.MaterialDocument
                                                           and a.MaterialDocumentItem = c.MaterialDocumentItem
                                                           and b.Material             = c.Material
{
  key a.InspectionLot,
  key b.Material,
  key b.Plant,
      c.SerialNumber
}
