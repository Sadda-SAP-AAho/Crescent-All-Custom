@AbapCatalog.sqlViewName: 'Z_TOTALAMT1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Total Amt'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_AMTOTAL1 as select from ZCDS_TAXINVITM as i
{
  key i.BillingDocument,
//      cast( cast(i.BillingQuantity as abap.dec(13,3) ) * 
//            cast(i.rateigstlut  as abap.dec(13,3) ) as  abap.dec(13,2) ) as taxval
i.amttaxableigstlut
}
group by
i.BillingDocument,
//i.BillingQuantity,
i.amttaxableigstlut
//i.rateigstlut



