@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 for Container Size'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZI_CONSIZE_F4 
as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDM_CONSIZE')
{
  key value_position,
      @Semantics.language: true
  key language,
  key value_low,
      @Semantics.text: true
  key text
}
