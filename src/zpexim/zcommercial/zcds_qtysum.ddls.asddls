@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for sum of qty of final pl'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_QTYSUM 
as select from ZI_COMM_HED as i 
inner join zdt_finlpack_hdr as a on a.comm_inv = i.Commid
    inner join   zdt_finlpack_itm as b on b.id = a.id
{
  key a.comm_inv,
      b.meins,
  @Semantics.quantity.unitOfMeasure: 'Meins'
  sum( cast( b.qty as abap.dec( 15, 0 ) ) ) as sumqty
}
where a.status <> 'CANCELED' and a.canind <> 'X'
group by
  a.comm_inv,
  b.meins
