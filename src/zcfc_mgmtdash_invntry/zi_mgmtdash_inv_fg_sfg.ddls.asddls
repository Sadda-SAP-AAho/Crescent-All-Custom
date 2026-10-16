@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-Inventory(FG_SFG)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MGMTDASH_INV_FG_SFG
  as select distinct from ZI_PLAN_RPT as a
{
  key    a.plant,
  key    a.ProfitCenter,
         sum(a.FgLivewt)    as FgLivewt,
         sum(a.FgdeadWt)    as FgdeadWt,
         sum(a.SfgOnHandWt) as SfgOnHandWt,
         sum(a.SfgdeadWt)   as SfgdeadWt
}

group by
  a.plant,
  a.ProfitCenter
