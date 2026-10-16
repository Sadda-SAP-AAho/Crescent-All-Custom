@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Prod Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_I_Prod_Order
  provider contract transactional_query
  as projection on I_ProductionOrderTP as Ordr
{
  key ProductionOrder,
      Product,
      ProductionPlant,
      CreatedByUser,
      CreationDate,
      LastChangedByUser,
      LastChangeDate,
      ProductionOrderType,
      PlannedOrder,
      ProfitCenter,
      OrderActualReleaseDate
}
