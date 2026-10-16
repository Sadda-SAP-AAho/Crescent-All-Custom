@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'draft packing list header level fields'
define view entity ZVDOMDRAFTPL_HDR
  as select distinct from zdt_packlist_hdr       as a
    left outer join       I_DeliveryDocument     as b on b.DeliveryDocument = a.delivery
    left outer join       I_DeliveryDocumentItem as c on b.DeliveryDocument = c.DeliveryDocument
    left outer join       I_SalesOrder           as d on d.SalesOrder = c.ReferenceSDDocument
    left outer join       I_SalesOrderPartner    as m on  m.SalesOrder      = d.SalesOrder
                                                      and m.PartnerFunction = 'RE'
    left outer join       ZCDS_DOMDRAFTPL        as i on i.DeliveryDocument = b.DeliveryDocument
  
    left outer join       ZCDS_DEL_CUSDET        as j on  j.customer         = b.ShipToParty
                                                      and j.pfunc            = 'WE'
                                                      and j.DeliveryDocument = b.DeliveryDocument
    left outer join       ZCDS_SALES_CUSDET      as l on  l.customer   = m.Customer
                                                      and l.Salesorder = m.SalesOrder
                                                      and l.pfunc      = 'RE'
    left outer join       zdt_mm_pc_tmg          as h on  h.cocode = b.SalesOrganization
                                                      and h.plant  = i.Plant
  //    left outer join zdt_drfatpl_det as j on j.customer = b.SoldToParty
{

  key a.delivery    as DeliveryDocument,
      a.revision,
      d.PurchaseOrderByCustomer,
      d.CustomerPurchaseOrderDate,
      b.IncotermsClassification,
      h.caddress1,
      h.caddress2,
      h.name,
      j.address,
      j.customer,
      j.countryname as counconsignee,
      j.cusname as customernamesh,
      l.countryname as counbuyer,
      l.customer    as customer1,
      l.cusname     as customernamebp,
      l.address     as addressbp,
      h.iec,
      h.var3,
      a.contactp,
      a.contactn,
      a.pkgtyp,
      a.remarks
}
where a.canind <> 'X'
group by
  a.delivery,
  a.revision,
  d.PurchaseOrderByCustomer,
  d.CustomerPurchaseOrderDate,
  b.IncotermsClassification,
  h.caddress1,
  h.caddress2,
  h.name,
  j.address,
  j.customer,
  j.countryname,
  j.cusname,
  l.countryname,
  l.customer,
  l.cusname,
  l.address,
  h.iec,
  h.var3,
  a.contactp,
  a.contactn,
  a.pkgtyp,
  a.remarks
