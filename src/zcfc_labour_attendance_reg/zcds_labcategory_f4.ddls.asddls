@AbapCatalog.sqlViewName: 'Z_LABCATEGORY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LABCATEGORY-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_LABCATEGORY_F4 as select from ZI_TmgTableLabourCateg as a
{
    key a.Catname as Catname
}
