@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Dcoument Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_MAT_DOC
  as select from I_MaterialDocumentItem_2
{
  key MaterialDocumentYear,
  key MaterialDocument,
  key MaterialDocumentItem,
      OrderID,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      case GoodsMovementType
      when '102'
      then QuantityInBaseUnit * (-1)
      else QuantityInBaseUnit end as qty
}
where
       OrderID         is not initial
  and(
       StorageLocation = 'BGRJ'
    or StorageLocation = 'KURJ'
    or StorageLocation = 'SARJ'
    or StorageLocation = 'BARJ'
  )
  and ( GoodsMovementType = '101'
  or GoodsMovementType = '102' )
