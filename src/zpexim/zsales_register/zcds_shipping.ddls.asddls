@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Shipping details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SHIPPING
  as select from    ZR_ShippingBillItemTP as Q
    left outer join ZR_ShippingBillTP     as R on Q.InternalShipbill = R.InternalShipbill
{
  key Q.InternalShipbill,
  key Q.InternalShipbillItem,
      Q.Invoice,
      R.ShippingBill     as ShipBill,
      R.ShippingBillDate as ShipBillDate
}

where
  R.statuscancel is initial
