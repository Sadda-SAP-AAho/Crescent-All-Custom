@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Amount Calculation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zcds_valuecal
  as select from    zcds_export_1 as a
    left outer join zcds_export_2 as b on b.BillingDocument = a.BillingDocument
    left outer join zcds_export_3 as c on c.BillingDocument = a.BillingDocument
    left outer join zcds_export_4 as d on d.BillingDocument = a.BillingDocument
{
  key a.BillingDocument,
      cast( case when a.ConditionAmount is not initial then a.ConditionAmount else 0 end as abap.dec(15,2) ) as Value,
      cast( case when b.ConditionAmount is not initial then b.ConditionAmount else 0 end as abap.dec(15,2) ) as Value1,
      cast( case when d.ConditionAmount is not initial then d.ConditionAmount else 0 end as abap.dec(15,2) ) as Discount,
      cast( case when c.ConditionAmount is not initial then c.ConditionAmount else 0 end as abap.dec(15,2) ) as Freight
}
