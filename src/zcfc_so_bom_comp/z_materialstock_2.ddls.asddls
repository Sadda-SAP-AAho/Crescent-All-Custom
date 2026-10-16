@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_MATERIALSTOCK_2
  as select from I_MaterialStock_2
{
  key Material,
  key Plant,
  key StorageLocation,
  key Batch,
  key Supplier,
  key SDDocument,
  key SDDocumentItem,
  key WBSElementInternalID,
  key Customer,
  key SpecialStockIdfgStockOwner,
  key InventoryStockType,
  key InventorySpecialStockType,
  key FiscalYearVariant,
  key MatlDocLatestPostgDate,
  key MaterialBaseUnit,
  key CostEstimate,
  key ResourceID,
      CompanyCode,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @Aggregation.default: #SUM
      MatlWrhsStkQtyInMatlBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @Aggregation.default: #SUM
      MatlCnsmpnQtyInMatlBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @Aggregation.default: #SUM
      MatlStkIncrQtyInMatlBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @Aggregation.default: #SUM
      MatlStkDecrQtyInMatlBaseUnit,
      /* Associations */
      _CompanyCode,
      _CurrentInvtryPrice,
      _Customer,
      _InventoryPriceByPeriodEndDate,
      _InventorySpecialStockType,
      _InventoryStockType,
      _InvtryPrcBasicByPeriodEndDate,
      _Material,
      _Plant,
      _ResourceBasic,
      _SpclStkIdfgWBSElmntBasicData,
      _SpecialStockIdfgStockOwner,
      _StorageLocation,
      _Supplier,
      _UnitOfMeasure
}
