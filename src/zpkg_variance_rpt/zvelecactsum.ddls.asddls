@AbapCatalog.sqlViewName: 'ZVELECACTS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ELECTRICITY ACT SUM'
@Metadata.ignorePropagatedAnnotations: true
define view ZVELECACTSUM
  as select from ZVELECTRICITYACT
{
  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
      sum(AmountInCompanyCodeCurrency) as elecact
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
