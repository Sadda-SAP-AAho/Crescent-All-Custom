@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer Partner Function'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_CUSPARTFUNC
  as select distinct from I_CustSalesPartnerFunc
{
  key     Customer,
  key     SalesOrganization,
  key     DistributionChannel,
  key     Division,
  key     cast(PartnerCounter as abap.char( 3 ) ) as PartnerCounter,
  key     (case when PartnerFunction = 'AG' then 'Sold To Party'
                when PartnerFunction = 'RE' then 'Bill To Party'
                when PartnerFunction = 'RG' then 'Payer'
                when PartnerFunction = 'WE' then 'Ship To Party'
                else ''
           end)                                   as partner_func,
  key     BPCustomerNumber



}
