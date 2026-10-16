@AbapCatalog.sqlViewName: 'Z_TOTALAMT2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Total Amount'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_AMTOTAL2 as select from ZCDS_AMTOTAL as a
inner join ZCDS_AMTOTAL5 as b on a.BillingDocument = b.BillingDocument
{
  key a.BillingDocument,
  // coalesce( disctotal,0 ) + 
 ( coalesce( igsttotal, 0 ) + coalesce( linetotal,0 ) ) as grandtotal
 // + coalesce( packtotal,0 ) 
} 

 