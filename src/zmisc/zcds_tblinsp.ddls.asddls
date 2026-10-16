@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view fo fetching insp data'
@Metadata.ignorePropagatedAnnotations: true
@ClientHandling.type: #CLIENT_DEPENDENT
@AbapCatalog.sqlViewName: 'ZI_TBLINSP'
define view ZCDS_TBLINSP
  as select from ZTBL_FCTN_INSPECTIONQM
//                 (
//                 mandt : $session.client
//                 )
{
      key material,
      key plant,
      inspectionplan,
      inspectionplangroup,
      inspplanmatlassignment,
      inspplanmatlassgmtintversion
   
}
group by material,
   plant,
      inspectionplan,
      inspectionplangroup,
      inspplanmatlassignment,
      inspplanmatlassgmtintversion
   
