@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Item Data Print'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_SCRIPTINV_ITM 
as select distinct from  zi_scriptsl_hdr as i
    inner join zdt_scriptsl_itm as k on k.id = i.id
{
    key i.scriptsalesno, 
    i.accdocno,
    i.scriptsalesdate,
    k.scriptno,
    k.scriptdate,
    i.saccode,
    k.currency,
    @Semantics.amount.currencyCode : 'currency'
    k.realizationamt,
    k.rate,
    @Semantics.amount.currencyCode : 'currency'
    k.saleablevalue
}
