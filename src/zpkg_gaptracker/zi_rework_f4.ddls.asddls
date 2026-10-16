@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Rework'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_REWORK_F4 
as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_REWORK')
{
  key value_position,
      @Semantics.language: true
  key language,
      value_low,
      @Semantics.text: true
      text
}
