@AbapCatalog.sqlViewName: 'Z_CURRENCY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CURRENCY-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_CURRENCY_F4 as select from I_Currency as a
{
    key a.Currency as Currency
}
