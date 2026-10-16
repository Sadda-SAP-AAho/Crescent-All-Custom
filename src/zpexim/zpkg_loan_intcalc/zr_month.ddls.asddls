@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Month'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_MONTH

  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDO_MONTH')

{
      @EndUserText.label: 'Month ID'
  key value_low as TMonth,
      @EndUserText.label: 'Month Name'
  key text      as TMonthDesc
}
