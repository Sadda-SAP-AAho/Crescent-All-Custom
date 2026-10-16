@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sub Contracting-Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_SUBCONTRRPT
  provider contract transactional_query
  as projection on ZI_SUBCONTRRPT
{
       @EndUserText.label: 'Transaction Type'
  key  Trans_Type,
       @EndUserText.label: 'Purchasing Document'
       @Search.defaultSearchElement: true
  key  PO_No,
       @EndUserText.label: 'Purchasing Document Item'
  key  PO_Item_No,
       @EndUserText.label: 'Plant Code'
  key  Plant_Code,
       @EndUserText.label: 'Plant Name'
  key  Plant_Name,
       @EndUserText.label: 'Material Number'
  key  Material_Code,
       @EndUserText.label: 'Material Description'
  key  Material_Desc,
       @EndUserText.label: 'Movement Type'
  key  GoodsMovementType,
       @EndUserText.label: 'First Issued Date'
  key  First_Issued_Date,
       @EndUserText.label: 'Component Reqd. Qty'
  key  Comp_Reqd_Qty,
       @EndUserText.label: 'Comp. Reqd. Qty. UOM'
  key  Comp_Reqd_Qty_UOM,
       @EndUserText.label: 'Withdrawn Quantity'
  key  Withd_Qty,
       @EndUserText.label: 'Withd. Qty. UOM'
  key  Withd_Qty_Unit,
       @EndUserText.label: 'Received Material Number'
  key  Recvd_Mat_Code,
       @EndUserText.label: 'Received Material Description'
  key  Recvd_Mat_Name,
       @EndUserText.label: 'Supplier Code'
  key  Supplier,
       @EndUserText.label: 'Supplier Name'
  key  SupplierName,
       @EndUserText.label: 'Purchase Order Date'
  key  PO_Date,
       @UI.hidden: true
       PO_UOM,
       @EndUserText.label: 'PO Qty'
       PO_Qty,
       @EndUserText.label: 'Latest Received Date'
       Latest_Received_Date,
       @UI.hidden: true
       Received_UOM,
       @EndUserText.label: 'Received Qty'
       Received_Qty

}
