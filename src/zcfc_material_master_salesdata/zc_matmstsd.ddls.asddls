@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Master SD'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_MATMSTSD
  provider contract transactional_query
  as projection on ZI_MATMSTSD
{
      @EndUserText.label: 'Material Code'
      @Search.defaultSearchElement: true
  key MatCode,
      @EndUserText.label: 'Material Name'
  key MatName,
      @EndUserText.label: 'Plant'
  key Plant,
      @EndUserText.label: 'Sales Organisation'
      ProductSalesOrg,
      @EndUserText.label: 'Division'
      Division,
      @EndUserText.label: 'Product Distribution Channel'
      ProductDistributionChnl
}
