@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'BOE Item'
define view entity ZR_BOEITEMTP

  as select from zim_boe_item

  association to parent ZR_BOETP as _BOE on $projection.InternalBoe = _BOE.InternalBoe

{
  key zim_boe_item.internalboe       as InternalBoe,
  key zim_boe_item.internalitemboe   as InternalItemBoe,
      zim_boe_item.po                as Po,
      zim_boe_item.poitem            as Poitem,
      zim_boe_item.material          as Material,
      zim_boe_item.makxt             as Makxt,
      zim_boe_item.currency          as Currency,
      zim_boe_item.dutycurrency      as DutyCurrency,
      zim_boe_item.povalue           as Povalue,
      zim_boe_item.unit              as Unit,
      zim_boe_item.poqty             as Poqty,
      zim_boe_item.arrivedqty        as Arrivedqty,
      zim_boe_item.assessablevalue   as Assessablevalue,
      zim_boe_item.assessablevaluefc as Assessablevaluefc,
      zim_boe_item.totaldutysaved    as Totaldutysaved,
      zim_boe_item.locallastchangedat,

      _BOE
}
