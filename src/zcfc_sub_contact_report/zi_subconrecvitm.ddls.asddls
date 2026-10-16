@AbapCatalog.sqlViewName: 'ZSUBCONRECVITM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sub Contracting-Received Item'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SUBCONRECVITM
  as select distinct from I_PurchaseOrderItemAPI01 as a
    inner join            I_ProductText            as b on  b.Product  = a.Material
                                                        and b.Language = 'E'
    inner join            I_Plant                  as c on c.Plant = a.Plant
    left outer join       I_MaterialDocumentItem_2 as d on  d.PurchaseOrder     = a.PurchaseOrder
                                                        and d.PurchaseOrderItem = a.PurchaseOrderItem
                                                        and d.GoodsMovementType = '101'
                                                        and d.DebitCreditCode   = 'S'
    inner join            I_PurchaseOrderAPI01     as e on e.PurchaseOrder = a.PurchaseOrder
    left outer join       I_Supplier               as f on f.Supplier = e.Supplier
    left outer join       ZI_SUBCONRECVLASTDT      as g on  g.PO_No      = a.PurchaseOrder
                                                        and g.PO_Item_No = a.PurchaseOrderItem
    left outer join       ZI_SUBCONRECVITM_2       as h on  h.PO_No      = a.PurchaseOrder
                                                        and h.PO_Item_No = a.PurchaseOrderItem


{
  key a.PurchaseOrder                                         as PO_No,
  key a.PurchaseOrderItem                                     as PO_Item_No,
      a.Material                                              as Material_Code,
      b.ProductName                                           as Material_Desc,
      a.Plant                                                 as Plant_Code,
      c.PlantName                                             as Plant_Name,
      e.Supplier,
      f.SupplierName,
      e.PurchaseOrderDate                                     as PO_Date,
      a.BaseUnit                                              as PO_UOM,
      cast ( a.OrderQuantity as abap.dec(15,3) )              as PO_Qty,
      g.Latest_Received_Date,
      d.MaterialBaseUnit                                      as Received_UOM,
      cast ( sum(d.QuantityInBaseUnit) as abap.dec(15,3) ) -
      cast ( coalesce( h.Received_Qty,0 ) as abap.dec(15,3) ) as Received_Qty

}

group by
  a.PurchaseOrder,
  a.PurchaseOrderItem,
  a.Material,
  b.ProductName,
  a.Plant,
  c.PlantName,
  e.Supplier,
  f.SupplierName,
  e.PurchaseOrderDate,
  a.BaseUnit,
  a.OrderQuantity,
  g.Latest_Received_Date,
  d.MaterialBaseUnit,
  h.Received_Qty
