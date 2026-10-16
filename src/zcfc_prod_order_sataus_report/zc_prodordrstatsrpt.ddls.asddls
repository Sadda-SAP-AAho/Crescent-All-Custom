@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Order Status Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE

define root view entity ZC_PRODORDRSTATSRPT
  provider contract transactional_query
  as projection on ZI_PRODORDRSTATSRPT
{
      @EndUserText.label: 'Production Order No'
      @Search.defaultSearchElement: true
  key ProductionOrder,

      @EndUserText.label: 'Release Date'
      OrderActualReleaseDate,

      @EndUserText.label: 'Order Status'
      OrdStatus,

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

      @EndUserText.label: 'Planned Order'
      PlannedOrder,

      @EndUserText.label: 'Profit Center'
      ProfitCenter,

      @EndUserText.label: 'Profit Center Name'
      Profit_Center_Name,

      @EndUserText.label: 'Product No'
      Product,

      @EndUserText.label: 'Product Description'
      Prod_Desc,

      @EndUserText.label: 'Plant'
      ProductionPlant,

      @EndUserText.label: 'Ordered Qty'
      PlannedTotalQty,

      @EndUserText.label: 'Delivered Qty'
      GoodsReceiptQty,

      @EndUserText.label: 'Pending Qty'
      OpenYieldQuantity,
      
      @UI.hidden: true
      Meins,

      @EndUserText.label: 'SF Simulated Qty'
      @Semantics.quantity.unitOfMeasure: 'Meins'
      ShopFlrQty

      
}
