@AbapCatalog.sqlViewName: 'Z_POWERHEAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sub Head Code-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_SUBHEADCD_F4 as select from zdt_pwrhdmaster
{
    key subheadcd,
    key subheadnm,
    key headcd,
    key headnm,
    key metertyp
    
}
