@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Script Generation Dashboard'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity zc_scriptgn_itm
  as projection on zi_scriptgn_itm
{
  key id,
  key item,
      @EndUserText.label: 'Script Number'
      scriptno,
      @EndUserText.label: 'Scroll Number'
      scrollno,
      @EndUserText.label: 'Shipping Bill'
      shipping_bill,
      @EndUserText.label: 'Shipping Bill Date'
      shipping_bill_date,
      @EndUserText.label: 'Script Date'
      scriptdate,
      @EndUserText.label: 'Port of Loading'
      port_code,
      @EndUserText.label: 'Port of Loading Name'
      port_codename,
      @EndUserText.label: 'Currency'
      currency,
      @Semantics.amount.currencyCode : 'currency'
      @EndUserText.label: 'FOB Value'
      fob_lc_v,
      @Semantics.amount.currencyCode : 'currency'
      @EndUserText.label: 'RoDTEP Applied Value'
      rodtep_dd_v,
      @Semantics.amount.currencyCode : 'currency'
      @EndUserText.label: 'Realization Value'
      realizationamt,
      @Semantics.amount.currencyCode : 'currency'
      @EndUserText.label: 'Difference'
      difference,

      /* Associations */
      _Head : redirected to parent zc_scriptgn_HDR
}
