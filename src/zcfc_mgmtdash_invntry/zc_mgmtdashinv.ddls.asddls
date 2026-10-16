@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-Inventory'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_MGMTDASHINV
  as select distinct from ZI_MGMTDASHINV
{
      @EndUserText.label: 'Plant'
  key Plant,
      @EndUserText.label: 'Profit Center'
  key Profit_Center,

      @EndUserText.label: 'FG-OnHand'
      FG_OnHand,

      @EndUserText.label: 'FG-Dead'
      FG_Dead,

      @EndUserText.label: 'SFG-OnHand'
      SFG_OnHand,

      @EndUserText.label: 'SFG-Dead'
      SFG_Dead,
      
      @EndUserText.label: 'RM-OnHand'
      RM_OnHand,
      
      @EndUserText.label: 'Store-Amt'
      Store_Amt
}
