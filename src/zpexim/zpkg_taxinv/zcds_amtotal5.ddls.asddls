@AbapCatalog.sqlViewName: 'Z_TOTALAMT5'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: ''
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_AMTOTAL5 as select from ZCDS_DOMESTIC_TAXITM as j 
{
  key j.BillingDocument,
  sum(j.amttaxableigstlut) as linetotal
}
group by
j.BillingDocument
