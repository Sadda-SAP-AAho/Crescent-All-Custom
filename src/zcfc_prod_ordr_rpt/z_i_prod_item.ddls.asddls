@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Prod Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_PROD_ITEM
  provider contract transactional_query
  as projection on I_ProductionOrderItemTP as ProdItem
{
  key ProductionOrder,
  key ProductionOrderItem,
      Product,
      ProductionPlant,
      ProductionOrderType,
      ProductionUnit,
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      PlannedTotalQty,
      @Semantics.quantity.unitOfMeasure: 'ProductionUnit'
      GoodsReceiptQty
}
