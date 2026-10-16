@AbapCatalog.sqlViewName: 'ZZVVMELT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Actual Melting loss'
@Metadata.ignorePropagatedAnnotations: true
define view ZVMELTINGSUM
  as select from ZVMELTINGLOSS
{
  key mmyyyy,
      prctrclub,
      CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( AmountInCompanyCodeCurrency ) as amt
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
