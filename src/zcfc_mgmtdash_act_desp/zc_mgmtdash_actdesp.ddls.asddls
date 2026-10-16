@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-Actual Dispatch'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_MGMTDASH_ACTDESP
  as select distinct from ZI_MGMTDASH_ACTDESP
{
      @EndUserText.label: 'Type'
  key Type,
      @EndUserText.label: 'Plant'
  key Plant,
      @EndUserText.label: 'Profit Center'
  key ProfitCenter,
      @EndUserText.label: 'Actual Desp Wt(KG)'
      Act_Desp_Wt,
      @EndUserText.label: 'Actual Desp Wt(MT)'
      Act_Desp_Wt_MT
}
