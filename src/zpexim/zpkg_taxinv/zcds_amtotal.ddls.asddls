@AbapCatalog.sqlViewName: 'Z_TOTALAMT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Total Amt'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_AMTOTAL as select from ZCDS_DOMESTIC_TAXITM as i
{
  key i.BillingDocument,
 // sum(i.discvalue) as disctotal,
  sum(i.igstamt) as igsttotal,
   sum(i.cgstamt) as cgsttotal,
    sum(i.sgstamt) as sgsttotal,
//  sum(i.packingfreight) as packtotal,
 // sum(j.taxval) as linetotal,
 //sum(j.amttaxableigstlut) as linetotal,
  sum(i.tcs) as tcstotal
}
group by
i.BillingDocument
