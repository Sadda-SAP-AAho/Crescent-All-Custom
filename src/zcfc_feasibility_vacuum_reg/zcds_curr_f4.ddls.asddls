@AbapCatalog.sqlViewName: 'ZCURRENCYF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Currency-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_CURR_F4
  as select from I_Currency
{

  key Currency

}
