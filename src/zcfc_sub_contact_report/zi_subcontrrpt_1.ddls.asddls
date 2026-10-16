@AbapCatalog.sqlViewName: 'ZSUBCONTRRPT1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sub Contracting-Report_1'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SUBCONTRRPT_1
  as select from    ZI_SUBCONISSUEDITM as a
    left outer join ZI_SUBCONRECVITM   as b on  a.PO_No      = b.PO_No
                                            and a.PO_Item_No = b.PO_Item_No
    left outer join I_UnitOfMeasure    as c on a.BaseUnit = c.UnitOfMeasure
{
  key  cast( 'Issued' as abap.char( 10 ) )          as Trans_Type,
  key  a.PO_No,
  key  cast( a.PO_Item_No as abap.char( 5 ) )       as PO_Item_No,
  key  a.Plant_Code,
  key  a.Plant_Name,
  key  a.Material_Code,
  key  a.Material_Desc,
  key  a.GoodsMovementType,
  key  a.First_Issued_Date,
  key  cast( a.Comp_Reqd_Qty as abap.dec( 15, 3 ) ) as Comp_Reqd_Qty,
  key  c.UnitOfMeasure_E                            as Comp_Reqd_Qty_UOM,
  key  cast( a.Withd_Qty as abap.dec( 15, 3 ) )     as Withd_Qty,
  key  c.UnitOfMeasure_E                            as Withd_Qty_Unit,
  key  b.Material_Code                              as Recvd_Mat_Code,
  key  b.Material_Desc                              as Recvd_Mat_Name,
  key  b.Supplier,
  key  b.SupplierName,
  key  b.PO_Date,
       b.PO_UOM,
       @Semantics.quantity.unitOfMeasure: 'PO_UOM'
       b.PO_Qty                                     as PO_Qty,
       b.Latest_Received_Date,
       b.Received_UOM,
       @Semantics.quantity.unitOfMeasure: 'Received_UOM'
       b.Received_Qty                               as Received_Qty

}
