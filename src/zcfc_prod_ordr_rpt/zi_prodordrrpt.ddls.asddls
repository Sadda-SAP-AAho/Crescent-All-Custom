@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Order Material Reco-Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PRODORDRRPT
  as select distinct from ZI_PRODORDRRPT_1
{
  key ProductionOrder,
  key ProductionOrderItem,
  key Product,
  key Prod_Desc,
  key ProductionPlant,
  key Reservation,
  key ReservationItem,
  key BillOfMaterialInternalID,
  key BillOfMaterialItemNumber,
  key Material,
      Mat_Desc,
      ProductGroupText,
      ProductionOrderType,
      OrderTypeName,
      CreatedBy,
      CreationDate,
      LastUpdatedBy,
      LastChangeDate,
      CompStrgLoc,
      PlannedOrder,
      ProfitCenter,
      Profit_Center_Name,
      OrderActualReleaseDate,
      OrdStatus,
      PlannedTotalQty,
      GoodsReceiptQty,
      OpenYieldQuantity,
      RequiredQuantity,
      Comp_Qty_Based_on_Order,
      Planned_Qty_as_Per_Order,
      WithdrawnQuantity,
      WithdrawnQuantityAmount,
      Final_Issued,
      Issued_Qty_Diff,
      BillOfMaterialItemQuantity,
      UnitOfMeasure_E,
      Planned_Qty_as_Per_BOM,
      Issued_Qty_as_Per_BOM,
      Issued_Qty_Difference
}
