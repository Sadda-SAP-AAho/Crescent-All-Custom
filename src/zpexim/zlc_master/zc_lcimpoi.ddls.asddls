@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumption View for LC Import PO Item'
// @Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zc_lcimpoi 
  as projection on zi_lcimpoi
{
    @EndUserText.label: 'ID'
    key Id,
    @EndUserText.label: 'Item'
    key Item2,
    @EndUserText.label: 'Purchasing Doc.'
    Ebeln,
    @EndUserText.label: 'Display'
    Display,
    @EndUserText.label: 'Currency'
    Waers,
    @Semantics.amount.currencyCode : 'WAERS'
    @EndUserText.label: 'Net Value'
    Netwr,
    @Semantics.amount.currencyCode : 'WAERS'
    @EndUserText.label: 'Available Amount'
    Avail_Amount,
    @Semantics.amount.currencyCode : 'WAERS'
    @EndUserText.label: 'Applied Amount in This LC'
    Appl_Amt_Lc,
    @Semantics.amount.currencyCode : 'WAERS'
    @EndUserText.label: 'Applied Amount in Othr LC'
    Appl_Amt_Othlc,
    @EndUserText.label: 'Unit'
    Meins,
    @Semantics.quantity.unitOfMeasure : 'MEINS'
    @EndUserText.label: 'Applied Qty'
    Appl_Qty,
    @EndUserText.label: 'Item Level'
    Amount_Level,
    @EndUserText.label: 'Details'
    Detail,
         Locallastchangedat,
    /* Associations */
    _head : redirected to parent zc_lchead
}
