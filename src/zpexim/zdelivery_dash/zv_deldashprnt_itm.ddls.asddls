@AbapCatalog.sqlViewName: 'ZV_DELDASHPRNT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Dashboard Print Item'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_DELDASHPRNT_ITM
  as select distinct from    ZI_DELDASH_HDR                 as a
    inner join      ZI_DELDASH_ITM                 as b    on b.Id = a.Id
    left outer join I_DeliveryDocument             as d    on a.Delivery = d.DeliveryDocument

    left outer join I_DeliveryDocumentItem         as e    on  b.Delivery = e.DeliveryDocument
                                                           and b.Posnr    = e.DeliveryDocumentItem
                                                           //and d.SDDocumentCategory = 'J'
    left outer join I_BillingDocumentItem          as c    on  c.ReferenceSDDocument     = b.Delivery
                                                           and c.ReferenceSDDocumentItem = b.Posnr
                                                           and c.BillingDocumentType     = 'F8'
    left outer join I_BillingDocItemPrcgElmntBasic as r    on  r.BillingDocument     = c.BillingDocument
                                                           and r.BillingDocumentItem = c.BillingDocumentItem
                                                           and (
                                                              r.ConditionType        = 'ZPR0'
                                                              or r.ConditionType     = 'ZPR1'
                                                            )
    left outer join I_BillingDocItemPrcgElmntBasic as l1   on  l1.BillingDocument     = c.BillingDocument
                                                           and l1.BillingDocumentItem = c.BillingDocumentItem
                                                           and l1.ConditionType        = 'ZSPC'
//    left outer join zdt_packlist_hdr               as k    on k.delivery = a.Delivery
//    left outer join zdt_packlist_itm               as x    on  x.id    = k.id
//                                                           and x.posnr = b.Posnr
    left outer join       ZV_PACKDET               as x    on x.Delivery = e.DeliveryDocument
                                                           and x.Posnr = e.DeliveryDocumentItem
    left outer join I_ProductPlantBasic            as y    on  y.Product = b.Matnr
                                                           and y.Plant   = e.Plant
    left outer join I_AE_CnsmpnTaxCtrlCodeTxt      as z    on  y.ConsumptionTaxCtrlCode = z.ConsumptionTaxCtrlCode
                                                           and z.Language               = 'E'
                                                           and z.CountryCode            = 'IN'
    left outer join I_BillingDocItemPrcgElmntBasic as dis  on  dis.BillingDocument     = c.BillingDocument
                                                           and dis.BillingDocumentItem = c.BillingDocumentItem
                                                           and (
                                                              dis.ConditionType        = 'ZK07'
                                                              or dis.ConditionType     = 'ZK08'
                                                              or dis.ConditionType     = 'D100'
                                                            )
    left outer join I_BillingDocItemPrcgElmntBasic as pack on  pack.BillingDocument     = c.BillingDocument
                                                           and pack.BillingDocumentItem = c.BillingDocumentItem
                                                           and (
                                                              pack.ConditionType        = 'ZPFP'
                                                              or pack.ConditionType     = 'ZPFV'
                                                            )
{
  key d.DeliveryDocument,
      e.DeliveryDocumentItem,
      b.Matnr,
      b.Maktx,
      z.ConsumptionTaxCtrlCodeText1,
      z.ConsumptionTaxCtrlCode,
      ceil( cast( b.Qty as abap.dec( 16,2 ) ) )        as Qty,
      b.Meins,
      b.Hsn,
      ( coalesce(r.ConditionRateValue,0) + coalesce(l1.ConditionRateValue,0) )   as Rate,
      dis.ConditionRateValue       as Disc,
      pack.ConditionRateValue      as Pack,
      ceil( cast( x.packqty as abap.dec( 16,2 ) ) ) as packqty,
      x.Packmattyp,
      x.netwt,
      x.growt,
      ( b.Qty * cast( ( coalesce(r.ConditionRateValue,0) + coalesce(l1.ConditionRateValue,0) ) as abap.dec(10,3)) ) as amt
}
where 
      a.Canind is initial
 
