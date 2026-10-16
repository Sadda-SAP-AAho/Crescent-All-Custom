@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View For Totalamt in Proforma invoice'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.sqlViewName: 'Z_TOTALAMT4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
define view ZCDS_AMTOTAL4 as select from ZCDS_AMTPROINV
{
  key BillingDocument,
 coalesce( packtotal, 0 ) + coalesce( linetotal, 0 ) + coalesce( disctotal, 0 )
 as  grandtotal
} 

 