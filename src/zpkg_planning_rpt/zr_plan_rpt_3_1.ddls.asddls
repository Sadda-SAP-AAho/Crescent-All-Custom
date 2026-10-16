@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Open Contract Stock_1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_3_1
  as select from ZR_PLAN_RPT_3
{
  key Product,
  key Plant,
      cast( sum(coalesce(TargetQuantity,0)) - sum( coalesce(OrderQuantity,0) ) as abap.dec( 20, 3)) as OpenContQty
      //    TargetQuantity,
      //    TargetQuantityUnit,
      //    OrderQuantity
}
group by
  Product,
  Plant
