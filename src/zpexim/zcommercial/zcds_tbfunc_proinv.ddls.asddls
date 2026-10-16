@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'comma separated proforma invoices'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_TBFUNC_PROINV 
  as select from ZTBL_FUNC_PROFORMA
//                 (
//                 mandt : $session.client
//                 )
{
      key comminv,
      proinv
}
