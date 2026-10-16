@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for shipping bill details'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_SHIPPINGBILL
 as select distinct from ZV_TAXINV as a
  left outer join       ZR_ShippingBillItemTP  as m on m.Invoice = a.BillingDocument
  left outer join       ZR_ShippingBillTP      as n on n.InternalShipbill = m.InternalShipbill
  {
    key a.BillingDocument,
        n.ShippingBill,
        n.ShippingBillDate
  }
