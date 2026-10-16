@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Total amount in proforma invoice'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.sqlViewName: 'Z_TOTALAMTPRO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
define view ZCDS_AMTWORDTOTAL 
as select from ZCDS_AMTWORDVAL1
{
  key DeliveryDocument,
 coalesce( packtotal, 0 ) + coalesce( linetotal, 0 ) + coalesce( disctotal, 0 )
 as  grandtotal
} 

 