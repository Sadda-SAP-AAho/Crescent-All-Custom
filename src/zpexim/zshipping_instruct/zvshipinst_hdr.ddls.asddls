@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'shipping instruction header details'
define view entity ZVSHIPINST_HDR
  as select distinct from ZI_SHIPINS_HDR       as a
    left outer join       ZI_DELDASH_HDR       as b on a.Bookingno = b.Bookingno 
                                                    and b.Canind <> 'X'
    left outer join       I_DeliveryDocument   as f on f.DeliveryDocument = b.Delivery  
    left outer join       ZCDS_PLANTDRAFTPL    as c on  c.DeliveryDocument = f.DeliveryDocument
    left outer join       zdt_mm_pc_tmg        as d on  c.SalesOrganization = d.cocode
                                                            and c.Plant     = d.plant
    left outer join       ZCDS_DEL_CUSDET        as k on  k.customer         = f.ShipToParty
                                                      and k.pfunc            = 'WE'
                                                      and k.DeliveryDocument = f.DeliveryDocument
//    left outer join       zdt_drfatpl_det      as e on e.customer = f.SoldToParty
 {
  key a.Bookingno,
      d.name,
      d.caddress1,
      d.caddress2,
      a.Shipmenttype,
      a.Shippingtype,
      k.address,
      k.cusname as customername,
      b.Precarby,
      b.Pol,
      b.Por,
      b.Pod,
      b.Placedel,
      a.Loadingpier,
      a.Expcarrvoyage,
      a.Notifyp1name,
      a.Notifyp1add1,
      a.Notifyp1add2,
      a.Notifyp2name,
      a.Notifyp2add1,
      a.Notifyp2add2,
      a.Notifyp3name,
      a.Notifyp3add1,
      a.Notifyp3add2,
      a.Deliveradd,
      a.Deliveradd1,
      a.Deliveradd2   
}
group by a.Bookingno,
      d.name,
      d.caddress1,
      d.caddress2,
      a.Shipmenttype,
      a.Shippingtype,
      k.address,
      k.cusname,
      b.Precarby,
      b.Pol,
      b.Por,
      b.Pod,
      b.Placedel,
      a.Loadingpier,
      a.Expcarrvoyage,
      a.Notifyp1name,
      a.Notifyp1add1,
      a.Notifyp1add2,
      a.Notifyp2name,
      a.Notifyp2add1,
      a.Notifyp2add2,
      a.Notifyp3name,
      a.Notifyp3add1,
      a.Notifyp3add2,
      a.Deliveradd,
      a.Deliveradd1,
      a.Deliveradd2     
