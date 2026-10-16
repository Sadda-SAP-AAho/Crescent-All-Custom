@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'concatenating shipping bill no & date'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_SHIPPINGBILL_DET1 
as select from ZCDS_SHIPPINGBILL_DET
{
    key BillingDocument,
    cast( 
concat( ShippingBill,
concat('- ',
concat(substring(ShippingBillDate,7,2),
concat('/',
concat(substring(ShippingBillDate,5,2),
concat('/', substring(ShippingBillDate,1,4) ) ) ) ) ) ) as abap.char( 100 ) ) as zsbnosbdate
}
group by BillingDocument,
         ShippingBill,
         ShippingBillDate
