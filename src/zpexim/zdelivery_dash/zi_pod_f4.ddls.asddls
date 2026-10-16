@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Port of Destination'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_POD_F4 
as select distinct from zdt_mpod_tmg //DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDM_POD')
{
  // key value_position,
  //    @Semantics.language: true
  // key language,
  key podcode as value_low,
      @Semantics.text: true
  key podcodename as text
}
