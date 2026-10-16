@AbapCatalog.sqlViewName: 'ZLEADCODEF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lead Code-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_LEADCODE
  as select from ZI_LEADMASTER
{

  key Leadcode,
      Leadname,
      Salesperson
}
