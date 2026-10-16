@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'draft packing list header level fields'
define view entity ZVDRAFTPL_HDR
  as select distinct from zdt_packlist_hdr       as z
    left outer join       I_DeliveryDocument     as a on a.DeliveryDocument = z.delivery
    left outer join       I_DeliveryDocumentItem as b on a.DeliveryDocument = b.DeliveryDocument
    left outer join       I_SalesOrder           as e on e.SalesOrder = b.ReferenceSDDocument
    left outer join       I_SalesOrderPartner    as m on  m.SalesOrder      = e.SalesOrder
                                                      and m.PartnerFunction = 'RE'
    left outer join       ZI_DELDASH_HDR         as c on a.DeliveryDocument = c.Delivery
    left outer join       ZCDS_PLANTDRAFTPL      as i on i.DeliveryDocument = a.DeliveryDocument
    left outer join       zdt_mm_pc_tmg          as j on  i.SalesOrganization = j.cocode
                                                      and i.Plant             = j.plant
    left outer join       ZCDS_DEL_CUSDET        as k on  k.customer         = a.ShipToParty
                                                      and k.pfunc            = 'WE'
                                                      and k.DeliveryDocument = a.DeliveryDocument
    left outer join       ZCDS_SALES_CUSDET      as l on  l.customer   = m.Customer
                                                      and l.Salesorder = m.SalesOrder
                                                      and l.pfunc      = 'RE'
    left outer join       ZCDS_HEDVIEW           as q on z.delivery = q.delivery
    left outer join       ZCDS__TBFUNC_CONCATPO  as n on n.deliverydocument = a.DeliveryDocument
  
{

  key z.delivery     as DeliveryDocument,
      z.revision,
      c.Precarby,
      c.Por,
      c.Coo,
      c.Cod,
      c.Vesselno,
      c.Pod,
      c.Pol,
      c.Cusmar,
      c.Contno,
      c.Placedel,
      c.Descgoods,
      c.Descgoods1,
      c.Textfield1,
      c.Textfield2,
      c.Salesnoteref,
      a.CreationDate,
      a.IncotermsClassification,
      a.IncotermsTransferLocation,
      e.PurchaseOrderByCustomer,
      e.CustomerPurchaseOrderDate,
      j.caddress1,
      j.caddress2,
      j.caddress3,
      j.name,
      j.iec,
      j.var3,
      k.address,
      k.customer,
      k.cusname      as customername,
      k.countryname  as counconsignee,
      l.address      as buyeraddress,
      l.customer     as customer1,
      l.countryname  as counbuyer,
      q.CreationDate as crdate,
      q.BillingDocument,
      q.DocumentReferenceID,
      z.remarks,
      n.zcuspodate
   

}
where
  z.canind <> 'X' and c.Canind <> 'X'
group by
  z.delivery,
  z.revision,
  c.Precarby,
  c.Por,
  c.Coo,
  c.Cod,
  c.Vesselno,
  c.Pod,
  c.Pol,
  c.Cusmar,
  c.Contno,
  c.Placedel,
  c.Descgoods,
  c.Descgoods1,
  c.Textfield1,
  c.Textfield2,
  c.Salesnoteref,
  a.CreationDate,
  a.IncotermsClassification,
  a.IncotermsTransferLocation,
  e.PurchaseOrderByCustomer,
  e.CustomerPurchaseOrderDate,
  j.caddress1,
  j.caddress2,
  j.caddress3,
  j.name,
  j.iec,
  j.var3,
  k.address,
  k.customer,
  k.cusname,
  k.countryname,
  l.address,
  l.customer,
  l.countryname,
  q.CreationDate,
  q.BillingDocument,
  q.DocumentReferenceID,
  z.remarks,
  n.zcuspodate

