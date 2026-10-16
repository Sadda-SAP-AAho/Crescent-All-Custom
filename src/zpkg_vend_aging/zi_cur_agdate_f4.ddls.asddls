@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aging Date'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CUR_AGDATE_F4
 as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDM_AGDATE_VA')
{
      @EndUserText.label: 'Currency Key'
  key value_low,
      @Semantics.text: true
      @EndUserText.label: 'Currency Desc'
  key text
}
