@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-Inventory'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_MGMTDASHINV
  as select distinct from ZI_MGMTDASHINV_BASIC
{
  key Plant,
  key ProfitCenterName as Profit_Center,
      FgLivewt         as FG_OnHand,
      FgdeadWt         as FG_Dead,
      SfgOnHandWt      as SFG_OnHand,
      SfgdeadWt        as SFG_Dead,
      rmonhandwt       as RM_OnHand,
      StrStkCost       as Store_Amt
}
