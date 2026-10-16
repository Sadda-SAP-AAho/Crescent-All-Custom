@AbapCatalog.sqlViewName: 'ZPAINTITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Paint Item-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PAINTITEM_F4
  as select distinct from I_Product     as a
    left outer join       I_ProductText as b on  a.Product  = b.Product
                                             and b.Language = 'E'
{
  key a.Product,
      b.ProductName
}

where
  a.ProductGroup = 'Z020'
