@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Script Sales Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zi_scriptsl_hdr
  as select from zdt_scriptsl_hdr
  composition [0..*] of zi_scriptsl_itm as _Item
{
  key id,
      companycode,
      bupla,
      scriptsalesno,
      scriptsalesdate,
      scriptno,
      saccode,
      customer,
      customername,
      accdocno,
      docyear,
      accpostref,
      glno,
      status,
      currency,
      @Semantics.amount.currencyCode : 'currency'
      sum_realizationamt,
      @Semantics.amount.currencyCode : 'currency'
      sum_saleablevalue,
      local_created_by,
      local_created_on,
      local_created_at,
      local_last_changed_by,
      local_last_changed_on,
      local_last_changed_at,
      last_changed_at,
      post,
      accupd,
      printsi,
      flag,
      _Item // Make association public
}
