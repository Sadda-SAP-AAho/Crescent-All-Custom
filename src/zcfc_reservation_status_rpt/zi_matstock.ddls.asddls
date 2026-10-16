@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_MATSTOCK
  as select distinct from ZI_MATWHSTOCK
{
  key Product,
  key Plant,
  key StorageLocation,
      MaterialBaseUnit,
      @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'
      sum(MatlWrhsStkQtyInMatlBaseUnit) as MatlWrhsStkQtyInMatlBaseUnit

}

group by
  Product,
  Plant,
  StorageLocation,
  MaterialBaseUnit
