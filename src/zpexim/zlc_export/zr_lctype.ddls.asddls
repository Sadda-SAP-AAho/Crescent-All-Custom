@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for LC Type F4'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_LCTYPE 
as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDOM_LCTYPE')
{
  //key domain_name,
  key value_low,
  key text as PriorityDesc
}
