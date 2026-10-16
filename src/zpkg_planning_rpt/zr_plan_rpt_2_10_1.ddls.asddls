@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for club stock Z024'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_2_10_1
  as select from ZR_PLAN_RPT_2_10
{
  key plant,
  key component,
      sum(stockZ024) as stockZ024
}
group by
  plant,
  component
