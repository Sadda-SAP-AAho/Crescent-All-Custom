@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 For Cost Center Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CCTYPE_F4 
as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZMM_CCTYPE')
{
  key value_position,
      @Semantics.language: true
  key language,
  key value_low,
      @Semantics.text: true
  key text
}
