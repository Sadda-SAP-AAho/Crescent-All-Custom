@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Open Sales Order stock'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_PLAN_RPT_1_3
  as select from    I_SalesOrder             as a
    inner join      I_SalesOrderItem         as b on a.SalesOrder = b.SalesOrder
    inner join      I_SalesOrderScheduleLine as c on  c.SalesOrder     = b.SalesOrder
                                                  and c.SalesOrderItem = b.SalesOrderItem
    left outer join ZCDS_SOPENSO_DELQTY      as d on  b.SalesOrder     = d.ReferenceSDDocument
                                                  and b.SalesOrderItem = d.ReferenceSDDocumentItem
    left outer join I_ProductPlantBasic      as e on  e.Product = b.Product
                                                  and e.Plant   = b.Plant
  //    left outer join ZCDS_SOPENSO_DELQTY1     as d on  b.SalesOrder     = d.ReferenceSDDocument
  //                                                  and b.SalesOrderItem = d.ReferenceSDDocumentItem
  //                                                  and d.balanceqty     is not initial
{
  key (case when e.SpecialProcurementType = '40' then '1100'
                    else b.Plant end)                                                    as Plant,
  key b.SalesOrder,
  key b.SalesOrderItem,
      //  key         c.ScheduleLine,
      c.ScheduleLineCategory,
      b.Product,
      //            max(c.DeliveryDate)                                                                as reqdeldate,
      max( ( case when b.YY1_OTIFDate_SDI is initial then c.DeliveryDate
             else b.YY1_OTIFDate_SDI end ) )                                             as reqdeldate,
      b.OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      cast( ( coalesce( cast(b.OrderQuantity as abap.dec(13,3 )) , 0 ) -
              coalesce( cast(d.delivqty as abap.dec(13,3)), 0 ) ) as abap.dec( 13, 3 ) ) as balanceqty
}
where
      b.SalesDocumentRjcnReason =  ''
  //  //  and c.RequestedDeliveryDate            >= $session.system_date
  //  and d.balanceqty              is not initial
  //  and c.RequestedDeliveryDate   is not initial

  and c.ScheduleLineCategory    <> 'CN'
//  and a.SDDocumentReason        <> 'Z07'

group by
  b.Plant,
  e.SpecialProcurementType,
  b.SalesOrder,
  b.SalesOrderItem,
  //  c.ScheduleLine,
  c.ScheduleLineCategory,
  b.Product,
  b.OrderQuantityUnit,
  b.OrderQuantity,
  d.delivqty
