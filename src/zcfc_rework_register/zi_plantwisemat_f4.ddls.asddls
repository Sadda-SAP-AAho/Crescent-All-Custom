@AbapCatalog.sqlViewName: 'Z_PLNTWISEMAT_F4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant_Mat-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PLANTWISEMAT_f4
  as select from    I_ProductPlantBasic as a
    left outer join I_ProductText       as b on  a.Product  = b.Product
                                             and b.Language = 'E'
{
  key a.Plant,
  key a.Product,
      b.ProductName

}
