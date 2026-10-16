@AbapCatalog.sqlViewName: 'Z_CURR_F4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CURRENCY-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_CURR_F4
 as select from I_Currency as a
{
    key a.Currency as Currency
}
