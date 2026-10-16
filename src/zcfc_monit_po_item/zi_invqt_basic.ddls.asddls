@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inv Qty Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_INVQT_BASIC
  as select distinct from I_SuplrInvcItemPurOrdRefAPI01 as a
    inner join            I_SupplierInvoiceAPI01        as b on  a.SupplierInvoice = b.SupplierInvoice
                                                             and a.FiscalYear      = b.FiscalYear
{
  key  a.PurchaseOrder,
  key  a.PurchaseOrderItem,
       a.PurchaseOrderQuantityUnit,
       @Semantics.quantity.unitOfMeasure:'PurchaseOrderQuantityUnit'
       sum(a.QuantityInPurchaseOrderUnit)                                               as InvQty,
       ( case when a.DocumentCurrency <> 'INR' then 'INR' else a.DocumentCurrency end ) as DocumentCurrency,
       (case when a.DocumentCurrency <> 'INR' then ( sum( cast( a.SupplierInvoiceItemAmount as abap.dec(12,3) ) ) * b.ExchangeRate )
             else sum( cast( a.SupplierInvoiceItemAmount as abap.dec(12,3) ) ) end )    as InvVal


}

where
      a.DebitCreditCode               = 'S'
  and a.SuplrInvcDeliveryCostCndnType is initial

group by
  a.PurchaseOrder,
  a.PurchaseOrderItem,
  a.PurchaseOrderQuantityUnit,
  a.DocumentCurrency,
  b.ExchangeRate

union

select distinct from I_SuplrInvcItemPurOrdRefAPI01 as a
  inner join         I_SupplierInvoiceAPI01        as b on  a.SupplierInvoice = b.SupplierInvoice
                                                        and a.FiscalYear      = b.FiscalYear
{
  key  a.PurchaseOrder,
  key  a.PurchaseOrderItem,
       a.PurchaseOrderQuantityUnit,
       sum(a.QuantityInPurchaseOrderUnit) * (-1)                                           as InvQty,
       ( case when a.DocumentCurrency <> 'INR' then 'INR' else a.DocumentCurrency end )    as DocumentCurrency,
       (case when a.DocumentCurrency <> 'INR' then ( sum( cast( a.SupplierInvoiceItemAmount as abap.dec(12,3)) ) * (-1) * b.ExchangeRate )
             else sum( cast( a.SupplierInvoiceItemAmount as abap.dec(12,3)) ) * (-1) end ) as InvVal


}

where
      a.DebitCreditCode               = 'H'
  and a.SuplrInvcDeliveryCostCndnType is initial

group by
  a.PurchaseOrder,
  a.PurchaseOrderItem,
  a.PurchaseOrderQuantityUnit,
  a.DocumentCurrency,
  b.ExchangeRate
