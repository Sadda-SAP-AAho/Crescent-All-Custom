@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for lc'
@Metadata.ignorePropagatedAnnotations: true
@ClientHandling.type: #CLIENT_DEPENDENT
@AbapCatalog.sqlViewName: 'ZI_LC'
define view ZCDS_LCSORTED
  as select from ZTBL_FCTN_LCDETAILS
{
 key BillingDocument,
 Lc_Refnr,
 Version,
 Lc_Appl,
 Lc_Open_Dt,
 Banka
}
