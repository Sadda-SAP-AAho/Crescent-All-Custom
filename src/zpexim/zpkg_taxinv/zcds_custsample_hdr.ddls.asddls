@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for Custom Sales Header'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_CUSTSAMPLE_HDR
  as select distinct from    zi_taxhdr                  as i
    left outer join I_BillingDocument          as a on a.BillingDocument = i.Billingdoc
    left outer join I_BillingDocumentItem      as h on h.BillingDocument = a.BillingDocument
    inner join      ZCDS_PLANT                 as e on i.Billingdoc = e.BillingDocument
    inner join      zdt_mm_pc_tmg              as f on  e.CompanyCode = f.cocode
                                                    and e.Plant       = f.plant
    left outer join ZI_DELDASH_HDR             as g on  g.Delivery                    = h.ReferenceSDDocument
                                                    and h.ReferenceSDDocumentCategory = 'J'
                                                    and g.Canind <> 'X'
    left outer join zi_ghead                   as j on  j.deliverynumber              = h.ReferenceSDDocument
                                                    and h.ReferenceSDDocumentCategory = 'J'
    left outer join I_DeliveryDocument         as z on  z.DeliveryDocument            = h.ReferenceSDDocument
                                                    and h.ReferenceSDDocumentCategory = 'J'
    left outer join I_DeliveryDocumentItem     as y on y.DeliveryDocument = z.DeliveryDocument
    left outer join ZCDS_DEL_CUSDET            as s on  s.DeliveryDocument = g.Delivery
                                                    and s.customer         = h.ShipToParty
                                                    and s.pfunc            = 'WE'
    left outer join ZCDS_BILL_CUSDET           as t on  t.BillingDocument = a.BillingDocument
                                                    and t.customer        = h.BillToParty
                                                    and t.pfunc           = 'RE'
    left outer join I_SalesOrder               as x on y.ReferenceSDDocument = x.SalesOrder
    left outer join I_CustomerPaymentTermsText as w on  w.CustomerPaymentTerms = a.CustomerPaymentTerms
                                                    and w.Language             = 'E'
    left outer join ZCDS__TBFUNC_CONCATPO      as z1 on z1.deliverydocument = h.ReferenceSDDocument
                                                    and h.ReferenceSDDocumentCategory = 'J'
{

  key a.BillingDocument,
      a.DocumentReferenceID,
      a.BillingDocumentDate,
      a.IncotermsLocation1,
      a.IncotermsTransferLocation,
      f.caddress1,
      f.caddress2,
      f.caddress3,
      f.name,
      f.plant,
      f.plantname,
      f.plantaddr1,
      f.plantaddr2,
      f.plantaddr3,
      f.iec,
      f.var3,
      f.gstin,
      i.Textfield1,
      i.Textfield2,
      i.Textfield3,
      i.Textfield4,
      g.Precarby,
      g.Por,
      g.Coo,
      g.Cod,
      g.Vesselno,
      g.Delmode,
      g.Pod,
      g.Pol,
      g.Findes,
      g.Carsealno,
      g.Contno,
      g.Cusmar,
      g.Femadec,
      g.Scomdec,
      g.Lutigst,
      g.Salesnoteref,
      g.Descgoods,
      g.Descgoods1,
      j.Vehno,
      h.ReferenceSDDocument,
      s.cusname as customername,
      s.address,
      t.cusname as customernamebp,
      t.address as addressbp,
      s.countryname as counconsignee,
      t.countryname as counbuyer,
      x.PurchaseOrderByCustomer,
      x.CustomerPurchaseOrderDate,
      w.CustomerPaymentTermsName,
      z1.zcuspodate
}

