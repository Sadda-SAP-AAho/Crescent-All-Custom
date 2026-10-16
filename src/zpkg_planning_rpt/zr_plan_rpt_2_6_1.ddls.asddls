@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for club stock Z028'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_2_6_1
  as select from ZR_PLAN_RPT_2_6
{
  key plant,
  key component,
      sum(stockZ028) as stockZ028
}
group by
  plant,
  component
