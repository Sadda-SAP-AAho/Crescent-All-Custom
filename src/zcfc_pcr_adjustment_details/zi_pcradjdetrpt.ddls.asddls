@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for PCR Adj. Details Rpt'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PCRADJDETRPT
  as select from    ZI_PCRHDR as a
    left outer join ZI_PCRITM as b on a.Id = b.Id

{
  key a.Id,
  key b.Item,
      a.Loanacno,
      a.Bookingdt,
      a.Waers,
      a.Currency,
      @Semantics.amount.currencyCode: 'Currency'
      a.Bookamt,
      @Semantics.amount.currencyCode: 'Waers'
      a.Balanceamt,
      a.Exchangerate1,
      a.Bankname,
      b.Adjustdoctype,
      b.Invno,
      b.Invdt,
      b.Instructdt,
      @Semantics.amount.currencyCode: 'Waers'
      b.Adjamt,
      b.Othertext
}
