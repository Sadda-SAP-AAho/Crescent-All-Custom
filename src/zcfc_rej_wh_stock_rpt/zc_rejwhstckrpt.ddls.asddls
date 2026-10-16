@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Rejection WH Stock Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_REJWHSTCKRPT
  provider contract transactional_query
  as projection on ZI_REJWHSTCKRPT
{
         @EndUserText.label: 'Material No'
         @Search.defaultSearchElement: true
  key    Product,
         @EndUserText.label: 'Description'
  key    ProductName,
         @EndUserText.label: 'Material Type'
  key    ProductType,
         @EndUserText.label: 'Material Group'
  key    ProductGroupText,
         @EndUserText.label: 'Plant'
  key    Plant,
         @EndUserText.label: 'Storage Location'
  key    StorageLocation,
         @EndUserText.label: 'Profit Center Code'
  key    PrftCntr,
         @EndUserText.label: 'Profit Center'
  key    ProfitCenter,
         @EndUserText.label: 'MOC'
  key    MOC,
         @EndUserText.label: 'Stock Type'
  key    StockType,
         @EndUserText.label: 'Batch'
  key    Batch,
         @UI.hidden: true
         MaterialBaseUnit,
         @EndUserText.label: 'Total Stock'
         MatStock,
         @EndUserText.label: 'UoM'
         UnitOfMeasure_E,
         @UI.hidden: true
         WeightUnit,
         @EndUserText.label: 'Unit Weight'
         NetWeight,
         @EndUserText.label: 'Total Weight'
         TotalWt,
         @EndUserText.label: 'Currency'
         Currency,
         @EndUserText.label: 'Stock Value'
         StockValue
}
