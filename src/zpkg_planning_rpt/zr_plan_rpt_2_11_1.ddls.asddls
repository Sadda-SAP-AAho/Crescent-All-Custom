@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for club stock Z045'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_2_11_1
  as select from ZR_PLAN_RPT_2_11
{
  key plant,
  key component,
      sum(stockZ045) as stockZ045
}
group by
  plant,
  component
