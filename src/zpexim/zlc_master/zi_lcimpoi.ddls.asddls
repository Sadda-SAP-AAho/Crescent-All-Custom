@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entity View for LC PO Item'
@Metadata.allowExtensions: true
define view entity zi_lcimpoi 
as select from zdt_lcimpoi
association to parent zi_lchead as _head on $projection.Id = _head.Id
{
    key zdt_lcimpoi.id as Id,
    key zdt_lcimpoi.item2 as Item2,
    zdt_lcimpoi.ebeln as Ebeln,
    zdt_lcimpoi.display as Display,
    zdt_lcimpoi.waers as Waers,
    @Semantics.amount.currencyCode : 'WAERS'
    zdt_lcimpoi.netwr as Netwr,
    @Semantics.amount.currencyCode : 'WAERS'
    zdt_lcimpoi.avail_amount as Avail_Amount,
    @Semantics.amount.currencyCode : 'WAERS'
    zdt_lcimpoi.appl_amt_lc as Appl_Amt_Lc,
    @Semantics.amount.currencyCode : 'WAERS'
    zdt_lcimpoi.appl_amt_othlc as Appl_Amt_Othlc,
    zdt_lcimpoi.meins as Meins,
    @Semantics.quantity.unitOfMeasure : 'MEINS'
    zdt_lcimpoi.appl_qty as Appl_Qty,
    zdt_lcimpoi.amount_level as Amount_Level,
    zdt_lcimpoi.detail as Detail,
    zdt_lcimpoi.locallastchangedat as Locallastchangedat,
    _head // Make association public
}
