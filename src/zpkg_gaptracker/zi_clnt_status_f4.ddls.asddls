@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Client Status F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CLNT_STATUS_F4 
as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_CLNT_TESTING_STATUS')
{
 //key domain_name,
  key value_position,
      @Semantics.language: true
  key language,
      value_low,
      @Semantics.text: true
      text as ClntStatusDesc
}
