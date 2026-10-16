@AbapCatalog.sqlViewName: 'ZPRODUCTF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product List-F4'
@Metadata.ignorePropagatedAnnotations: true

define view ZCDS_PRODUCT_F4
  as select from    I_Product           as a
    left outer join I_ProductPlantBasic as b on a.Product = b.Product
    left outer join I_ProductText       as c on a.Product = c.Product
{

  key a.Product      as Prodcode,
  key a.ProductGroup as Matgrpcode,
  key b.Plant        as Plantcode,
      c.ProductName  as Prodname

}
