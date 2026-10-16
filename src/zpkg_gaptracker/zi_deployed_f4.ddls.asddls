@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Deployed Status F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DEPLOYED_F4 
as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_DEPLOYED')
{
 // key domain_name,
  key value_position,
      @Semantics.language: true
  key language,
      value_low,
      @Semantics.text: true
      text
}
