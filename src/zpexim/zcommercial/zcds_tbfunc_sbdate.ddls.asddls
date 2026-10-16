@EndUserText.label: 'multiple shipping bill no & date'
@Metadata.ignorePropagatedAnnotations: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZCDS_TBFUNC_SBDATE 
as select from ZTBL_FUNC_SBNOSBDATE
//                 (
//                 mandt : $session.client
//                 )
{
      key comminv,
      zsbnosbdate
}
