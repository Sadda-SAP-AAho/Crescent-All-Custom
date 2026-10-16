@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Job Work-Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_JOBWRKRPT
  as select distinct from ZI_JOBWRKRPT_1
{
  key  Trans_Type,
  key  PO_No,
  key  PO_Item_No,
  key  Plant_Code,
  key  Plant_Name,
  key  Material_Code,
  key  Material_Desc,
  key  GoodsMovementType,
  key  ChallanNo,
  key  ( case when ChallanDate = '00000000' then ''
            else cast( ChallanDate as abap.dats ) end )               as ChallanDate,
  key  MaterialDocument,
  key  MatlDocDate,
  key  MatlValue,
  key  IGST_Value,
  key  CGST_Value,
  key  SGST_Value,
  key  Withd_Qty,
  key  Withd_Qty_Unit,
  key  Recvd_Mat_Code,
  key  Recvd_Mat_Name,
  key  Supplier,
  key  SupplierName,
  key  Supp_GST,
  key  ( case when PO_Date = '00000000' then ''
            else cast( PO_Date as abap.dats ) end )                   as PO_Date,
       PO_UOM,
       PO_Qty,
       ( case when Latest_Received_Date = '00000000' then ''
                 else cast( Latest_Received_Date as abap.dats ) end ) as Latest_Received_Date,
       Received_UOM,
       Received_Qty
}
