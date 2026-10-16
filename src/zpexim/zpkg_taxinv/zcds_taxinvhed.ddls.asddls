@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View For Tax Invoice Header Details'
define root view entity ZCDS_TAXINVHED
  as select from    zi_taxhdr                 as i
    left outer join I_BillingDocument         as a on a.BillingDocument = i.Billingdoc
    left outer join I_BillingDocumentItem     as h on  h.BillingDocument         =  a.BillingDocument
                                                   and h.BillingDocumentType     =  'F8'
                                                   and a.AccountingPostingStatus <> 'E'
//    left outer join I_SalesOrderItem          as q on  h.SalesDocument = q.SalesOrder
//                                                   and h.SalesDocumentItem  = q.SalesOrderItem
    left outer join I_IN_ElectronicDocInvoice as b on  a.BillingDocument     = b.ElectronicDocSourceKey
                                                   and b.IN_EDocEWbillStatus = 'EWBGEN'
    left outer join I_IN_ElectronicDocInvoice as c on a.BillingDocument              = c.ElectronicDocSourceKey
                                                   and(
                                                     c.ElectronicDocProcessStatus    = 'GEN_EINV'
                                                     or c.ElectronicDocProcessStatus = 'COMPLETED'
                                                   )
    inner join      ZCDS_PLANT                as e on i.Billingdoc = e.BillingDocument
    inner join      zdt_mm_pc_tmg             as f on  e.CompanyCode = f.cocode
                                                   and e.Plant       = f.plant
    left outer join ZI_DELDASH_HDR            as g on  g.Delivery                    = h.ReferenceSDDocument
                                                   and h.ReferenceSDDocumentCategory = 'J'
                                                   and g.Canind <> 'X'
    left outer join zi_ghead                  as j on  j.deliverynumber              = h.ReferenceSDDocument
                                                   and h.ReferenceSDDocumentCategory = 'J'
    left outer join ZCDS_DEL_CUSDET           as k on  k.DeliveryDocument = g.Delivery
                                                   and k.customer         = h.ShipToParty
                                                   and k.pfunc = 'WE'
    left outer join ZCDS_BILL_CUSDET          as z on  z.BillingDocument = a.BillingDocument
                                                   and z.customer        = h.BillToParty
                                                  and z.pfunc = 'RE'
  // left outer join       zdt_drfatpl_det           as k on k.customer = a.SoldToParty
  // left outer join       zdt_drfatpl_det          as z on z.customer2 = h.BillToParty
    left outer join ZCDS_REGION               as m on m.Region = z.region
    left outer join ZCDS_REGION               as n on n.Region = k.region
    left outer join I_Customer                as p on p.Customer = h.BillToParty
    left outer join I_Customer                as d on d.Customer = h.ShipToParty
    left outer join ZCDS_SHIPPINGBILL         as l on l.BillingDocument = a.BillingDocument
    left outer join ZCDS_LCSORTED            as r on r.BillingDocument = a.BillingDocument
    left outer join ZCDS_POBYCUST            as o on o.BillingDocument = h.BillingDocument
    left outer join ZCDS_PACKINGDETAILS      as t on t.BillingDocument = a.BillingDocument
{

  key a.BillingDocument,
      a.DocumentReferenceID,
      a.BillingDocumentDate,
      o.PurchaseOrderByCustomer,
      b.IN_EDocEInvcEWbillNmbr,
      c.IN_ElectronicDocInvcRefNmbr,
      c.IN_ElectronicDocQRCodeTxt,
      f.caddress1,
      f.caddress2,
      f.caddress3,
      f.name,
      f.plantname,
      f.plantaddr1,
      f.plantaddr2,
      f.plantaddr3,
      f.gstin,
      f.tin,
      f.cinno,
      f.panno,
      g.Delmode,
      g.Pod,
      g.Rfidsealno as  Carsealno,
      g.Contno,
      j.Vehno,
      j.Lrblno,
      i.Textfield1,
      i.Textfield2,
      i.Textfield3,
      i.Textfield4,
      h.ReferenceSDDocument,
      l.ShippingBill,
      l.ShippingBillDate,
      r.Lc_Appl as lcnumber,
      r.Lc_Open_Dt as lcdate,
      r.Banka as lcbankname,
      k.cusname                    as customername,
      k.address,
      z.cusname                    as customernamedeltax,
      z.address                    as addressdeltax,
      m.Regioncode                 as regioncodedeltax,
      m.Regionname                 as regionnamedeltax,
      n.Regioncode                 as regioncodesh,
      n.Regionname                 as regionnamesh,
      f.var1                       as LUTNo,
      f.var2                       as LUTdt,
      p.TaxNumber3                 as gstindeltax,
      substring(p.TaxNumber3,3,10) as pannodeltax,
      d.TaxNumber3                 as gstinship,
      substring(d.TaxNumber3,3,10) as pannoship,
      t.BillingQuantityUnit,
       @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
      ceil( cast(t.pkg as abap.dec(15,3 ) ) ) as pkgsum,     
      @Semantics.quantity.unitOfMeasure : 'BillingQuantityUnit'
      t.netwt as netwtsum
}
