@AbapCatalog.sqlViewName: 'Z_PWRHEAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sub Head Code F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_SUBHDCD_F4 as select distinct from zdt_powerhead
{
    key subheadcd,
    key subheadnm,
    key headcd,
    key headnm,
    key metertyp
    
}
