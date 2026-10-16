@AbapCatalog.sqlViewName: 'ZSVIEW4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For Proforma Invoice 3rd Table'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_TABLE4
  as select from ZCDS_TABLE4_N

{
  key DeliveryDocument,
  key ConsumptionTaxCtrlCode,
      ConsumptionTaxCtrlCodeText1,
      sum(snw) as snw,
      lf,
      sum(sqty) as sqty
}
group by
  DeliveryDocument,
  ConsumptionTaxCtrlCode,
  ConsumptionTaxCtrlCodeText1,
  lf
