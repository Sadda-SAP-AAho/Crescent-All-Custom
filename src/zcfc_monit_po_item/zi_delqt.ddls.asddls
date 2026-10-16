@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Del Qty Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_DELQT
  as select distinct from ZI_GOODSRECPTQTY
{
  key  PurchaseOrder,
  key  PurchaseOrderItem,
       MaterialBaseUnit,
       @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
       sum(delqty) as delqty,
       CompanyCodeCurrency,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       sum(delval) as delval

}

group by
  PurchaseOrder,
  PurchaseOrderItem,
  MaterialBaseUnit,
  CompanyCodeCurrency
