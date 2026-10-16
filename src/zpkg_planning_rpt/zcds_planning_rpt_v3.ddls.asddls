@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shortage Rport Stock FG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PLANNING_RPT_V3
  as select from ZCDS_PLANNING_RPT_V3_1

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
