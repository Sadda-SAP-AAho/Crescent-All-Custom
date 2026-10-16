@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Del Qty Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_INVQTY
  as select distinct from I_SuplrInvcItemPurOrdRefAPI01
{
  key  SupplierInvoice,
  key  SupplierInvoiceItem,
  key  PurchaseOrder,
  key  PurchaseOrderItem,
       PurchaseOrderQuantityUnit,
       @Semantics.quantity.unitOfMeasure:'PurchaseOrderQuantityUnit'
       sum(QuantityInPurchaseOrderUnit) as InvQty,
       DocumentCurrency,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       sum( SupplierInvoiceItemAmount)  as InvVal


}

group by
  SupplierInvoice,
  SupplierInvoiceItem,
  PurchaseOrder,
  PurchaseOrderItem,
  PurchaseOrderQuantityUnit,
  DocumentCurrency
