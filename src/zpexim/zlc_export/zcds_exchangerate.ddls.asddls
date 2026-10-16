@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for exchange rate'
define root view entity ZCDS_EXCHANGERATE as 
select distinct from I_ExchangeRateRawData // I_ExchangeRate
{
   
   key SourceCurrency,
       ExchangeRate,
//   ValidityStartDate
   dats_days_between( ValidityStartDate ,$session.system_date ) as difference
}
 where ExchangeRateType = 'M' and TargetCurrency = 'INR' 
// and ValidityStartDate >= $session.system_date
//  and CreationDat <= $parameters.dat
