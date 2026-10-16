@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Core Information F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CORE_INFO_F4 
as select distinct from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDM_CORE_INFO')
{
  key value_position,
      @Semantics.language: true
  key language,
  key value_low,
      @Semantics.text: true
  key text
}
