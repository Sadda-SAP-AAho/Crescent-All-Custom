@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View for balance value amount in dc'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_BALANCEVALDC
  as select distinct from I_SalesOrder             as a
    left outer join       I_SalesOrderItem         as b on a.SalesOrder = b.SalesOrder
    left outer join       ZCDS_SCHEDLINE as c on c.SalesOrder = b.SalesOrder
                                              and c.SalesOrderItem = b.SalesOrderItem
    left outer join       ZCDS_BALANCEVAL          as d on d.SalesDocument = b.SalesOrder
                                                        and d.SalesDocumentItem = b.SalesOrderItem
                                                     

{

  key a.SalesOrder,
  key b.SalesOrderItem,
      b.OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      c.OpenReqdDelivQtyInOrdQtyUnit,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      c.DeliveredQtyInOrderQtyUnit,
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      (d.unitprice * c.OpenReqdDelivQtyInOrdQtyUnit) as balancevaldc
}

group by
  a.SalesOrder,
  b.SalesOrderItem,
  b.OrderQuantityUnit,
  d.unitprice,
  c.OpenReqdDelivQtyInOrdQtyUnit,
  c.DeliveredQtyInOrderQtyUnit
