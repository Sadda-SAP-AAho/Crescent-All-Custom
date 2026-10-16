@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for ecxhange rate'
define view entity ZCDS_EXCHRATE1 
as select distinct 
 from ZCDS_EXCHANGERATE
{
   
   key SourceCurrency,
   ExchangeRate,
   difference
//   ValidityStartDate,
//   min( difference ) as min_diff

}
group by ExchangeRate,SourceCurrency,difference
