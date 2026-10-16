@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS For Proforma Invoice Amt2Word Cal'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_AMTWORDVAL as 
    select from ZV_PROFORMA_ITM as i
{
  key i.DeliveryDocument,
      cast( cast(i.Qty as abap.dec(13,3) ) * 
            cast(i.rate  as abap.dec(13,3) ) as  abap.dec(13,2) ) as taxval
}
group by
i.DeliveryDocument,
i.Qty,
i.rate




