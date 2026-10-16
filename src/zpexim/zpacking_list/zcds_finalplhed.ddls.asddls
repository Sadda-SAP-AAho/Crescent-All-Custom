@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'final packinglist header details'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_FINALPLHED
  as select distinct from ZI_COMM_HED                as a
    left outer join       zi_finalpack_hdr           as p on p.comm_inv = a.Commid
    left outer join       I_BillingDocument          as b on b.BillingDocument = a.Commid
    left outer join       I_BillingDocumentItem      as c on c.BillingDocument = b.BillingDocument
    left outer join       ZCDS_PLANT                 as e on e.BillingDocument = a.Commid
    left outer join       zdt_mm_pc_tmg              as d on  d.plant  = e.Plant
                                                          and d.cocode = b.SalesOrganization
    left outer join       I_BillingDocumentItem      as f on  f.BillingDocument             = a.Commid
                                                          and f.ReferenceSDDocumentCategory = 'J'
    left outer join       I_BillingDocumentItem      as z on  z.ReferenceSDDocument     =  f.ReferenceSDDocument
                                                          and z.BillingDocumentType     =  'F8'
                                                          and b.AccountingPostingStatus <> 'E'

    left outer join       zi_finalpack_itm           as k on  k.Delivery            = f.ReferenceSDDocument
                                                          and f.BillingDocumentItem = k.Posnr
    left outer join       ZI_DELDASH_HDR             as g on g.Delivery = f.ReferenceSDDocument
                                                           and g.Canind <> 'X'
    left outer join       I_CustomerPaymentTermsText as h on  h.CustomerPaymentTerms = b.CustomerPaymentTerms
                                                          and h.Language             = 'E'
    left outer join       I_DeliveryDocument         as l on l.DeliveryDocument = g.Delivery
    left outer join       ZR_ShippingBillItemTP      as m on m.Invoice = z.BillingDocument
    left outer join       ZR_ShippingBillTP          as n on n.InternalShipbill = m.InternalShipbill
    left outer join       ZCDS_WEIGHTSUM             as j on j.BillingDocument = a.Commid
    left outer join       ZCDS_DEL_CUSDET            as r on  r.DeliveryDocument = g.Delivery
                                                          and r.customer         = z.ShipToParty
                                                          and r.pfunc            = 'WE'
    left outer join       ZCDS_BILL_CUSDET           as i on  i.BillingDocument = b.BillingDocument
                                                          and i.customer        = c.BillToParty
                                                          and i.pfunc           = 'RE'
    left outer join      ZCDS_QTYSUM1                 as o on o.comm_inv = a.Commid
    left outer join      ZCDS_CONTSEAL               as t on t.billingdocument = a.Commid
{
  key a.Descgoods1,
      a.Descgoods2,
      a.Ladingno,
      p.Remarks,
   //  @Semantics.quantity.unitOfMeasure: 'Meins'
      o.sumqty,
      b.BillingDocument,
      d.gstin,
      d.cinno,
      d.caddress1,
      d.caddress2,
      d.iec,
      d.name,
      d.var3,
      b.BillingDocumentDate as CreationDate,
      b.PurchaseOrderByCustomer,
      g.Precarby,
      g.Por,
      g.Pod,
      g.Pol,
      g.Coo,
      a.Vesselcode,
      g.Cod,
      g.Findes,
      g.Cusmar,
      g.Descgoods,
      t.contnos as Contno,
      t.carsealnos as Carsealno,
      k.Meins,
      r.cusname  as custconsignee,
      r.address as counconsignee,
      i.cusname as custbuyer,
      i.address as counbuyer,
      h.CustomerPaymentTermsName,
      @Semantics.quantity.unitOfMeasure : 'meins'
      j.sumgrosswt,
      @Semantics.quantity.unitOfMeasure : 'meins'
      j.sumnetwt,
      //    @Semantics.quantity.unitOfMeasure : 'meins'
      //    sum(k.Growt) as sumgrosswt,
      //     @Semantics.quantity.unitOfMeasure : 'meins'
      //     sum(k.Netwt) as sumnetwt,
      n.ShippingBill,
      n.ShippingBillDate
}
where p.Canind <> 'X' 
group by
  a.Descgoods1,
  a.Descgoods2,
  a.Ladingno,
  p.Remarks,
  o.sumqty,
  b.BillingDocument,
  d.gstin,
  d.cinno,
  d.caddress1,
  d.caddress2,
  d.iec,
  d.name,
  d.var3,
  b.BillingDocumentDate,
  b.PurchaseOrderByCustomer,
  g.Precarby,
  g.Por,
  g.Pod,
  g.Pol,
  g.Coo,
  a.Vesselcode,
  g.Cod,
  g.Findes,
  g.Cusmar,
  t.contnos,
  t.carsealnos,
  g.Descgoods,
  k.Meins,
  r.cusname,
  r.address,
  i.cusname,
  i.address,
  j.sumgrosswt,
  j.sumnetwt,
  h.CustomerPaymentTermsName,
  n.ShippingBill,
  n.ShippingBillDate
