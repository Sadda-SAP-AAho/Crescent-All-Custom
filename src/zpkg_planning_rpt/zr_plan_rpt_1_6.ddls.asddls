@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Planning Stock 1_6'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_1_6
  as select from    ZR_PLAN_RPT_1_5     as a
//    left outer join I_ProductPlantBasic as b on  b.Product = a.Product
//                                             and b.Plant   = a.Plant
{
//  key (case when b.SpecialProcurementType = '40' then '1100'
//                    else a.Plant end) as Plant,
  key a.Plant,
  key a.Product,
  key a.DayQty,
      sum( a.OpenSoQty)               as OpenSoQty

}
group by
  a.Plant,
//  b.SpecialProcurementType,
  a.Product,
  a.DayQty
