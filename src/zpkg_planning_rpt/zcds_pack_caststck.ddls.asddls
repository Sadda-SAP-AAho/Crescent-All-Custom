@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Packing List wise Shortage - Cast Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PACK_CASTSTCK
  as select from ZCDS_PACK_CASTSTCK_1

{
  hedmaterial,
  component,
  Plant,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  qty,
  MaterialBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
  sum(qty1) as qty1,
  MaterialBaseUnit1,
  Cast_QtyPerBox,
  Cast_TypeMould,
  Cast_SubCode
}

group by
  hedmaterial,
  component,
  Plant,
  qty,
  MaterialBaseUnit,
  MaterialBaseUnit1,
  Cast_QtyPerBox,
  Cast_TypeMould,
  Cast_SubCode
