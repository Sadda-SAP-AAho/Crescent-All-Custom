@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OTIF Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OTIF_REPORT
  as select distinct from I_SalesOrderItem     as a
    inner join            I_SalesOrder         as b  on b.SalesOrder = a.SalesOrder
    inner join            I_SalesDocumentItem  as y  on  y.SalesDocument     = a.SalesOrder
                                                     and y.SalesDocumentItem = a.SalesOrderItem
    inner join            ZI_SD_OTIF_REPORT_1  as z  on  z.SalesOrder     = a.SalesOrder
                                                     and z.SalesOrderItem = a.SalesOrderItem
    left outer join       I_ProfitCenterText   as c  on  c.ProfitCenter = a.ProfitCenter
                                                     and c.Language     = 'E'
    left outer join       I_Product            as d  on d.Product = a.Product
    left outer join       I_SalesDocumentItem  as e  on  e.SalesDocument     = a.SalesOrder
                                                     and e.SalesDocumentItem = a.SalesOrderItem
  //    left outer join I_DeliveryDocumentItem as f  on  f.ReferenceSDDocument     = a.SalesOrder
  //                                                 and f.ReferenceSDDocumentItem = a.SalesOrderItem
    left outer join       ZI_SD_OTIF_REPORT_11 as f  on  f.ReferenceSDDocument     = a.SalesOrder
                                                     and f.ReferenceSDDocumentItem = a.SalesOrderItem
    left outer join       ZI_PACKLIST_HDR      as g  on  g.Delivery =  f.DeliveryDocument
                                                     and g.Canind   <> 'X'
  //    left outer join ZI_SD_OTIF_REPORT_8    as g  on  g.ReferenceSDDocument     = a.SalesOrder
  //                                                 and g.ReferenceSDDocumentItem = a.SalesOrderItem
    left outer join       ZI_DELDASH_HDR       as h  on  h.Delivery =  f.DeliveryDocument
                                                     and h.Canind   <> 'X'
  //    left outer join ZI_SD_OTIF_REPORT_10    as h  on  h.ReferenceSDDocument     = a.SalesOrder
  //                                                 and h.ReferenceSDDocumentItem = a.SalesOrderItem
    left outer join       ZI_SD_OTIF_REPORT_2  as i  on  i.SalesOrder     = a.SalesOrder
                                                     and i.SalesOrderItem = a.SalesOrderItem
    left outer join       ztmg_salesgrp        as j  on  j.salesgroup            =  b.SalesGroup
                                                     and j.configdeprecationcode <> 'E'
    left outer join       ZI_SD_OTIF_REPORT_3  as k  on  k.SalesOrder     = a.SalesOrder
                                                     and k.SalesOrderItem = a.SalesOrderItem
    left outer join       ZCDS_SOPENSO_DELQTY1 as z1 on  z1.ReferenceSDDocument     = a.SalesOrder
                                                     and z1.ReferenceSDDocumentItem = a.SalesOrderItem
{
  key a.SalesOrder,
  key a.SalesOrderItem,
      // key z.ScheduleLine,
  key f.DeliveryDocument,
  key '00010'                                                              as DeliveryDocumentItem, //Changed by SP on 14.08.25
      b.CreationDate,
      cast( 'O' as abap.char( 1 ) )                                        as DocStatus,
      b.SoldToParty,
      a.Product,
      a.SalesOrderItemText,
      c.ProfitCenterName,
      cast( a.OrderQuantity as abap.dec( 13, 3 ) )                         as ScheduleLineOrderQuantity,
      //z.DeliveredQtyInOrderQtyUnit,
      cast( z1.delivqty  as abap.dec( 13, 3 ) )                            as DeliveredQtyInOrderQtyUnit,
      //z.OpenConfdDelivQtyInOrdQtyUnit,
      cast( z1.balanceqty as abap.dec( 13, 3 ) )                           as OpenConfdDelivQtyInOrdQtyUnit,
      cast( ( a.OrderQuantity * d.NetWeight ) as abap.dec( 23, 3 ) )       as orderwt,
      cast( ( z1.balanceqty * d.NetWeight ) as abap.dec( 23, 3 ) )         as openwt,
      a.PurchaseOrderByCustomer,
      a.CustomerPurchaseOrderDate,
      j.salesperson,
      e.YY1_CustomerRequiredDe_SDI,
      
      ( case when a.YY1_OTIFDate_SDI is initial
             then ( case when z.ConfirmedDeliveryDate is initial
                         then $session.system_date
                         else z.ConfirmedDeliveryDate end )
             else a.YY1_OTIFDate_SDI end )                                 as ConfirmedDeliveryDate,
             
      cast( ( k.otfamt * b.PriceDetnExchangeRate ) as abap.dec( 23, 2 ) )  as otiframt,
      cast( ( k.otfamt1 * b.PriceDetnExchangeRate ) as abap.dec( 23, 2 ) ) as otiframt1,
      e.YY1_ItemPaintInformati_SDI,
      g.Packinglist,
      g.Createdon,
      h.Salesnoteref,
      i.MatlWrhsStkQtyInMatlBaseUnit,
      ( case when z.ScheduleLineCategory = 'CP' then 'N'
             when z.ScheduleLineCategory = 'CN' then 'Y' else '' end )     as soholdstatus,
      $session.system_date                                                 as systemdate
}
where
       y.SalesDocumentRjcnReason is initial
  and  b.SDDocumentReason        <> 'Z07'
  and(
       d.ProductType             =  'ZFG'
    or d.ProductType             =  'ZTRD'
  )
