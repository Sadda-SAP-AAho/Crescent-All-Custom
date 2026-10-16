@AbapCatalog.sqlViewName: 'Z_SELEXPF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Selling Expense-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_SELEXP_F4
  as select from ZI_TmgTableForSellingE as a
{
  key a.Expcode as Expcode,
      a.Expname as Expname
}
