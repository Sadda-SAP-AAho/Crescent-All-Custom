@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GRN Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_GRNDETAILS
  as select from I_MaterialDocumentItem_2 as a
{
  key a.PurchaseOrder,
  key a.PurchaseOrderItem,
  key a.MaterialDocument,
  key ltrim( a.YY1_GateEntryNumber_MMI, '0' ) as GateEntryNo,
      a.PostingDate,
      a.DocumentDate,
      a.MaterialBaseUnit                      as BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      a.QuantityInBaseUnit,
      a.StorageLocation

}

where
  a.GoodsMovementType = '101'
