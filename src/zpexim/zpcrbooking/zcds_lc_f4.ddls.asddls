@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 view help for LC'
@AbapCatalog.sqlViewName: 'ZCDS_LC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
define view ZCDS_LC_F4 as select 
distinct from ZI_LCEXPHEAD
{
    key Lc_Appl
}
where Lc_Appl is not initial
