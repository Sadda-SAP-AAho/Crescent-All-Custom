@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Master SD'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_MATMASTSD
  provider contract transactional_query
  as projection on ZI_MATMASTSD
{
    key MatCode,
    key MatName,
     key Plant,
    ProductSalesOrg,
    Division,
    ProductDistributionChnl
}
