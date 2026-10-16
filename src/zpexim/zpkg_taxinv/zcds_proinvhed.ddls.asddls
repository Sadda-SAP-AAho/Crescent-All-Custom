@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View For Tax Invoice Header Details'
define root view entity ZCDS_PROINVHED
  as select from    zi_taxhdr                  as i
    left outer join I_BillingDocument          as a on a.BillingDocument = i.Billingdoc
    left outer join I_BillingDocumentItem      as h on h.BillingDocument = a.BillingDocument
  //    left outer join       I_IN_ElectronicDocInvoice as b on  a.BillingDocument     = b.ElectronicDocSourceKey
  //                                                         and b.IN_EDocEWbillStatus = 'EWBGEN'
  //    left outer join       I_IN_ElectronicDocInvoice as c on a.BillingDocument              = c.ElectronicDocSourceKey
  //                                                         and(
  //                                                           c.ElectronicDocProcessStatus    = 'GEN_EINV'
  //                                                           or c.ElectronicDocProcessStatus = 'COMPLETED'
  //                                                         )
    inner join      ZCDS_PLANT                 as e on i.Billingdoc = e.BillingDocument
    inner join      zdt_mm_pc_tmg              as f on  e.CompanyCode = f.cocode
                                                    and e.Plant       = f.plant
    left outer join ZI_DELDASH_HDR             as g on  g.Delivery                    = h.ReferenceSDDocument
                                                    and h.ReferenceSDDocumentCategory = 'J'
                                                    and g.Canind <> 'X'
    left outer join zi_ghead                   as j on  j.deliverynumber              = h.ReferenceSDDocument
                                                    and h.ReferenceSDDocumentCategory = 'J'
//    left outer join zdt_drfatpl_det            as k on k.customer = a.SoldToParty
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
{

  key a.BillingDocument,
      a.DocumentReferenceID,
      a.BillingDocumentDate,
      //      b.IN_EDocEInvcEWbillNmbr,
      //      c.IN_ElectronicDocInvcRefNmbr,
      //      c.IN_ElectronicDocQRCodeTxt,
      //      a.PurchaseOrderByCustomer,
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
      //      f.cinno,
      //      f.panno,
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
      s.customer,
      t.customer as customer1,
      s.countryname as counconsignee,
      t.countryname as counbuyer,
      x.PurchaseOrderByCustomer,
      x.CustomerPurchaseOrderDate,
      w.CustomerPaymentTermsName
      //      f.var1 as LUTNo,
      //      f.var2 as LUTdt
}

