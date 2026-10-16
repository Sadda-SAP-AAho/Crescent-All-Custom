@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for qty and packmattype'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_QTYFINALCOMM 
as select from ZI_COMM_HED as i 
inner join zdt_finlpack_hdr as a on a.comm_inv = i.Commid
    inner join   zdt_finlpack_itm as b on b.id = a.id
{
  key a.comm_inv,
  b.packmattyp,
  b.meins,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  sum( b.packqty ) as packqty
}
where a.status <> 'CANCELED'
group by
  a.comm_inv,
  b.packmattyp,
  b.meins
