@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Date Exch. Rate'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_I_BOOK_EX_RATE
  as select distinct from I_ExchangeRateRawData
{
  key ExchangeRateType,
  key SourceCurrency,
  key TargetCurrency,
  key ValidityStartDate,
      ExchangeRate

}
