@AbapCatalog.sqlViewName: 'ZI_OPERATIONF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Operation-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_OPERATION as select from ZI_TmgTableForOperatio as a
{
    key a.Zopn as Oprcode,
        a.Zopd as Oprname    
}
