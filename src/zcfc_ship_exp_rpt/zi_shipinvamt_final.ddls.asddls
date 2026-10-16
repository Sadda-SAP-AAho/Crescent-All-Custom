@AbapCatalog.sqlViewName: 'ZSHIPINVAMTFNL'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Shipp Inv Amt Final'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SHIPINVAMT_FINAL
  as select distinct from ZI_SHPINVAMT
{
  key Commid,
  key ServiceEntrySheet,
  key Servicepo,
  key Servicepoline,
  key DocumentCurrency,
      cast ( sum(InvAmt) as abap.dec( 13, 3 )) as InvAmt
}
group by
  Commid,
  ServiceEntrySheet,
  Servicepo,
  Servicepoline,
  DocumentCurrency
