@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interest Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVINTRPT_V0

  as select from ZI_PCRHDR    as a

    inner join   ZR_INTCAL_HD as c on c.loanacno = a.Loanacno

    inner join   ZR_INTCAL_IT as d on d.Id = c.id

{

  key a.Id                                                                      as LoanID,
  key c.id                                                                      as RateID,
  key d.Item                                                                    as RateItem,

      //Loan Specific Details
      a.Loanacno                                                                as LoanAccountNo,
      a.Name,
      a.Bankname                                                                as BankName,
      a.Bookingdt                                                               as LoanBookingDate,
      a.Waers                                                                   as Currency,
      a.Exchangerate1                                                           as ExchangeRate,
      cast( a.Bookamt as abap.dec(31,2) )                                       as LoanBookingAmount,
      a.Duedt                                                                   as DueDate,
      a.Extduedt                                                                as ExtendedDueDate,
      a.Benchmarktype                                                           as BenchMarkType,
      cast( a.Benchintrate as abap.dec(9,5) )                                   as BenchInterestRate,
      cast( a.Intratesp  as abap.dec(9,5) )                                     as SpreadRate,
      a.Loantype                                                                as LoanType,
      a.Interestdays                                                            as LoanTenure,
      cast( a.Benchintrate + a.Intratesp as abap.dec(9,5) )                     as TotalInterest,

      //Loan Interest Cockpit
      c.ineterestref                                                            as InterestReference,
      d.invno                                                                   as InvoiceNo,
      d.invdt                                                                   as InvoiceDate,
      case when a.Bookingdt > c.startdate then a.Bookingdt else c.startdate end as InterestBookingStartDate,

      case when a.Extduedt is not initial then
      case when a.Extduedt < c.enddate then a.Extduedt else c.enddate end
           when a.Duedt is not initial then
      case when a.Duedt < c.enddate then a.Duedt else c.enddate end
      else c.enddate end                                                        as InterestBookingEndDate,
      c.housebankid                                                             as HouseBankID,
      c.accountid                                                               as AccountID,
      c.exchangerate                                                            as BookingExchangeRate,
      c.bankgl                                                                  as BankBookingGL,
      c.interestgl                                                              as InterestBookingGL,
      c.costcenter                                                              as CostCenter,
      d.Bookingdt                                                               as EffectiveBookingDate,
      c.penalty                                                                 as PenaltyCC,
      c.penaltyfc                                                               as PenaltyFC,
      c.postingdate                                                             as PostingDate,
      c.documentdate                                                            as DocumentDate,
      c.fullcalc                                                                as FullMonthCalculationIndicator,
      d.zdays                                                                   as PayableDays,
      cast(d.Bookamt as abap.dec(31,2) )                                        as BookAmount,
      cast(d.Balanceamt  as abap.dec(31,2) )                                    as BalanceAmount,
      cast(d.Calcinterest  as abap.dec(31,2) )                                  as CalculatedInterestDC,
      cast(d.Postableinterest as abap.dec(31,2) )                               as PostableInterestFC,
      cast(d.postableinterestinr  as abap.dec(31,2) )                           as PostableInterestCC,
      cast(d.Effectiveintrate as abap.dec(9,5) )                                as InterestRate

}
