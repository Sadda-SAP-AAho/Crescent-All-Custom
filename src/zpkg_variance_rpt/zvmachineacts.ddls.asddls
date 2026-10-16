@AbapCatalog.sqlViewName: 'ZZVMACHACTSUM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Machine sum'
@Metadata.ignorePropagatedAnnotations: true
define view ZVMACHINEACTS
  as select from ZVMACHINEACT
{
  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
      sum(AmountInCompanyCodeCurrency) as machine
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
