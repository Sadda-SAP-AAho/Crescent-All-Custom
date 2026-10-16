@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Goods Receipt Qty'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_GOODSRECPTQTY
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
  (
       GoodsMovementType = '101'
    or GoodsMovementType = '123'
  )
group by
  PurchaseOrder,
  PurchaseOrderItem,
  MaterialBaseUnit,
  CompanyCodeCurrency

union

select distinct from I_MaterialDocumentItem_2
{
  key  PurchaseOrder,
  key  PurchaseOrderItem,
       MaterialBaseUnit,
       sum( QuantityInBaseUnit ) * (-1)     as delqty,
       CompanyCodeCurrency,
       sum(TotalGoodsMvtAmtInCCCrcy) * (-1) as delval

}
where
  (
       GoodsMovementType = '102'
    or GoodsMovementType = '122'
  )

group by
  PurchaseOrder,
  PurchaseOrderItem,
  MaterialBaseUnit,
  CompanyCodeCurrency
