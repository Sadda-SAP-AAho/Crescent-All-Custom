@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Country of Destination'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_COD_F4
as select distinct from zdt_mcod_tmg //DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDM_CODE')
{
  //key value_position,
  //    @Semantics.language: true
  //key language,
  key codcode as value_low,
      @Semantics.text: true
  key codcodenam as text
}
