@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forShippingBillItem'
define view entity ZR_ShippingBillItemTP
  as select from zex_shipbill_itm
  association to parent ZR_ShippingBillTP as _ShippingBill on $projection.InternalShipbill = _ShippingBill.InternalShipbill
{
  key    internal_shipbill_item as InternalShipbillItem,
  key    internal_shipbill      as InternalShipbill,
         invoice                as Invoice,
         invoicedate            as InvoiceDate,
         @Semantics.amount.currencyCode: 'InvoiceValueFcC'
         invoice_value_fc_v     as InvoiceValueFcV,
         invoice_value_fc_c     as InvoiceValueFcC,
         exchangerate           as Exchangerate,
         @Semantics.amount.currencyCode: 'InvoiceValueLcC'
         invoice_value_lc_v     as InvoiceValueLcV,
         invoice_value_lc_c     as InvoiceValueLcC,
         total_duty_drawback_lc,
         total_duty_drawback_v_lc,
         total_rodtep_lc,
         total_rodtep_v_lc,
         @Semantics.systemDateTime.localInstanceLastChangedAt: true
         local_last_changed_at  as LocalLastChangedAt,
         @Semantics.amount.currencyCode: 'InvoiceValueFcC'
         total_duty_drawback_v_fc,
         @Semantics.amount.currencyCode: 'InvoiceValueFcC'
         total_rodtep_v_fc,
         
         _ShippingBill
}
