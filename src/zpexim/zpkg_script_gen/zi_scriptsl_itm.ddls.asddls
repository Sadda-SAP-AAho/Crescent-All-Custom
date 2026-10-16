@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Script Sales Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_scriptsl_itm
  as select from zdt_scriptsl_itm
  association to parent zi_scriptsl_hdr as _Head on $projection.id = _Head.id
{
  key id,
  key item,
      accdocno,
      scriptsalesno,
      scriptsalesdate,
      scriptno,
      scriptdate,
      saccode,
      currency,
      @Semantics.amount.currencyCode: 'currency'
      realizationamt,
      rate,
      @Semantics.amount.currencyCode: 'currency'
      saleablevalue,
      customer,
      customername,
      salesflag,
      cancelledaccdocno,

      _Head // Make association public
}
