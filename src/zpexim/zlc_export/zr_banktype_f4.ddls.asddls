@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Bank Type F4'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_BANKTYPE_F4 
as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDOM_BNKTYPE')
{
  key  text as PriorityDesc
}
