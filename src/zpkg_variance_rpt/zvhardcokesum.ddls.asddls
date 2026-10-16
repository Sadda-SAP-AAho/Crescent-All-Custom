@AbapCatalog.sqlViewName: 'ZVHARDCOKES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hard Coke'
@Metadata.ignorePropagatedAnnotations: true
define view ZVHARDCOKESUM
  as select from ZVHARDCOKEDI
{
  key mmyyyy,
      prctrclub,
      CompanyCodeCurrency,
      sum(hardcoke) as hardcoke
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
