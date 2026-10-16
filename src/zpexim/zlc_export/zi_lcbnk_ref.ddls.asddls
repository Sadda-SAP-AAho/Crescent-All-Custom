@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For LC Export Bank References'
define view entity ZI_LCBNK_REF
  as select from zdt_lcbnk_ref
  association to parent ZI_LCEXPHEAD as _head on $projection.Id = _head.Id
{
  key zdt_lcbnk_ref.id                 as Id,
  key zdt_lcbnk_ref.item3              as Item3,
      zdt_lcbnk_ref.bank_ref           as Bank_Ref,
      zdt_lcbnk_ref.bank_dt            as Bank_Dt,
      zdt_lcbnk_ref.ship_dt            as Ship_Dt,
      zdt_lcbnk_ref.due_date           as Due_Date,
      zdt_lcbnk_ref.inv_no             as Inv_No,
      zdt_lcbnk_ref.waers              as Waers,
      @Semantics.amount.currencyCode : 'WAERS'
      zdt_lcbnk_ref.rmwwr              as Rmwwr,
      zdt_lcbnk_ref.bl_no              as Bl_No,
      zdt_lcbnk_ref.bl_dt              as Bl_Dt,
      zdt_lcbnk_ref.boe_no             as Boe_No,
      zdt_lcbnk_ref.boe_dt             as Boe_Dt,
      zdt_lcbnk_ref.boe_bank           as Boe_Bank,
      zdt_lcbnk_ref.meins              as Meins,
       @Semantics.quantity.unitOfMeasure : 'meins'
      zdt_lcbnk_ref.qty_recd           as Qty_Recd,
      zdt_lcbnk_ref.remarks            as Remarks,
      zdt_lcbnk_ref.locallastchangedat as Locallastchangedat,
      _head
}
