@AbapCatalog.sqlViewName: 'Z_LOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'LOCATION F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_LOCATION_F4 as select distinct from zdt_location
{
    key loctncd,
    key loctnnam
        
}
