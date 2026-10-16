@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LC Export Bank References'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zc_lcbnk_ref
  as projection on ZI_LCBNK_REF
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item3,
      @EndUserText.label: 'Bank Ref'
      Bank_Ref,
      @EndUserText.label: 'Bank Ref Dt.'
      Bank_Dt,
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
      @EndUserText.label: 'BOE BANK'
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
      _head : redirected to parent zc_lcexphead
}
