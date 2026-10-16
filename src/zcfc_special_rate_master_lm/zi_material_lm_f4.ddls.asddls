@AbapCatalog.sqlViewName: 'Z_MATERIAL_LM_F4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CURRENCY-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_MATERIAL_LM_F4
 as select from I_Product as a
 left outer join I_ProductText as b on a.Product=b.Product
                          and  b.Language = 'E'
{
  key  a.Product,
       b.ProductName
}
where a.ProductGroup='Z021'
 