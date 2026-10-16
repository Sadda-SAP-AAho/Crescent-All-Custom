@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Warehouse Stock'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.viewEnhancementCategory: [#NONE]
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZC_MAT_WHSTOCK
  provider contract transactional_query
  as projection on ZI_MAT_WHSTOCK
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
      @EndUserText.label: 'Special Stock Number'
  key SpecialStockNumber,
      @EndUserText.label: 'Special Stock Type'
      SpecialStock,
      @EndUserText.label: 'Special Stock Number'
      StockTypeName,
      @UI.hidden: true
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      @EndUserText.label: 'Unrestricted Stock'
      MatlWrhsStkQtyInMatlBaseUnit,
      @EndUserText.label: 'Current Value of Unrestricted Stock'
      StockValueInCCCrcy,
      @EndUserText.label: 'Currency'
      Currency,
      @UI.hidden: true
      WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      @EndUserText.label: 'Net Weight'
      NetWeight,
      @EndUserText.label: 'Total Value'
      TotalValue
}
