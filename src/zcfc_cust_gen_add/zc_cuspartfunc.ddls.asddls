@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer General Address'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_CUSPARTFUNC
  provider contract transactional_query
  as projection on ZI_CUSPARTFUNC
{
      @EndUserText.label: 'Customer'
      @Search.defaultSearchElement: true
  key Customer,
      @EndUserText.label: 'Sales Organization'
  key SalesOrganization,
      @EndUserText.label: 'Distributional Channel'
  key DistributionChannel,
      @EndUserText.label: 'Division'
  key Division,
      @EndUserText.label: 'Partner Counter'
  key PartnerCounter,
      @EndUserText.label: 'Partner Function'
  key partner_func,
      @EndUserText.label: 'BP Customer Number'
  key BPCustomerNumber
}
