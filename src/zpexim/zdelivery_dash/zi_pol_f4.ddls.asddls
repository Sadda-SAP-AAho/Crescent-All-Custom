@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Port of Loading'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_POL_F4 
as select distinct from zdt_mpol_tmg //DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDE_POL')
{
  //key value_position,
  //    @Semantics.language: true
  //key language,
  key polcode as value_low,
      @Semantics.text: true
  key polcodename as text
}
