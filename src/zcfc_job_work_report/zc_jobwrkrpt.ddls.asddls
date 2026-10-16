@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Job Work-Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_JOBWRKRPT
  provider contract transactional_query
  as projection on ZI_JOBWRKRPT
{
      @EndUserText.label: 'Transaction Type'
  key Trans_Type,
      @EndUserText.label: 'Purchasing Document'
      @Search.defaultSearchElement: true
  key PO_No,
      @EndUserText.label: 'Purchasing Document Item'
  key PO_Item_No,
      @EndUserText.label: 'Plant Code'
  key Plant_Code,
      @EndUserText.label: 'Plant Name'
  key Plant_Name,
      @EndUserText.label: 'Material Number'
  key Material_Code,
      @EndUserText.label: 'Material Description'
  key Material_Desc,
      @EndUserText.label: 'Movement Type'
  key GoodsMovementType,
      @EndUserText.label: 'Challan No.'
  key ChallanNo,
      @EndUserText.label: 'Challan Date'
  key ChallanDate,
      @EndUserText.label: 'Matl. Doc. No.'
  key MaterialDocument,
      @EndUserText.label: 'Matl. Doc. Date'
  key MatlDocDate,
      @EndUserText.label: 'Matl. Value'
  key MatlValue,
      @EndUserText.label: 'IGST Value'
  key IGST_Value,
      @EndUserText.label: 'CGST Value'
  key CGST_Value,
      @EndUserText.label: 'SGST Value'
  key SGST_Value,
      @EndUserText.label: 'Withdrawn Quantity'
  key Withd_Qty,
      @EndUserText.label: 'Withd. Qty. UOM'
  key Withd_Qty_Unit,
      @EndUserText.label: 'Received Material Number'
  key Recvd_Mat_Code,
      @EndUserText.label: 'Received Material Description'
  key Recvd_Mat_Name,
      @EndUserText.label: 'Supplier Code'
  key Supplier,
      @EndUserText.label: 'Supplier Name'
  key SupplierName,
      @EndUserText.label: 'Supplier GSTN'
  key Supp_GST,
      @EndUserText.label: 'Purchase Order Date'
  key PO_Date,
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
