@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for total amount in proforma inv'
@Metadata.ignorePropagatedAnnotations: true
@AbapCatalog.sqlViewName: 'Z_PROAMT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
define view ZCDS_AMTPROINV as select from ZCDS_PROINVITM as i
inner join ZCDS_AMTPRO1 as j on i.BillingDocument = j.BillingDocument
{
  key i.BillingDocument,
 sum(i.discvalue) as disctotal,
//  sum(i.igstamt) as igsttotal,
//   sum(i.cgstamt) as cgsttotal,
 //   sum(i.sgstamt) as sgsttotal,
sum(i.packingfreight) as packtotal,
  sum(j.taxval) as linetotal
 // sum(i.tcs) as tcstotal
}
group by
i.BillingDocument
