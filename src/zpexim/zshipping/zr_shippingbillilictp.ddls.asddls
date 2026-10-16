@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Shipping Bill LIC'
define view entity ZR_ShippingBillILICTP
  as select from zex_shipbill_lic as LIC

  association to parent ZR_ShippingBillTP as _ShippingBill on $projection.InternalShipbill = _ShippingBill.InternalShipbill
{
  key LIC.internal_shipbill      as InternalShipbill,
  key LIC.internal_shipbill_item as InternalShipbillItem,
      LIC.licencenumber          as Licencenumber,
      LIC.licencint              as Licencint,
      LIC.usageamount            as Usageamount,
      LIC.pendingamount          as PendingAmount,
      LIC.fob_fc                 as FobFc,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      LIC.locallastchangedat     as LocalLastChangedAt,
      _ShippingBill
}
