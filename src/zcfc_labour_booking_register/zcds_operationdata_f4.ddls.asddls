@AbapCatalog.sqlViewName: 'Z_OPERATIONDATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OPERATION-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_OPERATIONDATA_F4 
  as select from ZI_TmgTableForOperatio as a
{
    key a.Zopn as Oprcode,
        a.Zopd as Oprname
}
