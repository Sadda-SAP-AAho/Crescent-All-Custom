@AbapCatalog.sqlViewName: 'ZZVSTORE01SUM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Store 01 Sum'
@Metadata.ignorePropagatedAnnotations: true
define view ZVSTORE01SUM
  as select from ZVSTORECOST01
{
  key mmyyyy,
      prctrclub,
      CompanyCodeCurrency,
      sum(AmountInCompanyCodeCurrency) as store
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
