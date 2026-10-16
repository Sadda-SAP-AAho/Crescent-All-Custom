@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Entity View for LC Bank References'
@Metadata.allowExtensions: true
define view entity zi_lcbank_ref 
as select from zdt_lcbank_ref
association to parent zi_lchead as _head on $projection.Id = _head.Id

{
    key zdt_lcbank_ref.id as Id,
    key zdt_lcbank_ref.item3 as Item3,
    zdt_lcbank_ref.bank_ref as bank_ref,
    zdt_lcbank_ref.bank_dt as bank_dt,
    zdt_lcbank_ref.ship_dt as Ship_Dt,
    zdt_lcbank_ref.due_date as Due_Date,
    zdt_lcbank_ref.inv_no as Inv_No,
    zdt_lcbank_ref.waers as Waers,
    @Semantics.amount.currencyCode : 'WAERS'
    zdt_lcbank_ref.rmwwr as Rmwwr,
    zdt_lcbank_ref.bl_no as Bl_No,
    zdt_lcbank_ref.bl_dt as Bl_Dt,
    zdt_lcbank_ref.boe_no as Boe_No,
    zdt_lcbank_ref.boe_dt as Boe_Dt,
    zdt_lcbank_ref.boe_bank as Boe_Bank,
    zdt_lcbank_ref.meins as Meins,
    @Semantics.quantity.unitOfMeasure : 'meins'
    zdt_lcbank_ref.qty_recd as Qty_Recd,
    zdt_lcbank_ref.remarks as Remarks,
    zdt_lcbank_ref.locallastchangedat as Locallastchangedat,
    _head
}
