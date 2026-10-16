@AbapCatalog.sqlViewName: 'ZPRODORDRRPT1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Prod Order Report-1'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_PRODORDRRPT_1
  as select distinct from ZTBL_FCTN_PROD_ITEM      as a
    left outer join       ZTBL_FCTN_PROD_COMPONENT as b on a.ProductionOrder = b.ProductionOrder
    left outer join       ZTBL_FCTN_BOM_DETAILS    as c on  a.Product                  = c.Material
                                                        and b.BillOfMaterialItemNumber = c.BillOfMaterialItemNumber
                                                        and b.BillOfMaterialInternalID = c.BillOfMaterial
                                                        and b.Plant                    = c.Plant

    left outer join       I_ProductText            as d on a.Product = d.Product
    left outer join       I_ProductText            as e on b.Material = e.Product
    left outer join       I_UnitOfMeasure          as f on c.BillOfMaterialItemUnit = f.UnitOfMeasure
    inner join            ZTBL_FCTN_PROD_ORDR      as g on  a.ProductionOrder = g.ProductionOrder
                                                        and a.Product         = g.Product
                                                        and a.ProductionPlant = g.ProductionPlant
    left outer join       I_OrderTypeText          as h on  g.ProductionOrderType = h.OrderType
                                                        and h.Language            = 'E'
    left outer join       I_ProfitCenterText       as i on  g.ProfitCenter = i.ProfitCenter
                                                        and i.Language     = 'E'
    left outer join       I_BusinessUserBasic      as j on j.UserID = g.CreatedByUser
    left outer join       I_BusinessUserBasic      as k on k.UserID = g.LastChangedByUser
    left outer join       I_ProductGroupText_2     as l on  b.MaterialGroup = l.ProductGroup
                                                        and l.Language      = 'E'
    left outer join       ZI_PRODORDRSTATUS        as m on  a.ProductionOrder = m.ProductionOrder
                                                        and m.Status          is not null



{
  key a.ProductionOrder,
  key a.ProductionOrderItem,
  key a.Product,
  key d.ProductName                                                                                                                                                                                as Prod_Desc,
  key a.ProductionPlant,
  key b.Reservation,
  key b.ReservationItem,
  key b.BillOfMaterialInternalID,
  key b.BillOfMaterialItemNumber,
  key b.Material,
      e.ProductName                                                                                                                                                                                as Mat_Desc,
      l.ProductGroupText,
      g.ProductionOrderType,
      h.OrderTypeName,
      j.PersonFullName                                                                                                                                                                             as CreatedBy,
      g.CreationDate,
      k.PersonFullName                                                                                                                                                                             as LastUpdatedBy,
      g.LastChangeDate,
      b.StorageLocation                                                                                                                                                                            as CompStrgLoc,
      g.PlannedOrder,
      g.ProfitCenter,
      i.ProfitCenterName                                                                                                                                                                           as Profit_Center_Name,
      g.OrderActualReleaseDate,
      m.Status                                                                                                                                                                                     as OrdStatus,
      a.PlannedTotalQty,
      a.GoodsReceiptQty,
      ( case when m.Status = 'Closed/Teco' then cast( 0 as abap.dec(12,3) )
             else cast( a.OpenYieldQuantity as abap.dec(12,3) ) end )                                                                                                                              as OpenYieldQuantity,
      //      a.OpenYieldQuantity,
      b.RequiredQuantity,
      b.WithdrawnQuantity,
      b.WithdrawnQuantityAmount,
      ( case when b.ReservationIsFinallyIssued = 'X' then 'Yes' else 'No' end )                                                                                                                    as Final_Issued,
      c.BillOfMaterialItemQuantity,
      f.UnitOfMeasure_E,
      ( cast( division(cast( b.RequiredQuantity as abap.dec( 13, 3) ) , cast( a.PlannedTotalQty as abap.dec( 13, 3) ) , 3 ) as abap.dec( 13, 3 ) ) )                                               as Comp_Qty_Based_on_Order,
      ( cast( division(cast( b.RequiredQuantity as abap.dec( 13, 3) ) , cast( a.PlannedTotalQty as abap.dec( 13, 3) ) , 3 ) as abap.dec( 13, 3 ) ) * a.GoodsReceiptQty )                           as Planned_Qty_as_Per_Order,
      ( ( cast( division(cast( b.RequiredQuantity as abap.dec( 13, 3) ) , cast( a.PlannedTotalQty as abap.dec( 13, 3) ) , 3 ) as abap.dec( 13, 3 ) ) * a.GoodsReceiptQty ) - b.WithdrawnQuantity ) as Issued_Qty_Diff,
      cast (a.PlannedTotalQty as abap.dec(13,3) ) * cast (c.BillOfMaterialItemQuantity as abap.dec(13,3) )                                                                                         as Planned_Qty_as_Per_BOM,
      cast (a.GoodsReceiptQty as abap.dec(13,3) ) * cast (c.BillOfMaterialItemQuantity as abap.dec(13,3) )                                                                                         as Issued_Qty_as_Per_BOM,
      cast (b.WithdrawnQuantity as abap.dec(13,3) ) - cast (a.GoodsReceiptQty as abap.dec(13,3) ) * cast (c.BillOfMaterialItemQuantity as abap.dec(13,3) )                                         as Issued_Qty_Difference
}
