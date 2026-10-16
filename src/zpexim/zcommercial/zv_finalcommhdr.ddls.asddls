@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for final commercial header'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZV_FINALCOMMHDR
  as select distinct from ZI_COMM_HED                as a
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
    left outer join       ZCDS_WEIGHTSUM             as k on k.BillingDocument = a.Commid
    left outer join       ZCDS_NETDUEDT_FPCKLIST     as o on o.BillingDocument = a.Commid
    left outer join       ZCDS_SALESNOTEREF1         as z1 on z1.BillingDocument = a.Commid
    left outer join       ZI_DELDASH_HDR             as g on g.Delivery = f.ReferenceSDDocument
                                                          and g.Canind <> 'X'
//    left outer join       I_IncotermsClassificationText as q on q.IncotermsClassification = b.IncotermsClassification
//                                                             and q.Language = 'E'
    left outer join       I_CustomerPaymentTermsText as h on  h.CustomerPaymentTerms = b.CustomerPaymentTerms
                                                          and h.Language             = 'E'
    left outer join       I_DeliveryDocument         as l on l.DeliveryDocument = g.Delivery
    left outer join       ZCDS_TBFUNC_SBDATE         as m on m.comminv = a.Commid
//    left outer join       ZR_ShippingBillItemTP      as m on m.Invoice = z.BillingDocument
//    left outer join       ZR_ShippingBillTP          as n on n.InternalShipbill = m.InternalShipbill
    left outer join       ZCDS_CUSTBANK              as p on p.PayerParty = b.PayerParty
    left outer join       ZCDS_DEL_CUSDET            as r on  r.DeliveryDocument = g.Delivery
                                                          and r.customer         = c.ShipToParty
                                                          and r.pfunc            = 'WE'
    left outer join       ZCDS_BILL_CUSDET           as i on  i.BillingDocument = b.BillingDocument
                                                          and i.customer        = c.BillToParty
                                                          and i.pfunc           = 'RE'
    left outer join      ZCDS_TBFUNC_PROINV          as j on j.comminv = a.Commid
    left outer join      ZCDS_CONTSEAL               as t on t.billingdocument = a.Commid
{
  key b.BillingDocument,
      a.Descgoods1,
      a.Descgoods2,
      a.Remarks1,
      a.Remarks2,
      d.gstin,
      d.cinno,
      d.caddress1,
      d.caddress2,
      d.iec,
      d.name,
      c.TransactionCurrency,
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
      t.contnos as Contno,
      g.Descgoods,
      z1.Salesnoteref,
      t.carsealnos as Carsealno,
      o.netduedate,
      k.Meins,
      @Semantics.quantity.unitOfMeasure : 'meins'
      k.sumgrosswt,
      @Semantics.quantity.unitOfMeasure : 'meins'
      k.sumnetwt,
      p.BankName,
      p.StreetName,
      p.CityName,
      r.cusname  as custconsignee,
      r.address as counconsignee,
      i.cusname as custbuyer,
      i.address as counbuyer,
      h.CustomerPaymentTermsName,
      b.IncotermsLocation1 as IncotermsClassificationName,
      a.Ladingno,
      a.Ladingdt,
      m.zsbnosbdate as ShippingBill,
      j.proinv
}

group by
  a.Descgoods1,
  a.Descgoods2,
  a.Remarks1,
  a.Remarks2,
  b.BillingDocument,
  d.gstin,
  d.cinno,
  c.TransactionCurrency,
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
  z1.Salesnoteref,
  o.netduedate,
  k.Meins,
  k.sumgrosswt,
  k.sumnetwt,
  p.BankName,
  p.StreetName,
  p.CityName,
  r.cusname,
  r.address,
  i.cusname,
  i.address,
  h.CustomerPaymentTermsName,
  b.IncotermsLocation1,
  a.Ladingno,
  a.Ladingdt,
  m.zsbnosbdate,
  j.proinv
