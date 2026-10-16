@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interest Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Metadata.allowExtensions: true
define root view entity ZRINTRPT_TP

  as select from ZVINTRPT_V0

{
      @EndUserText.label: 'Loan Unique ID'
  key LoanID,
      @EndUserText.label: 'Rate Calc ID'
  key RateID,
      @EndUserText.label: 'Rate Calc Item'
  key RateItem,
      @EndUserText.label: 'Loan Account No.'
      LoanAccountNo,
      @EndUserText.label: 'Name'
      Name,
      @EndUserText.label: 'Bank Name'
      BankName,
      @EndUserText.label: 'Loan Booking Date'
      LoanBookingDate,
      @EndUserText.label: 'Loan Currency'
      Currency,
      @EndUserText.label: 'Exchange Rate'
      ExchangeRate,
      @EndUserText.label: 'Loan Booking Amount'
      LoanBookingAmount,
      @EndUserText.label: 'Due Date'
      DueDate,
      @EndUserText.label: 'Extended Due Date'
      ExtendedDueDate,
      @EndUserText.label: 'Bench Mark Type'
      BenchMarkType,
      @EndUserText.label: 'Bench Interest Rate'
      BenchInterestRate,
      @EndUserText.label: 'Spread Interest Rate'
      SpreadRate,
      @EndUserText.label: 'Loan Type'
      LoanType,
      @EndUserText.label: 'Loan Tenure(in Days)'
      LoanTenure,
      @EndUserText.label: 'Total Interest'
      TotalInterest,
      @EndUserText.label: 'Interest Reference'
      InterestReference,
      @EndUserText.label: 'Invoice No.'
      InvoiceNo,
      @EndUserText.label: 'Invoice Date'
      InvoiceDate,
      @EndUserText.label: 'Interest Booking Start Date'
      InterestBookingStartDate,
      @EndUserText.label: 'Interest Booking End Date'
      InterestBookingEndDate,
      @EndUserText.label: 'House Bank ID'
      HouseBankID,
      @EndUserText.label: 'Account ID'
      AccountID,
      @EndUserText.label: 'Booking Exchange Rate'
      BookingExchangeRate,
      @EndUserText.label: 'Bank Booking GL'
      BankBookingGL,
      @EndUserText.label: 'Interest Booking GL'
      InterestBookingGL,
      @EndUserText.label: 'Cost Center'
      CostCenter,
      @EndUserText.label: 'Effective Booking Date'
      EffectiveBookingDate,
      @EndUserText.label: 'Penalty(CC)'
      PenaltyCC,
      @EndUserText.label: 'Penalty(FC)'
      PenaltyFC,
      @EndUserText.label: 'Posting Date'
      PostingDate,
      @EndUserText.label: 'Document Date'
      DocumentDate,
      @EndUserText.label: 'Full Month Calc. Indicator'
      FullMonthCalculationIndicator,
      @EndUserText.label: 'Payable Days'
      PayableDays,
      @EndUserText.label: 'Booking Amount(TC)'
      BookAmount,
      @EndUserText.label: 'Balance Amount(TC)'
      BalanceAmount,
      @EndUserText.label: 'Calculated Interest(DC)'
      CalculatedInterestDC,
      @EndUserText.label: 'Postable Interest(FC)'
      PostableInterestFC,
      @EndUserText.label: 'Postable Interest(CC)'
      PostableInterestCC,
      @EndUserText.label: 'Interest Rate'
      InterestRate
}
