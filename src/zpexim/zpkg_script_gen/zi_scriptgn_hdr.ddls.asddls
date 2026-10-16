@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Script Generation Dashboard'
define root view entity zi_scriptgn_hdr
  as select from zdt_scriptgn_hdr
  composition [0..*] of zi_scriptgn_itm as _Item
{
  key id,
      scriptno,
      scriptdate,
      scrollno,
      shippingbill,
      status,
      currency,
      @Semantics.amount.currencyCode : 'currency'
      sum_rodtep_dd_v,
      @Semantics.amount.currencyCode : 'currency'
      sum_realizationamt,
      @Semantics.amount.currencyCode : 'currency'
      sum_difference,
      local_created_by,
      local_created_at,
      local_created_on,
      local_last_changed_by,
      local_last_changed_at,
      local_last_changed_on,
      last_changed_at,
      post,
      accountdocno,
      accountdocyr,
      accpostref,
//      printsi,
      _Item
}
