@AbapCatalog.sqlViewName: 'ZNONPOF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'NONPO AND RGP f4'
define view ZI_NONPOF4
  as select from ZI_NONPO
{
  key Product,
      ProductDescription,
      BaseUnit
}
