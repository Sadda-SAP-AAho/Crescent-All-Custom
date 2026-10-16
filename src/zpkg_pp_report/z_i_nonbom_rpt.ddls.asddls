@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'NON BOM REPORT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_NONBOM_RPT
  provider contract transactional_query
  as projection on I_ProductValuationTP_2 as nonbom
{
  key Product,
  key ValuationArea,
  key ValuationType,
      ValuationClass,
      PriceDeterminationControl,
      Currency,
      @Semantics.amount.currencyCode : 'Currency'
      StandardPrice,
      ProductPriceUnitQuantity,
      InventoryValuationProcedure,
      @Semantics.amount.currencyCode : 'Currency'
      MovingAveragePrice,
      ValuationCategory,
      ProductUsageType,
      ProductOriginType,
      IsProducedInhouse,
      IsMarkedForDeletion,
      ValuationClassSalesOrderStock,
      ProjectStockValuationClass,
      BaseUnit,
      ValuationMarginPercent
}
