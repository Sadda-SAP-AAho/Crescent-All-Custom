@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interest Calc. Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define view entity ZC_INTCAL_IT

  as projection on ZR_INTCAL_IT

{

      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'Item'
  key Item,
      @EndUserText.label: 'Loan Account No.'
      Loanacno,
      @EndUserText.label: 'Loan Booking Date'
      Bookingdt,
      @EndUserText.label: 'Bank Name'
      Bankname,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Loan Type'
      Loantype,
      @EndUserText.label: 'Due Date'
      Duedt,
      @EndUserText.label: 'Interest Posted Upto'
      newduedt,      
      @EndUserText.label: 'Invoice No.'
      invno,
      @EndUserText.label: 'Invoice Date'
      invdt,      
      @EndUserText.label: 'Days'
      zdays,
      @EndUserText.label: 'Booking Amount'
      @Semantics.amount.currencyCode : 'Currency'
      Bookamt,
      @EndUserText.label: 'Balance Amount'
      @Semantics.amount.currencyCode : 'Currency'
      Balanceamt,
      @EndUserText.label: 'Amount'
      @Semantics.amount.currencyCode : 'Currency'
      Amount,
      @EndUserText.label: 'Interest Rate Spread'
      Intratesp,
      @EndUserText.label: 'Bench Mark Rate'
      Benchintrate,
      @EndUserText.label: 'Bench Mark Type'
      Benchmarktype,
      @EndUserText.label: 'SOFR/EURO Rate'
      Sofr,
      @EndUserText.label: 'Effective Interest Rate'
      Effectiveintrate,
      @EndUserText.label: 'Calculated Interest'
      @Semantics.amount.currencyCode : 'Currency'
      Calcinterest,
      @EndUserText.label: 'Postable Interest'
      @Semantics.amount.currencyCode : 'Currency'
      Postableinterest,
      @EndUserText.label: 'Postable Interest(INR)'
      postableinterestinr,
      @EndUserText.label: 'Full Calculation'
      fullcalc,

      /* Associations */
      _head : redirected to parent ZC_INTCAL_HD

}
