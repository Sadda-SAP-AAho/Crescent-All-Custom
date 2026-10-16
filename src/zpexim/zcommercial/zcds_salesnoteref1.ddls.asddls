@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sales note ref using table function'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_SALESNOTEREF1 
as select from ZTBL_FUNC_SALENOTEREF
{
      key BillingDocument,
      Salesnoteref
}
