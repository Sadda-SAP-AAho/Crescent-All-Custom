@AbapCatalog.sqlViewName: 'ZVPAINTACTS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Painting Sum ACT'
@Metadata.ignorePropagatedAnnotations: true
define view ZVPAINTACTSUM
  as select from ZVPAINTINGACT
{
  key mmyyyy,
      prctrclub,
      CompanyCodeCurrency,
      sum( AmountInCompanyCodeCurrency ) as amt
}
group by
  mmyyyy,
  prctrclub,
  CompanyCodeCurrency
