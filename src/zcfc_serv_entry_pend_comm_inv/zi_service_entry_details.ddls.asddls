@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Service Entry Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SERVICE_ENTRY_DETAILS
  as select distinct from I_BillingDocument as a
    left outer join       ZI_SHPEXPRPT      as b on a.BillingDocument = b.Commid
{
  key a.BillingDocument,
      ( case when a.BillingDocument = b.Commid then 'Y' else 'X' end ) as status
}
