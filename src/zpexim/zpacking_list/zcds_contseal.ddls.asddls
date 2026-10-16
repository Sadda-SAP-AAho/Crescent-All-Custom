@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'table function ZTBL_FCTN_CONTCARSEAL'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_CONTSEAL
  as select from 
   ZTBL_FCTN_CONTCARSEAL
//                 (
//                 mandt : $session.client
//                 )
{
  key billingdocument,
      contnos,
      carsealnos
}
