@AbapCatalog.sqlViewName: 'ZVSTOREACT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Store Cost Actual'
@Metadata.ignorePropagatedAnnotations: true
define view ZVSTORECOSTACT
  as select from ZVSTORE01SUM as a
  //    left outer join ZVSTORE02SUM as b on  a.mmyyyy    = b.mmyyyy
  //                                      and a.prctrclub = b.prctrclub
{

  key    a.mmyyyy,
  key    a.prctrclub,
         a.CompanyCodeCurrency,
         coalesce(a.store , 0) as store
}

union select from ZVSTORE02SUM as b

{
  key    b.mmyyyy,
  key    b.prctrclub,
         b.CompanyCodeCurrency,
         coalesce(b.store, 0 ) as store
}
