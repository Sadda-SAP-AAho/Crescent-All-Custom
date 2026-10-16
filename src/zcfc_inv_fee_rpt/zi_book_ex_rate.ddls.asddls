@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Date Exch. Rate'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_BOOK_EX_RATE
  as select distinct from Z_I_BOOK_EX_RATE       as a
    left outer join       ZTBL_FCTN_BKNG_EX_RATE as b on  a.SourceCurrency    = b.SourceCurrency
                                                      and a.TargetCurrency    = b.TargetCurrency
                                                      and a.ValidityStartDate = b.ValidityStartDate
{
  key b.compcode,
  key b.fy,
  key b.jeno,
  key a.ExchangeRateType,
  key b.SourceCurrency,
  key b.TargetCurrency,
  key b.ValidityStartDate,
      a.ExchangeRate

}

where a.ExchangeRate > 0
