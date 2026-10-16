@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sub Contracting-Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SUBCONTRRPT
  as select from ZI_SUBCONTRRPT_2

{
  key  Trans_Type,
  key  PO_No,
  key  PO_Item_No,
  key  Plant_Code,
  key  Plant_Name,
  key  Material_Code,
  key  Material_Desc,
  key  GoodsMovementType,
  key  ( case when First_Issued_Date = '00000000' then ''
              else cast( First_Issued_Date as abap.dats ) end )    as First_Issued_Date,
  key  Comp_Reqd_Qty,
  key  Comp_Reqd_Qty_UOM,
  key  Withd_Qty,
  key  Withd_Qty_Unit,
  key  Recvd_Mat_Code,
  key  Recvd_Mat_Name,
  key  Supplier,
  key  SupplierName,
  key  ( case when PO_Date = '00000000' then ''
              else cast( PO_Date as abap.dats ) end )              as PO_Date,
       PO_UOM,
       PO_Qty,
       ( case when Latest_Received_Date = '00000000' then ''
              else cast( Latest_Received_Date as abap.dats ) end ) as Latest_Received_Date,
       Received_UOM,
       Received_Qty
}
