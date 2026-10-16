@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Regiester Short Form Report'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SOPCKLSTRPT
  as select from    I_SalesOrder           as a
    inner join      I_SalesOrderItem       as b on a.SalesOrder = b.SalesOrder
    inner join      I_ProductText          as c on  b.Material = c.Product
                                                and c.Language = 'E'
    left outer join I_OutboundDeliveryItem as d on  a.SalesOrder     = d.ReferenceSDDocument
                                                and b.SalesOrderItem = d.ReferenceSDDocumentItem
    left outer join I_OutboundDelivery     as e on d.OutboundDelivery = e.OutboundDelivery

    left outer join ZCDS_REJECTION_REASON  as f on  f.SalesDocument     = a.SalesOrder
                                                and f.SalesDocumentItem = b.SalesOrderItem
{
  key a.SalesOrder               as so_no,
  key b.SalesOrderItem           as so_item,
  key e.OutboundDelivery         as outbnd_no,
  key d.OutboundDeliveryItem     as outbnd_Item,
      a.CreationDate             as so_dt,
      a.SoldToParty              as cust_code,
      b.Material                 as mat_code,
      c.ProductName              as mat_des,
      b.OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      b.OrderQuantity            as ord_qty,
      e.CreationDate             as outbnd_dt,
      d.DeliveryQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      d.OriginalDeliveryQuantity as outbnd_qty
}
where
  f.SalesDocumentRjcnReasonName is null
