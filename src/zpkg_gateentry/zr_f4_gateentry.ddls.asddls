@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate entry F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_F4_GATEENTRY   
as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDO_WEIGHBRIDGE')
{
      @EndUserText.label: 'Gate Pass Type'
  key value_low,
      @EndUserText.label: 'Description'
      @Semantics.text: true
      text
}
