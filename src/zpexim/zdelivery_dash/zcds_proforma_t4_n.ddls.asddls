@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for proforma inv table 4 details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_PROFORMA_T4_N
  as select from ZCDS_PROFORMA_T4
{
  key DeliveryDocument,
      ConsumptionTaxCtrlCodeText1,
      ConsumptionTaxCtrlCode,
      sum(Qty) as Qty,
      Wtunit,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      sum(snw) as snw
}
group by
  DeliveryDocument,
  ConsumptionTaxCtrlCodeText1,
  ConsumptionTaxCtrlCode,
  Wtunit
