@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Total Material ouantity based on Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MAT_TOT 
as select from ZI_ORD_MAT_DET
{
    Product,
    ProductionPlant,
    @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
    sum( OpenYieldQuantity ) as OpenYieldQuantity,
    ProductionUnit
}
group by
Product,
ProductionPlant,
ProductionUnit
