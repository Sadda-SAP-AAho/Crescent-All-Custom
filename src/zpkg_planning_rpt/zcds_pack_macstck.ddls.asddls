@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List wise Short - Machine Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PACK_MACSTCK
  as select from    ZCDS_PACK_MACSTCK_1
    
{
  hedmaterial,
  component,
  Plant,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  qty,
  MaterialBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
  sum(qty1) as qty1,
  MaterialBaseUnit1
}

group by
  hedmaterial,
  component,
  Plant,
  qty,
  MaterialBaseUnit,
  MaterialBaseUnit1
