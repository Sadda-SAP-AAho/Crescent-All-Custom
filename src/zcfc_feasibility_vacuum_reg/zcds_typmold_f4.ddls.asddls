@AbapCatalog.sqlViewName: 'ZTYPMOLDF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Type of Mould-F4'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_TYPMOLD_F4
  as select distinct from zdt_fxdcstcal as a
{
  key a.mould as TypofMld,
      fxdcstrate

}
