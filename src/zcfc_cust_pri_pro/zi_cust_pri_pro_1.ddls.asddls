@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Customer Partner Function'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUST_PRI_PRO_1
  as select from I_CustSalesPartnerFunc
{
  key Customer,
  key SalesOrganization,
  key DistributionChannel,
  key Division,
  key PartnerFunction,

  key PartnerCounter,
      BPCustomerNumber
}
where
  PartnerFunction = 'RE'

union select from I_CustSalesPartnerFunc
{
  key Customer,
  key SalesOrganization,
  key DistributionChannel,
  key Division,
  key PartnerFunction,

  key PartnerCounter,
      BPCustomerNumber
}
where
  PartnerFunction = 'WE'
