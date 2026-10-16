@AbapCatalog.sqlViewName: 'ZCDS_QTY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for qty & crate'
define view ZCDS_QTYCRATE
  as select from zdt_packlist_itm as a
    inner join   zdt_packlist_hdr as b on b.id = a.id
{
  a.delivery,
  b.revision,
  a.packmattyp,
  sum( a.packqty) as packqty
}
where b.canind <> 'X'
group by
  a.delivery,
  b.revision,
  a.packmattyp
