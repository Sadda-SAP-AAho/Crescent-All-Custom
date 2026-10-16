@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shipping Instruction Form Item Details'
define view entity ZCDS_SHIINSTFORM 
 as select distinct from ZI_SHIPINS_HDR       as a
  left outer join       ZI_DELDASH_HDR       as b on a.Bookingno = b.Bookingno 
  left outer join       ZI_DELDASH_ITM       as i on i.Id = b.Id //and i.Delivery = b.Delivery
  left outer join       I_DeliveryDocument as c on c.DeliveryDocument = b.Delivery
  left outer join       I_DeliveryDocumentItem as g on g.DeliveryDocument = c.DeliveryDocument and i.Posnr = g.DeliveryDocumentItem
  left outer join       ZV_TAXINV              as k on k.ReferenceSDDocument = b.Delivery
  left outer join       ZR_ShippingBillItemTP  as m on m.Invoice = k.BillingDocument
  left outer join       ZR_ShippingBillTP      as n on n.InternalShipbill = m.InternalShipbill
  left outer join       ZCDS_PCCODE            as e on e.Product = g.Product and e.Plant = g.Plant
//  left outer join       zdt_drfatpl_det        as f on f.customer = c.SoldToParty
  left outer join       ZI_PACKLIST_ITM        as h on h.Delivery = b.Delivery and h.Posnr = g.DeliveryDocumentItem
  left outer join       ZI_PACKLIST_HDR        as z on z.Id = h.Id
  left outer join       ZCDS_DEL_CUSDET        as t on  t.customer         = c.ShipToParty
                                                      and t.pfunc            = 'WE'
                                                      and t.DeliveryDocument = c.DeliveryDocument
//  left outer join       I_ProductPlantBasic     as e on e.Product = i.Matnr and e.Plant = g.Plant
//  left outer join       I_AE_CnsmpnTaxCtrlCodeTxt as f on e.ConsumptionTaxCtrlCode = f.ConsumptionTaxCtrlCode
//                                                        and f.CountryCode = 'IN' and f.Language = 'E' and f.ConsumptionTaxCtrlCode is not initial
  {
   key a.Bookingno,
       b.Delivery, 
       b.Cusmar as Marks,
       b.Contno as ContainerNo,
       b.Consizen as ContainerSize,
       b.Carsealno as SealNo,
       b.Descgoods,
       b.Descgoods1,
//       i.Posnr,
       b.Finalseal,
       c.HeaderWeightUnit,
       c.HeaderNetWeight,
       c.CreationDate,
//       e.ConsumptionTaxCtrlCode as HSNCode,
//       e.ConsumptionTaxCtrlCodeText1 as HSNDescp,
       t.address,
       t.cusname as customername,
       t.customer as customer,
       t.countryname as counconsignee,
       @Semantics.quantity.unitOfMeasure : 'HeaderWeightUnit'
      h.Growt as growt,
//     @Semantics.quantity.unitOfMeasure : 'HeaderWeightUnit'
//       sum(h.Packqty) as packqty,
//       h.Packmattyp,
       h.Wtunit,
       h.Meins,
       b.Imono,
       n.ShippingBill,
       n.ShippingBillDate,
       k.BillingDocument,
       k.BillingDocumentDate
  }
where b.Canind is initial and z.Canind is initial
group by a.Bookingno,
       b.Cusmar,
       b.Contno,
       b.Consizen,
       b.Carsealno,
       b.Descgoods,
       b.Descgoods1,
       b.Delivery,
       b.Finalseal,
//       i.Posnr,
       c.HeaderWeightUnit,
       c.CreationDate,
       c.HeaderNetWeight,
//       e.ConsumptionTaxCtrlCode,
//       e.ConsumptionTaxCtrlCodeText1,
       t.address,
       t.cusname,
       t.customer,
       t.countryname,
//       h.Growt,
//       h.Packqty, 
//       h.Packmattyp,
       h.Wtunit,
       h.Meins,
       b.Imono,
       n.ShippingBill,
       n.ShippingBillDate,
       k.BillingDocument,
       k.BillingDocumentDate,
       h.Growt
      
