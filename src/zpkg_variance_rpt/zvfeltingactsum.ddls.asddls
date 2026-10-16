@AbapCatalog.sqlViewName: 'ZVFELFACTSUM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Felting ACT Sum'
@Metadata.ignorePropagatedAnnotations: true
define view ZVFELTINGACTSUM
  as select from ZVFELTINGACT
{
  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
      sum(AmountInCompanyCodeCurrency) as feltact
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
