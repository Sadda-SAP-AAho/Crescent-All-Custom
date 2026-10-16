@AbapCatalog.sqlViewName: 'Z_RESOURCE_F4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Resource-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_RESOURCE_F4
  as select from Z_I_Resource_Master as a
{
  key a.Plant,
  key a.Resource_code,
      a.Resource_name
}
