@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'removing initial zeros from sum of qty'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_QTYSUM1 
as select distinct from ZCDS_QTYSUM 
{
  key comm_inv,
     ltrim(  cast( sumqty as abap.char( 20 ) ),'0') as sumqty
}

group by
  comm_inv,
  sumqty
