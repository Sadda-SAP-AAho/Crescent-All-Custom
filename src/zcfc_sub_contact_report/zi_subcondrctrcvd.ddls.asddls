@AbapCatalog.sqlViewName: 'ZSUBCONDRCTRCVD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sub Contracting-Received Item(Direct)'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SUBCONDRCTRCVD
  as select distinct from I_MaterialDocumentItem_2 as a
    inner join            I_ProductText            as b on  b.Product  = a.Material
                                                        and b.Language = 'E'
    inner join            I_Plant                  as c on c.Plant = a.Plant
    inner join            I_Supplier               as d on d.Supplier = a.Supplier
    inner join            I_PurchaseOrderItemAPI01 as e on  e.PurchaseOrder     = a.PurchaseOrder
                                                        and e.PurchaseOrderItem = a.PurchaseOrderItem
    inner join            I_PurchaseOrderAPI01     as f on  f.PurchaseOrder     = e.PurchaseOrder
                                                        and f.Supplier          = a.Supplier
                                                        and f.PurchaseOrderType = 'ZSUB'
    inner join            ZI_SUBCONRECVLASTDT      as g on  g.PO_No      = a.PurchaseOrder
                                                        and g.PO_Item_No = a.PurchaseOrderItem
    left outer join       ZI_SUBCONTRRPT_1         as h on  h.PO_No      = a.PurchaseOrder
                                                        and h.PO_Item_No = a.PurchaseOrderItem


{
  key a.PurchaseOrder                                                                                          as PO_No,
  key a.PurchaseOrderItem                                                                                      as PO_Item_No,
  key a.Material                                                                                               as Material_Code,
  key b.ProductName                                                                                            as Material_Desc,
  key a.GoodsMovementType,
  key a.Plant                                                                                                  as Plant_Code,
  key c.PlantName                                                                                              as Plant_Name,
  key d.Supplier,
  key d.SupplierName,
  key f.PurchaseOrderDate                                                                                      as PO_Date,
  key e.BaseUnit                                                                                               as PO_UOM,
  key cast ( e.OrderQuantity as abap.dec(15,3) )                                                               as PO_Qty,
  key g.Latest_Received_Date,
      ( case when ( h.PO_No = a.PurchaseOrder and h.PO_Item_No = a.PurchaseOrderItem ) then 'X' else 'Y' end ) as Status,
      a.MaterialBaseUnit                                                                                       as Received_UOM,
      cast ( sum(a.QuantityInBaseUnit) as abap.dec(15,3) )                                                     as Received_Qty

}

where
      a.GoodsMovementType = '101'
  and a.DebitCreditCode   = 'S'

group by
  a.PurchaseOrder,
  a.PurchaseOrderItem,
  a.Material,
  b.ProductName,
  a.GoodsMovementType,
  a.Plant,
  c.PlantName,
  d.Supplier,
  d.SupplierName,
  f.PurchaseOrderDate,
  e.BaseUnit,
  e.OrderQuantity,
  g.Latest_Received_Date,
  h.PO_No,
  h.PO_Item_No,
  a.MaterialBaseUnit
