@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Address Type'
define view entity ZI_EXIMCOMMADDRTYPE

  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDO_EXIMADDRTYPE')
{
      @EndUserText.label: 'Address Type'
  key value_low,
      @EndUserText.label: 'Description'
      @Semantics.text: true
      text
}

where
  language = $session.system_language
