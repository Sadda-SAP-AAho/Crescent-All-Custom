@AbapCatalog.sqlViewName: 'ZSVIEWAMT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Proforma Invoice Amt2Word Cal'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_AMTWORDVAL1
  as select distinct from ZV_PROFORMA_ITM as i
//    inner join   ZCDS_AMTWORDVAL as j on i.DeliveryDocument = j.DeliveryDocument
{
  key i.DeliveryDocument,
      sum(i.Disc)   as disctotal,
      sum(i.Pack)   as packtotal,
//      sum(j.taxval) as linetotal
      sum(i.amt) as linetotal

}
group by
  i.DeliveryDocument
