@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for taxable value in proforma'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_AMTPRO1 as select from ZCDS_PROINVITM as i
{
  key i.BillingDocument,
      cast( cast(i.BillingQuantity as abap.dec(13,3) ) * 
            cast(i.rate  as abap.dec(13,3) ) as  abap.dec(13,2) ) as taxval
}
group by
i.BillingDocument,
i.BillingQuantity,
i.rate



