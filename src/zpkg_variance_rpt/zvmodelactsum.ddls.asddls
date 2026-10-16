@AbapCatalog.sqlViewName: 'ZVMODELACSUM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Modelling Sum'
@Metadata.ignorePropagatedAnnotations: true
define view ZVMODELACTSUM
  as select from ZVMODELACT
{
  key mmyyyy,
      CompanyCodeCurrency,
      prctrclub,
      sum(AmountInCompanyCodeCurrency ) as model
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
