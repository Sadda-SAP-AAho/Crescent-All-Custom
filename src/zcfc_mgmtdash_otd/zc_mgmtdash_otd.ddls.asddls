@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-OTD'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_MGMTDASH_OTD
  as select distinct from ZI_MGMTDASH_OTD
{
      @EndUserText.label: 'Day/Month/Yr'
  key Type,
      @EndUserText.label: 'Plant'
  key Plant,
      @EndUserText.label: 'Profit Center'
  key ProfitCenterName,
      @EndUserText.label: 'Ontime Desp Wt'
      ontimdespwt
}
