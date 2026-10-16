@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Del Qty Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_DELQTY
  as select distinct from I_MaterialDocumentItem_2
{
  key  PurchaseOrder,
  key  PurchaseOrderItem,
       MaterialBaseUnit,
       @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
       sum( QuantityInBaseUnit )     as delqty,
       CompanyCodeCurrency,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       sum(TotalGoodsMvtAmtInCCCrcy) as delval

}
where
  GoodsMovementType = '101'
group by
  PurchaseOrder,
  PurchaseOrderItem,
  MaterialBaseUnit,
  CompanyCodeCurrency
