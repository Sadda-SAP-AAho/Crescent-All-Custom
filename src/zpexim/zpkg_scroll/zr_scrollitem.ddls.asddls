@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Scroll Item Dasboard'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_SCROLLITEM

  as select from zdt_scroll_item

  association to parent ZR_SCROLLHEAD as _head on $projection.id = _head.id
{
  key id,
  key item,
      scrollno,
      shipping_bill,
      shipping_bill_date,
      port_code,
      port_codename,
      currency,
      @Semantics.amount.currencyCode : 'currency'
      fob_lc_v,
      @Semantics.amount.currencyCode : 'currency'
      rodtep_dd_v,
      @Semantics.amount.currencyCode : 'currency'
      appliedamount,

      _head
}
