@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Mat, Plant and Storage loc wise stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PLANING_RPT_V2
  as select from ZCDS_PLANING_RPT_V2_1

{
  Product,
  Plant,
  StorageLocation,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  sum(qty) as qty,
  MaterialBaseUnit

}

group by
  Product,
  Plant,
  StorageLocation,
  MaterialBaseUnit
