@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For PCR Booking Header'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define root view entity ZI_PCRHDR
  as select from zdt_pcr_hdr
  composition [0..*] of ZI_PCRITM  as _item
  composition [0..*] of ZI_PCRITM1 as _item1
  composition [0..*] of ZI_PCRITM2 as _item2
{
  key zdt_pcr_hdr.id            as Id,
      zdt_pcr_hdr.loanacno      as Loanacno,
      zdt_pcr_hdr.name          as Name,
      zdt_pcr_hdr.bookingdt     as Bookingdt,
      zdt_pcr_hdr.bankname      as Bankname,
      zdt_pcr_hdr.waers         as Waers,
      @Semantics.amount.currencyCode: 'Exchratecurr'
      zdt_pcr_hdr.exchangerate  as Exchangerate,
      zdt_pcr_hdr.exchangerate1 as Exchangerate1,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.bookamt       as Bookamt,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_pcr_hdr.balanceamt    as Balanceamt,
      zdt_pcr_hdr.duedt         as Duedt,
      zdt_pcr_hdr.extduedt      as Extduedt,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.intratesp     as Intratesp,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.intratelib    as Intratelib,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.amtusd        as Amtusd,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.rateusd       as Rateusd,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.amteuro       as Amteuro,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.rateuro       as Rateuro,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.nzdamt        as Nzdamt,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.ratenzd       as Ratenzd,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.amtgbp        as Amtgbp,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.rategbp       as Rategbp,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.amtcan        as Amtcan,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.ratecan       as Ratecan,
      zdt_pcr_hdr.cuscode       as Cuscode,
      zdt_pcr_hdr.loantype      as Loantype,
      zdt_pcr_hdr.basedoctype   as Basedoctype,
      @Semantics.amount.currencyCode: 'Currency'
      zdt_pcr_hdr.benchintrate  as Benchintrate,
      zdt_pcr_hdr.intdays       as Intdays,
      zdt_pcr_hdr.currency      as Currency,
      zdt_pcr_hdr.exchratecurr  as Exchratecurr,
      zdt_pcr_hdr.benchmarktype as Benchmarktype,
      zdt_pcr_hdr.interestdays  as Interestdays,
      cloanglacc                as Cloanglacc,
      cloanhousebank            as Cloanhousebank,
      cloanbankaccid            as Cloanbankaccid,
      dglbankacc                as Dglbankacc,
      dhousebank                as Dhousebank,
      dbankaccid                as Dbankaccid,
      accpost                   as Accpost,
      accountdocno              as Accountdocno,
      accountdocyr              as Accountdocyr,
      accpostref                as Accpostref,
      accpostdate               as Accpostdate,
      accdocdate                as Accdocdate,
      upd                       as Upd,

      _item,
      _item1,
      _item2
}
