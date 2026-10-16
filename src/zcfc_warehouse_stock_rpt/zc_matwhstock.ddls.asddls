@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Warehouse Stock Report'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_MATWHSTOCK
  provider contract transactional_query
  as projection on ZI_MATWHSTOCK
{
      @EndUserText.label: 'Material'
  key Product,
      @EndUserText.label: 'Material Description'
  key ProductName,
      @EndUserText.label: 'Material Group'
  key ProductGroup,
      @EndUserText.label: 'Material Group Name'
  key ProductGroupName,
      @EndUserText.label: 'Material Type'
  key ProductType,
      @EndUserText.label: 'Material Type Name'
  key ProductTypeName,
      @EndUserText.label: 'Plant'
  key Plant,
      @EndUserText.label: 'Plant Name'
  key PlantName,
      @EndUserText.label: 'Storage Location'
  key StorageLocation,
      @EndUserText.label: 'Storage Location Name'
      StorageLocationName,
      @EndUserText.label: 'Batch'
      Batch,
      @EndUserText.label: 'Shelf Life Expiration Date'
      ShelfLifeExpirationDate,
      @EndUserText.label: 'Production Date'
      ProductionDate,
      @EndUserText.label: 'Special Stock Type'
      InventorySpecialStockType,
      @EndUserText.label: 'Special Stock Type Description'
      StockTypeName,
      @UI.hidden: true
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      @EndUserText.label: 'Unrestricted Stock'
      MatlWrhsStkQtyInMatlBaseUnit,
      @EndUserText.label: 'Current Value of Unrestricted Stock'
      StockValueInCCCrcy,
      @EndUserText.label: 'Currency'
      Currency
}
