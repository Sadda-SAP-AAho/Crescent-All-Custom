@AbapCatalog.sqlViewName: 'ZNONPO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'NONPO AND RGP'
define view ZI_NONPO
  as select from    I_ProductDescription as a
    left outer join I_Product            as b on b.Product = a.Product
{
  key a.Product,
      a.ProductDescription,
      b.BaseUnit

}
