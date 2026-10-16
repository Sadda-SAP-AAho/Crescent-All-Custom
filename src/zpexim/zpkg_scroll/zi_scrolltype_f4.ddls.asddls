@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Scroll Type F4'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SCROLLTYPE_F4

  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDO_SCROLLTYPE')

{
      @EndUserText.label: 'Scroll Type'
  key value_low as ScrollType,

      @EndUserText.label: 'Description'
      @Semantics.text: true
      text

}
