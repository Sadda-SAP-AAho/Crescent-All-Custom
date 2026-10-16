@AbapCatalog.sqlViewName: 'ZSUBCONTRRPT2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sub Contracting-Report_2'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SUBCONTRRPT_2
  as select from ZI_SUBCONTRRPT_1
{
  key Trans_Type,
  key PO_No,
  key PO_Item_No,
  key Plant_Code,
  key Plant_Name,
  key Material_Code,
  key Material_Desc,
  key GoodsMovementType,
  key First_Issued_Date,
  key Comp_Reqd_Qty,
  key Comp_Reqd_Qty_UOM,
  key Withd_Qty,
  key Withd_Qty_Unit,
  key Recvd_Mat_Code,
  key Recvd_Mat_Name,
  key Supplier,
  key SupplierName,
  key PO_Date,
      PO_UOM,
      PO_Qty,
      Latest_Received_Date,
      Received_UOM,
      Received_Qty
}

union select from ZI_SUBCONDRCTRCVD

{
  key cast( 'Not Issued' as abap.char( 10 ) ) as Trans_Type,
  key PO_No                                   as PO_No,
  key PO_Item_No                              as PO_Item_No,
  key Plant_Code                              as Plant_Code,
  key Plant_Name                              as Plant_Name,
  key ''                                      as Material_Code,
  key ''                                      as Material_Desc,
  key GoodsMovementType,
  key ''                                      as First_Issued_Date,
  key cast( '0' as abap.dec( 15, 3 ) )        as Comp_Reqd_Qty,
  key ''                                      as Comp_Reqd_Qty_UOM,
  key cast( '0' as abap.dec( 15, 3 ) )        as Withd_Qty,
  key ''                                      as Withd_Qty_Unit,
  key Material_Code                           as Recvd_Mat_Code,
  key Material_Desc                           as Recvd_Mat_Name,
  key Supplier,
  key SupplierName,
  key PO_Date,
      PO_UOM,
      PO_Qty,
      Latest_Received_Date,
      Received_UOM,
      Received_Qty

}
where
  Status = 'Y'
