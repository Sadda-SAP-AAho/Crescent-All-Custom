@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View For Totalamt in domestic invoice'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.sqlViewName: 'Z_TOTALAMT3'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
define view ZCDS_AMTOTAL3 as select from ZCDS_AMTOTAL as a
inner join ZCDS_AMTOTAL5 as b on a.BillingDocument = b.BillingDocument
{
  key a.BillingDocument,
 // coalesce( disctotal,0 ) + 
 coalesce( igsttotal, 0 ) + coalesce( linetotal,0 ) 
 //+ coalesce( packtotal,0 ) 
  + coalesce( cgsttotal, 0 )  + coalesce( sgsttotal, 0 ) + coalesce( tcstotal, 0 ) as  grandtotal1
} 

 