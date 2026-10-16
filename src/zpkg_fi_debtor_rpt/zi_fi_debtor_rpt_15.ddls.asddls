@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_DEBTOR_RPT_15
  as select from ZI_FI_DEBTOR_RPT_13 as a
    inner join   zex_shipbill_hdr    as b on b.shipping_bill = a.shippingbill
{
  a.BillingDocument,
  sum( cast( b.fob_lc_v as abap.dec( 23, 2 ) ) ) as fobvalue
}
group by
  a.BillingDocument
