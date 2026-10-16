@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Script Generation Dashboard'
define view entity zi_scriptgn_itm 
as select from zdt_scriptgn_itm
association to parent zi_scriptgn_hdr as _Head
    on $projection.id = _Head.id
{
    key id,
    key item,
    scriptno ,
    scriptdate ,
    scrollno ,
    shipping_bill ,
    shipping_bill_date ,
    port_code,
    port_codename ,
    currency,
    @Semantics.amount.currencyCode : 'currency'
    fob_lc_v ,
    @Semantics.amount.currencyCode : 'currency' 
    rodtep_dd_v ,
     @Semantics.amount.currencyCode : 'currency'
    realizationamt ,
     @Semantics.amount.currencyCode : 'currency'
    difference ,
    _Head // Make association public
}
