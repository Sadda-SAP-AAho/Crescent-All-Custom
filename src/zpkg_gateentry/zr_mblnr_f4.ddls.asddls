@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Doc Item Level F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zr_mblnr_f4
  as select from    I_MaterialDocumentItem_2 as a
    left outer join I_ProductText            as b on  b.Product  = a.Material
                                                  and b.Language = $session.system_language
{
  key a.MaterialDocument,
  key a.MaterialDocumentYear,
  key a.MaterialDocumentItem,
      a.Material,
      b.ProductName,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      a.QuantityInEntryUnit,
      a.EntryUnit,
      a.GoodsMovementType
}
where
     a.GoodsMovementType = '541'
  or a.GoodsMovementType = '122'
  or a.GoodsMovementType = '301'
  or a.GoodsMovementType = '311'
  or a.GoodsMovementType = '161'
