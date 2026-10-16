@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Container Pickup'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZI_CONTPICK_F4
  as select distinct from zdt_mpol_tmg //DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDM_CONTPICKFROM')
{
      //key value_position,
      //    @Semantics.language: true
      //key language,
  key polcode     as value_low,
      @Semantics.text: true
  key polcodename as text
}

where
     polcode = 'KOL'
  or polcode = 'HAL'
