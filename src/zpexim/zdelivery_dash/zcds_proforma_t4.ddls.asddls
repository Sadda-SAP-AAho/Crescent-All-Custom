@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for proforma inv table 4 details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_PROFORMA_T4
  as select distinct from ZV_PROFORMA_ITM        as a
    inner join            I_DeliveryDocumentItem as b on  a.DeliveryDocument     = b.DeliveryDocument
                                                      and a.DeliveryDocumentItem = b.DeliveryDocumentItem
{
  key a.DeliveryDocument,
  key a.DeliveryDocumentItem,
      a.ConsumptionTaxCtrlCodeText1,
      a.ConsumptionTaxCtrlCode,
      ceil( cast( b.ActualDeliveryQuantity as abap.dec( 16,2 ) ) ) as Qty,
      a.Wtunit,
      @Semantics.quantity.unitOfMeasure: 'Wtunit'
      sum(a.Netwt) as snw


}
group by
  a.DeliveryDocument,
  a.DeliveryDocumentItem,
  a.ConsumptionTaxCtrlCodeText1,
  a.ConsumptionTaxCtrlCode,
  a.Wtunit,
  b.ActualDeliveryQuantity
