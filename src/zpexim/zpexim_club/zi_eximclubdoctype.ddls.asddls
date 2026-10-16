@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'EXIM Clubbing Doc. Type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_EXIMCLUBDOCTYPE

  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDO_DOCUMENTTYPE')
{
      @EndUserText.label: 'Document Type'
  key value_low,
      @EndUserText.label: 'Description'
      @Semantics.text: true
      text
}

where
  language = $session.system_language
