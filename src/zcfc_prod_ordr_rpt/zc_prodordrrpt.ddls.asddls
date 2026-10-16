@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Order Material Reco-Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_PRODORDRRPT
  provider contract transactional_query
  as projection on ZI_PRODORDRRPT
{
      @EndUserText.label: 'Production Order No'
      @Search.defaultSearchElement: true
  key ProductionOrder,
      @UI.hidden: true
  key ProductionOrderItem,
      @EndUserText.label: 'Product No'
  key Product,
      @EndUserText.label: 'Product Description'
  key Prod_Desc,
      @EndUserText.label: 'Plant'
  key ProductionPlant,
      @UI.hidden: true
  key Reservation,
      @UI.hidden: true
  key ReservationItem,
      @UI.hidden: true
  key BillOfMaterialInternalID,
      @EndUserText.label: 'Sl No'
  key BillOfMaterialItemNumber,
      @EndUserText.label: 'Component No'
  key Material,
      @EndUserText.label: 'Component Description'
      Mat_Desc,
      @EndUserText.label: 'Component Group'
      ProductGroupText,
      @EndUserText.label: 'Prod. Order Type Code'
      ProductionOrderType,
      @EndUserText.label: 'Prod. Order Type Name'
      OrderTypeName,
      @EndUserText.label: 'Created By'
      CreatedBy,
      @EndUserText.label: 'Creation Date'
      CreationDate,
      @EndUserText.label: 'Last Updated By'
      LastUpdatedBy,
      @EndUserText.label: 'Last Updated Date'
      LastChangeDate,
      @EndUserText.label: 'Comp. Storage Location'
      CompStrgLoc,
      @EndUserText.label: 'Planned Order'
      PlannedOrder,
      @EndUserText.label: 'Profit Center'
      ProfitCenter,
      @EndUserText.label: 'Profit Center Name'
      Profit_Center_Name,
      @EndUserText.label: 'Release Date'
      OrderActualReleaseDate,
      @EndUserText.label: 'Order Status'
      OrdStatus,
      @EndUserText.label: 'Ordered Qty'
      PlannedTotalQty,
      @EndUserText.label: 'Delivered Qty'
      GoodsReceiptQty,
      @EndUserText.label: 'Pending Qty'
      OpenYieldQuantity,
      @EndUserText.label: 'Component-Planned Qty'
      RequiredQuantity,
      @EndUserText.label: 'Component Qty(based on Order)'
      Comp_Qty_Based_on_Order,
      @EndUserText.label: 'Planned Qty(as per Order)'
      Planned_Qty_as_Per_Order,
      @EndUserText.label: 'Component-Issued Qty'
      WithdrawnQuantity,
      @EndUserText.label: 'Component-Cost'
      WithdrawnQuantityAmount,
      @EndUserText.label: 'Final Issued'
      Final_Issued,
      @EndUserText.label: 'Issued Qty Diff.(Order-Actual Issue)'
      Issued_Qty_Diff,
      @EndUserText.label: 'BOM Qty'
      BillOfMaterialItemQuantity,
      @EndUserText.label: 'UoM'
      UnitOfMeasure_E,
      @EndUserText.label: 'Planned Qty(as per BOM)'
      Planned_Qty_as_Per_BOM,
      @EndUserText.label: 'Issued Qty(as per BOM)'
      Issued_Qty_as_Per_BOM,
      @EndUserText.label: 'Issued Qty Difference'
      Issued_Qty_Difference
}
