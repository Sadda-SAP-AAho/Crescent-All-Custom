@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Open Sales Stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_1
  //  as select from ZI_OPENSORPT
  as select from ZR_PLAN_RPT_1_3
{
  key Plant,
  key Product,
      reqdeldate,
      ScheduleLineCategory,
      cast( sum( balanceqty ) as abap.dec( 20, 3 ) ) as OpenSoQty

}
group by
  Plant,
  Product,
  reqdeldate,
  ScheduleLineCategory
