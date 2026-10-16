@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Special Price Misc Rate Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE

define root view entity ZC_SPPRMSWRKRATE
  provider contract transactional_query
  as projection on ZI_SPPRMSWRKRATE
{
      @UI.hidden: true
  key Id,
      @UI.hidden: true
  key Item,
      @EndUserText.label: 'Plant Code'
      Plantcode,
      @EndUserText.label: 'Plant Name'
      Plantname,
      @EndUserText.label: 'Work Code'
      Workcode,
      @EndUserText.label: 'Work Name'
      Workname,
      @EndUserText.label: 'Date Form'
      Datefrom,
      @EndUserText.label: 'Date To'
      Dateto,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'Rate'
      Rate
}
