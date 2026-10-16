@AbapCatalog.sqlViewName: 'Z_WORKCODEF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Work Code-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_WORKCODE_F4 
  as select distinct from ZI_TmgTableForWorkCode as a
{
  key a.Workcode as Workcode
}
