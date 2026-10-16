@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for LC Bank References'
// @Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zc_lcbank_ref
  as projection on zi_lcbank_ref
{
    @EndUserText.label: 'ID'
    key Id,
    @EndUserText.label: 'Item'
    key Item3,
    @EndUserText.label: 'Bank Ref'
    bank_ref,
    @EndUserText.label: 'Bank Ref Dt.'
    bank_dt,
    @EndUserText.label: 'Shipment Dt.'
    Ship_Dt,
    @EndUserText.label: 'Due Date'
    Due_Date,
    @EndUserText.label: 'Invoice No.'
    Inv_No,
    @EndUserText.label: 'Currency'
    Waers,
    @Semantics.amount.currencyCode : 'WAERS'
    @EndUserText.label: 'Gross Amt'
    Rmwwr,
    @EndUserText.label: 'B/L No.'
    Bl_No,
    @EndUserText.label: 'B/L Dt.'
    Bl_Dt,
    @EndUserText.label: 'BOE No.'
    Boe_No,
    @EndUserText.label: 'BOE Dt.'
    Boe_Dt,
    @EndUserText.label: 'BOESInBANK'
    Boe_Bank,
    @EndUserText.label: 'Unit'
    Meins,
    @Semantics.quantity.unitOfMeasure : 'MEINS'
    @EndUserText.label: 'Qty Recd'
    Qty_Recd,
    @EndUserText.label: 'Remarks'
    Remarks,
         Locallastchangedat,
    /* Associations */
    _head : redirected to parent zc_lchead
}
