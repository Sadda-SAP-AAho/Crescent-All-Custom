@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Test'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TEST 
  as select from    I_DeliveryDocument     as a
    inner join      I_DeliveryDocumentItem as b  on b.DeliveryDocument = a.DeliveryDocument
    inner join      I_ProductDescription   as c  on  c.Product  = b.Product
                                                 and c.Language = 'E'
    inner join      I_Product              as d  on d.Product = b.Product
    left outer join ZCDS_PLANNING_RPT_V3   as e  on  e.Product = b.Product
                                                 and e.Plant   = a.ShippingPoint
    left outer join ZCDS_PLANING_RPT_V9    as f  on f.delivery = a.DeliveryDocument
  // and f.canind   <> 'X'
    left outer join zdt_pp_matinffld       as g  on g.product = b.Product
    left outer join I_SalesDocument        as h  on h.SalesDocument = b.ReferenceSDDocument
    left outer join I_SalesDocumentItem    as i  on  i.SalesDocument     = b.ReferenceSDDocument
                                                 and i.SalesDocumentItem = b.ReferenceSDDocumentItem
    left outer join zdt_deldash_hdr        as j  on  j.delivery =  a.DeliveryDocument
                                                 and j.canind   <> 'X'
    inner join      zdt_bomdet             as k  on  k.hedmaterial = b.Product
                                                 and k.plant       = a.ShippingPoint
    left outer join ZCDS_PLANING_RPT_V2    as l  on  l.Product = k.component
                                                 and l.Plant   = a.ShippingPoint
    left outer join ZCDS_PACK_CASTSTCK     as l1 on  l1.hedmaterial = k.hedmaterial
                                                 and l1.component   = k.component
                                                 and l1.plant       = k.plant
    left outer join ZCDS_PACK_MACSTCK      as l2 on  l2.hedmaterial = k.hedmaterial
                                                 and l2.component   = k.component
                                                 and l2.plant       = k.plant
    left outer join ZCDS_PACK_GRNDSTCK     as l3 on  l3.hedmaterial = k.hedmaterial
                                                 and l3.component   = k.component
                                                 and l3.plant       = k.plant
    left outer join ZCDS_PACK_PANTSTCK     as l4 on  l4.hedmaterial = k.hedmaterial
                                                 and l4.component   = k.component
                                                 and l4.plant       = k.plant
    left outer join I_ProductDescription   as m  on  m.Product  = k.component
                                                 and m.Language = 'E'
    left outer join I_Product              as n  on n.Product = k.component
    left outer join I_Plant                as o  on o.Plant = b.Plant
    left outer join I_ProductGroupText_2   as o1 on o1.ProductGroup = n.ProductGroup
    left outer join I_Product              as n1 on n1.Product = k.parent
    left outer join I_ProductGroupText_2   as o2 on o2.ProductGroup = n1.ProductGroup
    left outer join ZCDS_PLANING_RPT_V4    as p  on  p.SalesOrder     = b.ReferenceSDDocument
                                                 and p.SalesOrderItem = b.ReferenceSDDocumentItem
    left outer join ZCDS_PACK_MAT_DET_S    as q  on  q.hedmaterial = k.hedmaterial
                                                 and q.plant       = k.plant
                                                 and q.matz025     = k.component
    left outer join ZCDS_PACK_MAT_DET_S    as r  on  r.hedmaterial = k.hedmaterial
                                                 and r.plant       = k.plant
                                                 and r.matZ027     = k.component
    left outer join ZCDS_PACK_MAT_DET_S    as t  on  t.hedmaterial = k.hedmaterial
                                                 and t.plant       = k.plant
                                                 and t.matZ026     = k.component
    left outer join ZCDS_PACK_REQD_MUL     as u  on  u.plant       = k.plant
                                                 and u.hedmaterial = k.hedmaterial
                                                 and u.component   = k.component
    left outer join zdt_pp_matinffld       as v  on v.product = k.component

    left outer join ZCDS_SCHEDULINE1       as w  on  w.SalesOrder     = b.ReferenceSDDocument
                                                 and w.SalesOrderItem = b.ReferenceSDDocumentItem

    left outer join ZI_COMTDELDT           as x  on  b.ReferenceSDDocument     = x.SalesOrder
                                                 and b.ReferenceSDDocumentItem = x.SalesOrderItem

{
  key b.ReferenceSDDocument                                                               as SalesDocument,
  key b.ReferenceSDDocumentItem                                                           as SalesDocumentItem,
  key cast( 1 as abap.dec( 1, 0 ) )                                                       as piority,
  key a.DeliveryDocument                                                                  as docentey,
  key b.DeliveryDocumentItem,
  key k.bomlevel,
  key k.parent,
  key k.component,
      a.CreationDate,
      f.createdon                                                                         as docdate,
      f.packinglist                                                                       as fgsino,
      a.ShippingPoint,
      a.DeliveryDate,
      a.SoldToParty                                                                       as cardcode,
      b.Product                                                                           as itemcode,
      c.ProductDescription                                                                as itemname,
      w.soholdstat,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      d.NetWeight                                                                         as weight,
      d.WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      b.ActualDeliveryQuantity                                                            as ordqty,
      b.DeliveryQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      e.qty                                                                               as fgstock,
      e.MaterialBaseUnit,
      k.parent                                                                            as father,
      o2.ProductGroupText                                                                 as ProductGroupTextf,
      k.component                                                                         as child,
      o1.ProductGroupText,
      u.qty                                                                               as bomitemqty, //bomitemqty
      cast( 0 as abap.dec( 13, 3 ) )                                                      as sodelqty,
      //      cast( ( ( coalesce( cast( b.ActualDeliveryQuantity as abap.dec( 13, 3 ) ), 0 ) - coalesce( cast( e.qty as abap.dec( 13, 3 ) ), 0 ) )
      //              * k.bomitemqty ) as abap.dec( 13, 3 ) )                                     as reqdqty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      case when k.productgroup = 'Z025' then l1.qty
           else cast( 0 as abap.quan( 13, 3 ) ) end                                       as caststock2,
      e.MaterialBaseUnit                                                                  as MaterialBaseUnit1,
      cast( ( coalesce( cast( l1.qty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( l1.qty1 as abap.dec( 13, 3 ) ), 0 ) +
              coalesce( cast( l2.qty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( l2.qty1 as abap.dec( 13, 3 ) ), 0 ) +
              coalesce( cast( l3.qty as abap.dec( 13, 3 ) ), 0 ) + coalesce( cast( l3.qty1 as abap.dec( 13, 3 ) ), 0 ) +
              coalesce( cast( l4.qty as abap.dec( 13, 3 ) ), 0 ) ) as abap.dec( 13, 3 ) ) as tsstck,
      case when k.productgroup = 'Z028' then k.component
           else cast( '' as abap.char(40) ) end                                           as paintitm,
      case when k.productgroup = 'Z028' then m.ProductDescription
           else cast( '' as abap.char(40) ) end                                           as paintitmtxt,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      case when k.productgroup = 'Z028' then l.qty
           else cast( 0 as abap.quan( 13, 3 ) ) end                                       as paintstock,
      case when k.productgroup = 'Z026' then k.component
           else cast( '' as abap.char(40) ) end                                           as macitm,
      case when k.productgroup = 'Z026' then m.ProductDescription
           else cast( '' as abap.char(40) ) end                                           as macitmtxt,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      case when k.productgroup = 'Z026' then l.qty
           else cast( 0 as abap.quan( 13, 3 ) ) end                                       as macstock,
      case when k.productgroup = 'Z026'
           then case when k.parentqty is not initial
                then division( k.childqty, k.parentqty, 3 ) else k.bomitemqty end
           else cast( 0 as abap.dec( 15, 3 ) ) end                                        as macbiqty,
      k.bomitemqtyunit,
      case when k.productgroup = 'Z027' then k.component
           else cast( '' as abap.char(40) ) end                                           as grinditm,
      case when k.productgroup = 'Z027' then m.ProductDescription
           else cast( '' as abap.char(40) ) end                                           as grinditmtxt,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      case when k.productgroup = 'Z027' then l.qty
           else cast( 0 as abap.quan( 13, 3 ) ) end                                       as grindstock,
      case when k.productgroup = 'Z027'
           then case when k.parentqty is not initial
                then division( k.childqty, k.parentqty, 3 ) else k.bomitemqty end
           else cast( 0 as abap.dec( 15, 3 ) ) end                                        as grindbiqty,
      case when k.productgroup = 'Z025' then k.component
           else cast( '' as abap.char(40) ) end                                           as castitm,
      case when k.productgroup = 'Z025' then m.ProductDescription
           else cast( '' as abap.char(40) ) end                                           as castitmtxt,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit1'
      case when k.productgroup = 'Z025' then l.qty
           else cast( 0 as abap.quan( 13, 3 ) ) end                                       as Caststock,
      case when k.productgroup = 'Z025'
           then case when k.parentqty is not initial
                then division( k.childqty, k.parentqty, 3 ) else k.bomitemqty end
           else cast( 0 as abap.dec( 15, 3 ) ) end                                        as castbiqty,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit2'
      case when k.productgroup = 'Z025' then q.paint
           when k.productgroup = 'Z026' then t.paint
           when k.productgroup = 'Z027' then r.paint
           else cast( 0 as abap.quan( 13, 3 ) ) end                                       as totpaistock,
      case when k.productgroup = 'Z025' then q.unit4
           when k.productgroup = 'Z026' then t.unit4
           when k.productgroup = 'Z027' then r.unit4
           end                                                                            as MaterialBaseUnit2,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit3'
      case when k.productgroup = 'Z025' then q.mach
           when k.productgroup = 'Z027' then r.mach
           else cast( 0 as abap.quan( 13, 3 ) ) end                                       as totmacstock,
      case when k.productgroup = 'Z025' then q.unit3
           when k.productgroup = 'Z027' then r.unit3
           end                                                                            as MaterialBaseUnit3,
      j.contno                                                                            as contno,
      v.moc                                                                               as moc,
      ---Old Logic---
      //      p.DeliveryDate                                                                      as comdeldt,

      ---New Logic---
      ( case when x.CommittedDeliveryDate is initial then p.DeliveryDate
             else x.CommittedDeliveryDate end )                                           as comdeldt,

      case when f.packinglist is not initial
           then cast( 'Packing' as abap.char( 20 ) )
           else cast( 'Delivery' as abap.char( 20 ) ) end                                 as transtyp,
      o.PlantName                                                                         as produnit,
      g.ptnirs                                                                            as ptnirs,
      b.ReferenceSDDocument                                                               as salesord,
      h.PurchaseOrderByCustomer                                                           as cusrefno,
      h.CreationDate                                                                      as cusorddt,
      i.MaterialByCustomer                                                                as cusdesc,
      case when h.OverallSDProcessStatus = 'C' then cast( 'Complete' as abap.char(20) )
           when h.OverallSDProcessStatus = 'B' then cast( 'In-Progress' as abap.char(20) )
           when h.OverallSDProcessStatus = 'A' then cast( 'Not Yet Processed' as abap.char(20) )
           else cast( 'Not-Relevant' as abap.char(20) ) end                               as ordstatus,
      g.typeofmould                                                                       as mouldtype,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      d.GrossWeight                                                                       as bunchwt,

      ---Old Logic---
      //      g.subcode                                                                           as subrescode,
      //      g.typeofmould                                                                       as typeofmould,
      //      g.qtyperbox                                                                         as qtyperbox,
      ---New Logic---
      l1.Cast_SubCode                                                                     as subrescode,
      l1.Cast_TypeMould                                                                   as typeofmould,
      l1.Cast_QtyPerBox                                                                   as qtyperbox,

      @Semantics.quantity.unitOfMeasure: 'WeightUnit1'
      case when n.ProductGroup = 'Z025' then n.NetWeight
           else cast( 0 as abap.quan( 13, 3 ) ) end                                       as unitweight,
      n.WeightUnit                                                                        as WeightUnit1,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit1'
      case when n.ProductGroup = 'Z025' then cast( ( n.NetWeight * b.ActualDeliveryQuantity ) as abap.quan( 13, 3 ) )
           else cast( 0 as abap.quan( 13, 3 ) ) end                                       as totordweight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit1'
      case when n.ProductGroup = 'Z025' then cast( ( n.NetWeight * e.qty ) as abap.quan( 13, 3 ) )
           else cast( 0 as abap.quan( 13, 3 ) ) end                                       as totfgweight,
      b.Product                                                                           as fgcode
}
//where
//       a.OverallGoodsMovementStatus = 'A'
//  and i.SalesDocumentRjcnReason    is initial
//  and  p.DeliveryDate               is not initial
//  and(
//       k.productgroup               = 'Z025'
//    or k.productgroup               = 'Z026'
//    or k.productgroup               = 'Z027'
//    or k.productgroup               = 'Z028'
//  )
//  
 