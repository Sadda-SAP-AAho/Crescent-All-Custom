@AbapCatalog.sqlViewName: 'ZSPCLCOST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Special Cost'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_SPCL_COST
  as select from ZI_SPPRMSWRKHDR as a
    inner join   ZI_SPPRMSWRKITM as b on a.Id = b.Id
{
  key a.Id,
  key b.Item,
  key a.Workcode,
      a.Workname,
      b.Datefrom,
      b.Dateto,
      b.Rate
}

where
  a.Plantcode is initial
