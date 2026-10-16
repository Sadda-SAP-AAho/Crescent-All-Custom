@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'amount for amt to words in finalcomm'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_AMTCOMM1 
as select distinct from ZCDS_AMTCOMM
{
  key  BillingDocument,
       ( coalesce( cast( sumamount as abap.dec( 23, 2) ), 0 ) + coalesce( cast( discsum as abap.dec( 23, 2) ), 0 )  +  coalesce( cast( packingsum as abap.dec( 23, 2) ), 0 )   + coalesce( cast( freightsum as abap.dec( 23, 2) ), 0 ) ) as totalamt
    

}
