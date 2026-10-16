@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report - Shipping Bill'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_13
  as select from ZI_FI_DEBTOR_RPT_6 as a
    inner join   zex_shipbill_itm   as b on b.invoice = a.BillingDocument
    inner join   zex_shipbill_hdr   as c on c.internal_shipbill = b.internal_shipbill
{
  a.arinv as BillingDocument,
  c.shipping_bill as shippingbill

}
group by
  a.arinv,
  c.shipping_bill
