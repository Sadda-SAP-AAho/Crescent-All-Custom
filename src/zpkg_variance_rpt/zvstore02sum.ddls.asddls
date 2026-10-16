@AbapCatalog.sqlViewName: 'ZZVSTORE02'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Store 02 Sum'
@Metadata.ignorePropagatedAnnotations: true
define view ZVSTORE02SUM
  as select from ZVSTORE02
{
  key mmyyyy,
      prctrclub,
      CompanyCodeCurrency,
      sum(store ) as store
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
