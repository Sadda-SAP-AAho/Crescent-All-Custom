@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Export LC Item'
@Metadata.allowExtensions: true
define view entity zc_lcexpitm
  as projection on ZI_LCEXPITM
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item2,
      @EndUserText.label: 'Sales Doc.'
      Vbeln,
      @EndUserText.label: 'Display'
      Display,
      @EndUserText.label: 'Currency'
      @Consumption.valueHelpDefinition: [ {
         entity: {
           name: 'I_Currency',
           element: 'Currency'
         }
       } ]
      Waers,
      @Semantics.amount.currencyCode : 'WAERS'
      @EndUserText.label: 'Net Value'
      Netwr,
      //    @Semantics.amount.currencyCode : 'WAERS'
      //    @EndUserText.label: 'Remaining LC Amount'
      //    Avail_Amount,
      @Semantics.amount.currencyCode : 'Applcurr'
      @EndUserText.label: 'Applied Amount in This LC'
      Appl_Amt_Lc,
      @Semantics.amount.currencyCode : 'WAERS'
      @EndUserText.label: 'Applied Amount in Othr LC'
      Appl_Amt_Othlc,
      @EndUserText.label: 'Unit'
      @Semantics.unitOfMeasure: true
      Meins,
      @Semantics.quantity.unitOfMeasure : 'MEINS'
      @EndUserText.label: 'Applied Qty'
      Appl_Qty,
      @EndUserText.label: 'Item Level'
      Amount_Level,
      @EndUserText.label: 'Remarks'
      Detail,
      @Semantics.amount.currencyCode : 'WAERS'
      @EndUserText.label: 'Base Price'
      Baseamt,
      @EndUserText.label: 'Delivery No'
      Delivery,
      Applcurr,
      Locallastchangedat,
      
      /* Associations */
      _head : redirected to parent zc_lcexphead
}
