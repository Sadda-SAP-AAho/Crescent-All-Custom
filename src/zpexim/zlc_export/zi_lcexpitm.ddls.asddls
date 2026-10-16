@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LC Export Item'
define view entity ZI_LCEXPITM
  as select from zdt_lcexpitm
  association to parent ZI_LCEXPHEAD as _head on $projection.Id = _head.Id

{
  key zdt_lcexpitm.id                 as Id,
  key zdt_lcexpitm.item2              as Item2,
      zdt_lcexpitm.vbeln              as Vbeln,
      zdt_lcexpitm.display            as Display,
      zdt_lcexpitm.waers              as Waers,
      zdt_lcexpitm.applcurr           as Applcurr,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lcexpitm.netwr              as Netwr,
      //      @Semantics.amount.currencyCode : 'WAERS'
      //      zdt_lcexpitm.avail_amount       as Avail_Amount,
      @Semantics.amount.currencyCode : 'applcurr'
      zdt_lcexpitm.appl_amt_lc        as Appl_Amt_Lc,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lcexpitm.appl_amt_othlc     as Appl_Amt_Othlc,
      zdt_lcexpitm.meins              as Meins,
      @Semantics.quantity.unitOfMeasure : 'MEINS'
      zdt_lcexpitm.appl_qty           as Appl_Qty,
      zdt_lcexpitm.amount_level       as Amount_Level,
      zdt_lcexpitm.detail             as Detail,
      zdt_lcexpitm.baseamt            as Baseamt,
      zdt_lcexpitm.delivery           as Delivery,
      zdt_lcexpitm.locallastchangedat as Locallastchangedat,

      _head
}
