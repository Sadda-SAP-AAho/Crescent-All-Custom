@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Management Dashboard-OTIF'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define view entity ZC_MGMTDASH_OTIF
  as select from ZI_MGMTDASH_OTIF
{

      @EndUserText.label: 'Profit Center Name'
      @Search.defaultSearchElement: true
  key ProfitCenterName,
      @EndUserText.label: 'Final OTIF'
      @Search.defaultSearchElement: true
      finalotif
      
}
