@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Order Status Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PRODORDRSTATSRPT
  as select distinct from ZI_PRODORDRSTATSRPT_1 as a
    left outer join       ZI_PRODWISESHPFLRQTY  as b on a.ProductionOrder = b.Prodord
{
  key a.ProductionOrder,
      a.OrderActualReleaseDate,
      a.OrdStatus,
      a.ProductionOrderType,
      a.OrderTypeName,
      a.CreatedBy,
      a.CreationDate,
      a.LastUpdatedBy,
      a.LastChangeDate,
      a.PlannedOrder,
      a.ProfitCenter,
      a.Profit_Center_Name,
      a.Product,
      a.Prod_Desc,
      a.ProductionPlant,
      a.PlannedTotalQty,
      a.GoodsReceiptQty,
      a.OpenYieldQuantity,
      b.Meins,
      @Semantics.quantity.unitOfMeasure: 'Meins'
      b.ShopFlrQty
}

where
  a.OrdStatus = 'Released'
