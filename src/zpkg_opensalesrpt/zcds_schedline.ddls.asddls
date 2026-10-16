@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view for schedule line details'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_SCHEDLINE
  as select distinct from I_SalesOrder             as a
    inner join            I_SalesOrderItem         as b on a.SalesOrder = b.SalesOrder
    inner join            I_Product                as d on b.Product = d.Product
    inner join            I_SalesOrderScheduleLine as c on  c.SalesOrder     = b.SalesOrder
                                                        and c.SalesOrderItem = b.SalesOrderItem
    left outer join       ZCDS_BALANCEVAL          as f on  f.SalesDocument     = b.SalesOrder
                                                        and f.SalesDocumentItem = b.SalesOrderItem
  //    inner join            ZCDS_BALANCEVALDC        as e on e.SalesOrder = b.SalesOrder
  //                                                        and e.SalesOrderItem = b.SalesOrderItem

{
  key         b.SalesOrder,
  key         b.SalesOrderItem,
  key         c.ScheduleLine,
              c.ScheduleLineCategory,
              @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
              c.ScheduleLineOrderQuantity,         
              b.OrderQuantityUnit,
              b.Product,
              @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
              d.NetWeight,
              @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
              c.OpenReqdDelivQtyInOrdQtyUnit,
//              @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
              cast(f.unitprice * c.OpenReqdDelivQtyInOrdQtyUnit as abap.dec(13,2)) as balancevaldc,
//              @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
              cast(cast(f.unitprice * c.OpenReqdDelivQtyInOrdQtyUnit as abap.dec(13,2) )  *
              cast(a.PriceDetnExchangeRate as abap.dec(5,2) ) as abap.dec(13,2) ) as balancevallc,
              @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
              c.DeliveredQtyInOrderQtyUnit,
              @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
              ( cast(c.OpenReqdDelivQtyInOrdQtyUnit as abap.dec(13,2))  *
                cast(d.NetWeight as abap.dec(13,2)) )                             as balancewt,
              ( cast(b.OrderQuantity as abap.dec(13,0))  *
                cast(d.NetWeight as abap.dec(13,3)) )                             as salesorderweight,
                
              case when c.ScheduleLineCategory  = 'CN' then 'YES' else 'NO' end   as soholdstat
}
where c.OpenConfdDelivQtyInOrdQtyUnit is not initial
group by
  b.SalesOrder,
  b.SalesOrderItem,
  c.ScheduleLine, 
//  c.ScheduleLineCategory,
  f.unitprice,
  a.PriceDetnExchangeRate,
  b.Product,
  d.NetWeight,
  b.OrderQuantity,
  b.OrderQuantityUnit,
  c.ScheduleLineOrderQuantity,  
  c.OpenReqdDelivQtyInOrdQtyUnit,
  c.DeliveredQtyInOrderQtyUnit,
  c.ScheduleLineCategory
