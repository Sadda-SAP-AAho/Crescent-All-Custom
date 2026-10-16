@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Shipping Instruction Header'
define root view entity ZI_SHIPINS_HDR
  as select from zdt_shipinst_hdr
{
  key id            as Id,
      bookingno     as Bookingno,
      shipmenttype  as Shipmenttype,
      shippingtype  as Shippingtype,
      constreet1    as Constreet1,
      consadd1      as Consadd1,
      notifyp1name  as Notifyp1name,
      notifyp1add1  as Notifyp1add1,
      notifyp1add2  as Notifyp1add2,
      notifyp2name  as Notifyp2name,
      notifyp2add1  as Notifyp2add1,
      notifyp2add2  as Notifyp2add2,
      notifyp3name  as Notifyp3name,
      notifyp3add1  as Notifyp3add1,
      notifyp3add2  as Notifyp3add2,
      expcarrvoyage as Expcarrvoyage,
      loadingpier   as Loadingpier,
      deliveradd    as Deliveradd,
      deliveradd1   as Deliveradd1,
      deliveradd2   as Deliveradd2,
      creationdate  as Creationdate,
      tprint        as Tprint
}
