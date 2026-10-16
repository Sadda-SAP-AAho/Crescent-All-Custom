@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Shipping Instruction Form Item Details'
define view entity ZVSHIPINST_ITM 
// as select distinct from ZI_SHIPINS_HDR       as a
//  left outer join       ZI_DELDASH_HDR       as b on a.Bookingno = b.Bookingno 
//  left outer join       ZI_DELDASH_ITM       as i on i.Id = b.Id //and i.Delivery = b.Delivery
//  left outer join       I_DeliveryDocument as c on c.DeliveryDocument = b.Delivery
//  left outer join       I_DeliveryDocumentItem as g on g.DeliveryDocument = c.DeliveryDocument and i.Posnr = g.DeliveryDocumentItem
//  left outer join       ZV_TAXINV              as k on k.ReferenceSDDocument = b.Delivery
//  left outer join       ZR_ShippingBillItemTP  as m on m.Invoice = k.BillingDocument
//  left outer join       ZR_ShippingBillTP      as n on n.InternalShipbill = m.InternalShipbill
//  left outer join       ZCDS_PCCODE            as e on e.Product = g.Product and e.Plant = g.Plant
//  left outer join       zdt_drfatpl_det        as f on f.customer = c.SoldToParty
//  left outer join       ZI_PACKLIST_ITM        as h on h.Delivery = b.Delivery and h.Posnr = g.DeliveryDocumentItem
//  left outer join       ZI_PACKLIST_HDR        as z on z.Id = h.Id
//  left outer join       I_ProductPlantBasic     as e on e.Product = i.Matnr and e.Plant = g.Plant
//  left outer join       I_AE_CnsmpnTaxCtrlCodeTxt as f on e.ConsumptionTaxCtrlCode = f.ConsumptionTaxCtrlCode
//                                                        and f.CountryCode = 'IN' and f.Language = 'E' and f.ConsumptionTaxCtrlCode is not initial
as select distinct from ZCDS_SHIINSTFORM as a
  {
   key a.Bookingno,
       a.Delivery, 
       a.Marks,
       a.ContainerNo,
       a.ContainerSize,
       a.SealNo,
       a.Descgoods,
       a.Descgoods1,
//       i.Posnr,
       a.Finalseal,
       a.HeaderWeightUnit,
       a.HeaderNetWeight,
       a.CreationDate,
//       e.ConsumptionTaxCtrlCode as HSNCode,
//       e.ConsumptionTaxCtrlCodeText1 as HSNDescp,
       a.address,
       a.customername,
       a.customer,
       a.counconsignee,
       @Semantics.quantity.unitOfMeasure : 'HeaderWeightUnit'
       sum(a.growt)  as growt,
//     @Semantics.quantity.unitOfMeasure : 'HeaderWeightUnit'
//       sum(h.Packqty) as packqty,
//       h.Packmattyp,
       a.Wtunit,
       a.Meins,
       a.Imono,
       a.ShippingBill,
       a.ShippingBillDate,
       a.BillingDocument,
       a.BillingDocumentDate
  }

group by a.Bookingno,
       a.Marks,
       a.ContainerNo,
       a.ContainerSize,
       a.SealNo,
       a.Descgoods,
       a.Descgoods1,
       a.Delivery,
       a.Finalseal,
//       i.Posnr,
       a.HeaderWeightUnit,
       a.CreationDate,
       a.HeaderNetWeight,
//       e.ConsumptionTaxCtrlCode,
//       e.ConsumptionTaxCtrlCodeText1,
       a.address,
       a.customername,
       a.customer,
       a.counconsignee,
//       h.Growt,
//       h.Packqty, 
//       h.Packmattyp,
       a.Wtunit,
       a.Meins,
       a.Imono,
       a.ShippingBill,
       a.ShippingBillDate,
       a.BillingDocument,
       a.BillingDocumentDate
      
