@AbapCatalog.sqlViewName: 'ZZVLABOURACTS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Labour Actual Sum'
@Metadata.ignorePropagatedAnnotations: true
define view ZVLABOURACTS
  as select from ZVLABOURACT
{

  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
      sum(AmountInCompanyCodeCurrency) as labour
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
