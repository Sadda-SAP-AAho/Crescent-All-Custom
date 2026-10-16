@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interest Calc. Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_INTCAL_IT

  as select from zdt_intcal_it

  association to parent ZR_INTCAL_HD as _head on $projection.Id = _head.id

{

  key id               as Id,
  key item             as Item,
      loanacno         as Loanacno,
      bookingdt        as Bookingdt,
      bankname         as Bankname,
      currency         as Currency,
      loantype         as Loantype,
      duedt            as Duedt,
      invno,
      invdt,
      newduedt,
      zdays,
      @Semantics.amount.currencyCode : 'Currency'
      bookamt          as Bookamt,
      @Semantics.amount.currencyCode : 'Currency'
      balanceamt       as Balanceamt,
      @Semantics.amount.currencyCode : 'Currency'
      amount           as Amount,
      intratesp        as Intratesp,
      benchintrate     as Benchintrate,
      benchmarktype    as Benchmarktype,
      sofr             as Sofr,
      effectiveintrate as Effectiveintrate,
      @Semantics.amount.currencyCode : 'Currency'
      calcinterest     as Calcinterest,
      @Semantics.amount.currencyCode : 'Currency'
      postableinterest as Postableinterest,
      postableinterestinr,
      fullcalc,

      _head
}
