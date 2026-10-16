@AbapCatalog.sqlViewName: 'ZZVMETINGSUM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Meating Labour Sum'
@Metadata.ignorePropagatedAnnotations: true
define view ZMETACTSUM
  as select from ZVMELTINGACT
{
  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
      sum( AmountInCompanyCodeCurrency ) as meting
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
