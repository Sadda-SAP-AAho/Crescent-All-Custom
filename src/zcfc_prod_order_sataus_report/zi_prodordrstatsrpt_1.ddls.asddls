@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Order Status Report-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PRODORDRSTATSRPT_1
  as select distinct from ZI_PRODORDRRPT
{
  key ProductionOrder,
      OrderActualReleaseDate,
      OrdStatus,
      ProductionOrderType,
      OrderTypeName,
      CreatedBy,
      CreationDate,
      LastUpdatedBy,
      LastChangeDate,
      PlannedOrder,
      ProfitCenter,
      Profit_Center_Name,
      Product,
      Prod_Desc,
      ProductionPlant,
      PlannedTotalQty,
      GoodsReceiptQty,
      OpenYieldQuantity
}
