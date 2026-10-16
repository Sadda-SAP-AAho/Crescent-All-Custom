@AbapCatalog.sqlViewName: 'ZSUBCONISSUEDITM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sub Contracting-Issued Item'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SUBCONISSUEDITM
  as select distinct from I_MaterialDocumentItem_2    as a
    inner join            I_ProductText               as b on  b.Product  = a.Material
                                                           and b.Language = 'E'
    inner join            I_Plant                     as c on c.Plant = a.Plant
    left outer join       I_POSubcontractingCompAPI01 as g on  g.PurchaseOrder     = a.PurchaseOrder
                                                           and g.PurchaseOrderItem = a.PurchaseOrderItem
                                                           and g.Material          = a.Material
    inner join            ZI_SUBCONISSUFRSTDT         as h on  h.PO_No             = a.PurchaseOrder
                                                           and h.PO_Item_No        = a.PurchaseOrderItem
                                                           and h.Plant_Code        = a.Plant
                                                           and h.GoodsMovementType = a.GoodsMovementType


{
  key a.PurchaseOrder                                       as PO_No,
  key a.PurchaseOrderItem                                   as PO_Item_No,
  key a.Plant                                               as Plant_Code,
  key c.PlantName                                           as Plant_Name,
  key a.Material                                            as Material_Code,
      b.ProductName                                         as Material_Desc,
      a.GoodsMovementType,
      h.First_Issued_Date,
      a.MaterialBaseUnit                                    as BaseUnit,
      cast ( g.RequiredQuantity as abap.dec(15,3) )         as Comp_Reqd_Qty,
      cast ( sum(a.QuantityInEntryUnit) as abap.dec(15,3) ) as Withd_Qty

}
where
      a.GoodsMovementType = '541'
  and a.DebitCreditCode   = 'H'

group by
  a.PurchaseOrder,
  a.PurchaseOrderItem,
  a.Plant,
  c.PlantName,
  a.Reservation,
  a.ReservationItem,
  a.Material,
  b.ProductName,
  a.GoodsMovementType,
  h.First_Issued_Date,
  a.MaterialBaseUnit,
  g.RequiredQuantity
  
  
union select distinct from I_MaterialDocumentItem_2    as a
    inner join            I_ProductText               as b on  b.Product  = a.Material
                                                           and b.Language = 'E'
    inner join            I_Plant                     as c on c.Plant = a.Plant
    left outer join       I_POSubcontractingCompAPI01 as g on  g.PurchaseOrder     = a.PurchaseOrder
                                                           and g.PurchaseOrderItem = a.PurchaseOrderItem
                                                           and g.Material          = a.Material
    inner join            ZI_SUBCONISSUFRSTDT         as h on  h.PO_No             = a.PurchaseOrder
                                                           and h.PO_Item_No        = a.PurchaseOrderItem
                                                           and h.Plant_Code        = a.Plant
                                                           and h.GoodsMovementType = a.GoodsMovementType


{
  key a.PurchaseOrder                                       as PO_No,
  key a.PurchaseOrderItem                                   as PO_Item_No,
  key a.Plant                                               as Plant_Code,
  key c.PlantName                                           as Plant_Name,
  key a.Material                                            as Material_Code,
      b.ProductName                                         as Material_Desc,
      a.GoodsMovementType,
      h.First_Issued_Date,
      a.MaterialBaseUnit                                    as BaseUnit,
      cast ( g.RequiredQuantity as abap.dec(15,3) )         as Comp_Reqd_Qty,
      cast ( sum(a.QuantityInEntryUnit) as abap.dec(15,3) ) as Withd_Qty

}
where
      a.GoodsMovementType = '544'
  and a.DebitCreditCode   = 'S'

group by
  a.PurchaseOrder,
  a.PurchaseOrderItem,
  a.Plant,
  c.PlantName,
  a.Reservation,
  a.ReservationItem,
  a.Material,
  b.ProductName,
  a.GoodsMovementType,
  h.First_Issued_Date,
  a.MaterialBaseUnit,
  g.RequiredQuantity  
  
  
 union select distinct from I_MaterialDocumentItem_2    as a
  inner join               I_ProductText               as b on  b.Product  = a.Material
                                                            and b.Language = 'E'
  inner join               I_Plant                     as c on c.Plant = a.Plant
  left outer join          I_POSubcontractingCompAPI01 as g on  g.PurchaseOrder     = a.PurchaseOrder
                                                            and g.PurchaseOrderItem = a.PurchaseOrderItem
                                                            and g.Material          = a.Material
  inner join               ZI_SUBCONISSUFRSTDT         as h on  h.PO_No             = a.PurchaseOrder
                                                            and h.PO_Item_No        = a.PurchaseOrderItem
                                                            and h.Plant_Code        = a.Plant
                                                            and h.GoodsMovementType = a.GoodsMovementType


{
  key a.PurchaseOrder                                                as PO_No,
  key a.PurchaseOrderItem                                            as PO_Item_No,
  key a.Plant                                                        as Plant_Code,
  key c.PlantName                                                    as Plant_Name,
  key a.Material                                                     as Material_Code,
      b.ProductName                                                  as Material_Desc,
      a.GoodsMovementType,
      h.First_Issued_Date,
      a.MaterialBaseUnit                                             as BaseUnit,
      cast ( g.RequiredQuantity as abap.dec(15,3) )                  as Comp_Reqd_Qty,
      cast ( sum(a.QuantityInEntryUnit) as abap.dec(15,3) ) * ( -1 ) as Withd_Qty

}
where
  (
       a.GoodsMovementType = '543'
    or a.GoodsMovementType = '542'
  )
  and  a.DebitCreditCode   = 'H'

group by
  a.PurchaseOrder,
  a.PurchaseOrderItem,
  a.Plant,
  c.PlantName,
  a.Reservation,
  a.ReservationItem,
  a.Material,
  b.ProductName,
  a.GoodsMovementType,
  h.First_Issued_Date,
  a.MaterialBaseUnit,
  g.RequiredQuantity 
