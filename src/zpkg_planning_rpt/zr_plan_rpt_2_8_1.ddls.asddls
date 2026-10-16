@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for club stock Z026'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_2_8_1
  as select from ZR_PLAN_RPT_2_8
{
  key plant,
  key component,
      sum(stockZ026) as stockZ026
}
group by
  plant,
  component
