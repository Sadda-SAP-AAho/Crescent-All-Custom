@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Script Generation Dashboard'
define root view entity zc_scriptgn_HDR
  provider contract transactional_query
  as projection on zi_scriptgn_hdr
{
  key id,
      @EndUserText.label: 'Script Number'
      scriptno,
      @EndUserText.label: 'Script Date'
      scriptdate,
      @EndUserText.label: 'Scroll Number'
      @Search.defaultSearchElement: true
      scrollno,
      @EndUserText.label: 'Shipping Bill'
      shippingbill,
      @EndUserText.label: 'Status'
      status,
      currency,
      @Semantics.amount.currencyCode : 'currency'
      @EndUserText.label: 'Total RoDTEP Value'
      sum_rodtep_dd_v,
      @Semantics.amount.currencyCode : 'currency'
      @EndUserText.label: 'Total Realization Value'
      sum_realizationamt,
      @Semantics.amount.currencyCode : 'currency'
      @EndUserText.label: 'Total Difference'
      sum_difference,
      local_created_by,
      local_created_at,
      local_created_on,
      local_last_changed_by,
      local_last_changed_at,
      local_last_changed_on,
      last_changed_at,
      @EndUserText.label: 'Account Post'
      post,
      @EndUserText.label: 'Account Doc No'
      accountdocno,
      @EndUserText.label: 'Account Doc Yr'
      accountdocyr,
      @EndUserText.label: 'Acc.Doc Referencr No'
      accpostref,
            

      /* Associations */
      _Item : redirected to composition child zc_scriptgn_itm
}
