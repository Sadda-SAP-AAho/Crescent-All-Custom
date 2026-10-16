@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OTIF Report - INSIA'
@Search.searchable: true
define view entity ZC_OTIFINSIA
  as select distinct from ZI_OTIFINSIA
{
      @EndUserText.label: 'Sales Order No'
  key SO_No,
      @EndUserText.label: 'Sales Order Item'
  key SO_Line_No,
      @UI.hidden: true
  key Delv_No,
      @UI.hidden: true
  key Delv_Line_No,
      @EndUserText.label: 'SO Date'
      SO_Date,
      @EndUserText.label: 'SO Create Date'
      SO_Creation_Date,
      @EndUserText.label: 'SO Update Date'
      SO_Update_Date,
      @EndUserText.label: 'Customer'
      Customer,
      @EndUserText.label: 'Material No'
      Mat_No,
      @EndUserText.label: 'Description'
      Description,
      @EndUserText.label: 'Customer Material Desc.'
      Customer_Matl_Desc,
      @EndUserText.label: 'Quantity'
      Quantity,
      @EndUserText.label: 'Delivered Qty'
      Delivered_Qty,
      @EndUserText.label: 'Open Qty'
      Open_Qty,
      @EndUserText.label: 'Cust Ord No'
      Customer_PO_No,
      @EndUserText.label: 'Cust Ord Date'
      Customer_PO_Date,
      @EndUserText.label: 'Our Commited Del Dt'
      Our_Comm_Date,
      @EndUserText.label: 'OTIF'
      OTIF
}
