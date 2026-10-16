@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FOREX Maturity Alert'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_FOREX_MATURITY_ALRT
  provider contract transactional_query
  as projection on ZI_FOREX_MATURITY_ALRT
{
      @UI.hidden: true
  key Id,
      @EndUserText.label: 'Status'
  key status,
      @EndUserText.label: 'Contract No'
  key cntct_no,
      @EndUserText.label: 'Bank Name'
      bnk_nm,
      @EndUserText.label: 'Currency'
      curr,
      @EndUserText.label: 'Balance Amount'
      bal_amt,
      @EndUserText.label: 'Mature Date'
      mature_dt

}
