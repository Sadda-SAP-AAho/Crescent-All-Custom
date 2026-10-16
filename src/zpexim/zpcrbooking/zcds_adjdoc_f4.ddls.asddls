@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Doc type F4 view help'
define view entity ZCDS_ADJDOC_F4 
as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDOM_ADJDOCTYPE')
{
  //key domain_name,
  key value_low
}
