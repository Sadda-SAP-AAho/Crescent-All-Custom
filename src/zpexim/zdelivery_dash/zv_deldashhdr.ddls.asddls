@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Dashboard Print Custom Entity'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZV_DELDASHHDR
  as select distinct from ZI_DELDASH_HDR             as a
    left outer join       I_DeliveryDocument         as b on a.Delivery = b.DeliveryDocument
    left outer join       I_DeliveryDocumentItem     as e on e.DeliveryDocument = b.DeliveryDocument
    inner join            ZCDS_DD_PLANT              as f on f.DeliveryDocument = b.DeliveryDocument
    inner join            zdt_mm_pc_tmg              as c on  c.cocode = b.SalesOrganization
                                                          and c.plant  = f.Plant
    left outer join       I_SalesOrder               as d on d.SalesOrder = e.ReferenceSDDocument
  //left outer join I_Salesorderitem as g on g.ReferenceSDDocument = e.ReferenceSDDocument
  //                                      and g.ReferenceSDDocumentItem = e.ReferenceSDDocumentItem
    left outer join       I_CustomerPaymentTermsText as x on  x.CustomerPaymentTerms = d.CustomerPaymentTerms
                                                          and x.Language             = 'E'
    left outer join       ZCDS_DEL_CUSDET            as s on  s.DeliveryDocument = b.DeliveryDocument
                                                          and s.customer         = b.ShipToParty
                                                          and s.pfunc            = 'WE'
    left outer join       I_SalesOrderPartner        as m on  m.SalesOrder      = d.SalesOrder
                                                          and m.PartnerFunction = 'RE'
    left outer join       ZCDS_SALES_CUSDET          as t on  t.Salesorder = m.SalesOrder
                                                          and t.customer   = m.Customer
                                                          and t.pfunc      = 'RE'
    left outer join       ZCDS__TBFUNC_CONCATPO      as v on v.deliverydocument = b.DeliveryDocument
                                                             
{
  key b.DeliveryDocument,
      c.gstin,
      c.name,
      c.caddress1,
      c.caddress2,
      c.caddress3,
      b.CreationDate,
      b.CreationTime,
      a.Precarby,
      a.Por,
      a.Vesselno,
      a.Cusmar,
      a.Contno,
      a.Coo,
      a.Cod,
      a.Pol,
      a.Pod,
      a.Findes,
      a.Femadec,
      a.Scomdec,
      a.Lutigst,
      a.Salesnoteref,
      a.Descgoods,
      a.Descgoods1,
      b.IncotermsClassification,
      x.CustomerPaymentTermsName,
      c.iec,
      c.var3,
      c.plant,
      c.plantaddr1,
      c.plantaddr2,
      s.cusname as customersh,
      s.address as addressh,
      t.cusname as customerbp,
      t.address as addressbp,
      v.zcuspodate
}
where
  a.Canind <> 'X'
group by
  b.DeliveryDocument,
  c.gstin,
  c.name,
  c.caddress1,
  c.caddress2,
  c.caddress3,
  b.CreationDate,
  b.CreationTime,
  a.Precarby,
  a.Por,
  a.Vesselno,
  a.Cusmar,
  a.Descgoods1,
  a.Contno,
  a.Coo,
  a.Cod,
  a.Pol,
  a.Pod,
  a.Findes,
  a.Descgoods,
  a.Femadec,
  a.Scomdec,
  a.Lutigst,
  a.Salesnoteref,
  b.IncotermsClassification,
  x.CustomerPaymentTermsName,
  c.iec,
  c.var3,
  c.plant,
  c.plantaddr1,
  c.plantaddr2,
  s.cusname,
  s.address,
  t.cusname,
  t.address,
  v.zcuspodate
