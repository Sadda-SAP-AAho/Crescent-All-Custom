@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Open Sales Order stock 1_4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_1_4
  as select distinct from ZR_PLAN_RPT_1
{
  key Plant,
  key Product,
      sum( OpenSoQty) as OpenSoQty

}
group by
  Plant,
  Product
