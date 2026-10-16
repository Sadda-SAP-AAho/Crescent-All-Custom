@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shipping Bill CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_shippingbill1
  as select from    ZR_ShippingBillItemTP as a
    left outer join ZR_ShippingBillTP     as b on b.InternalShipbill = a.InternalShipbill
{
  a.Invoice,
  b.ShippingBill,
  b.ShippingBillDate,
  @Semantics.amount.currencyCode: 'InvoiceValueLcC'
  a.InvoiceValueLcV,
  a.InvoiceValueLcC
}
where
  b.statuscancel <> 'X'
