@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 help for Profit Center'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PROFITCENTER
  as select from I_ProfitCenterText
{
  key ProfitCenter as prftcntr,
      ProfitCenterName as prftcntrnm
}
