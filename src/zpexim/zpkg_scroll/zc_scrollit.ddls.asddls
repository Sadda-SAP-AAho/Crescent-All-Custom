@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Scroll Item Dasboard'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_SCROLLIT

  as projection on ZR_SCROLLITEM
{
  key id,
  key item,
      @EndUserText.label: 'Scroll Number'
      scrollno,
      @EndUserText.label: 'Shipping Bill'
      shipping_bill,
      @EndUserText.label: 'Shipping Bill Date'
      shipping_bill_date,
      @EndUserText.label: 'Port Code'
      port_code,
      @EndUserText.label: 'Port Code Name'
      port_codename,
      @EndUserText.label: 'Currency'
      currency,
      @Semantics.amount.currencyCode : 'currency'
      @EndUserText.label: 'FOB Value'
      fob_lc_v,
      @Semantics.amount.currencyCode : 'currency'
      @EndUserText.label: 'RoDTEP/DutyDrawBack Value'
      rodtep_dd_v,
      @Semantics.amount.currencyCode : 'currency'
      @EndUserText.label: 'Applied Amount'
      appliedamount,
      /* Associations */
      _head : redirected to parent ZC_SCROLLHD
}
