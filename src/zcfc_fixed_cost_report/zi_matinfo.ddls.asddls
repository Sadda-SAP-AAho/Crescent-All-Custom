@AbapCatalog.sqlViewName: 'ZMATINFO'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View of Material Info Dashboard'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_MATINFO
  as select from zdt_pp_matinffld
{
  key product,
      upper( typeofmould ) as typeofmould,
      qtyperbox,
      mldlinspd
}
