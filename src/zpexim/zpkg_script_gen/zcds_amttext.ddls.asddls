@AbapCatalog.sqlViewName: 'ZSQLVIEWAMTTEXT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Amount in Text'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_AMTTEXT 
as select from ZCDS_SCRIPTINV_ITM as j 
{
  key j.scriptsalesno,
  sum(j.saleablevalue) as linetotal
}
group by
j.scriptsalesno
