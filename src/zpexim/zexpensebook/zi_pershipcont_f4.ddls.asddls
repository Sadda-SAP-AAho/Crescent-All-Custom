@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Per Shipment & Container'
@Metadata.ignorePropagatedAnnotations: true
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define root view entity ZI_PERSHIPCONT_F4 
 as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDO_PERCONTSHIP')
{
    
  key value_position,
      @Semantics.language: true
  key language,
  key value_low,
      @Semantics.text: true
  key text
}
