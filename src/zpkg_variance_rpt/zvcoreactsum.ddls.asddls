@AbapCatalog.sqlViewName: 'ZZVCOREACTS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Core Act sum'
@Metadata.ignorePropagatedAnnotations: true
define view ZVCOREACTSUM
  as select from ZVCOREACT
{

  key mmyyyy,
      prctrclub,
      CompanyCodeCurrency,
      sum(AmountInCompanyCodeCurrency) as core
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
