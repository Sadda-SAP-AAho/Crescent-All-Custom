@AbapCatalog.sqlViewName: 'ZSQLVN1'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Plant Description'
@AbapCatalog.preserveKey: true
define view ZCDS_PLANTDESC as select from zdt_mm_plantdes
{
    key plant as Plant,
    plantdes as Description
}
