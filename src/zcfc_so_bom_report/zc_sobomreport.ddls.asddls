@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO wise BOM Report'
@Metadata.allowExtensions: true

define view entity ZC_SOBOMREPORT
  with parameters
    P_SO : abap.numc(10)

  as select from ZI_SOBOMREPORT( P_SO: $parameters.P_SO )
{
      @EndUserText.label: 'SO_No'
      @Search.defaultSearchElement: true
  key SO_No,
      @EndUserText.label: 'SO_Row_Number'
  key SO_Row_Number,
      @EndUserText.label: 'SO_Dt'
      SO_Dt,
      @EndUserText.label: 'Del_Dt'
      Del_Dt,
      @EndUserText.label: 'Customer_Code'
      Customer_Code,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Material_No'
      Material_No,
      @EndUserText.label: 'Material_Name'
      Material_Name,
      @EndUserText.label: 'SO_Open_Qty'
      SO_Open_Qty,
      @EndUserText.label: 'Order_Quantity_Unit'
      OrderQuantityunit,
      @EndUserText.label: 'Profit_Center_Name'
      Profit_Center_Name,
      @EndUserText.label: 'Our_Committed_Del_Date'
      Our_Committed_Del_Date,
      @EndUserText.label: 'Component_Material_Code'
      Component_Material_Code,
      @EndUserText.label: 'Component_Material_name'
      Component_Material_Name,
      @EndUserText.label: 'Component_Qty'
      Component_Qty,
      @EndUserText.label: 'Component_Material_Group_Name'
      Component_Material_Group_Name,
      @EndUserText.label: 'Component_Stock'
      Component_Stock,
      @EndUserText.label: 'PR_No'
      PR_No,
      @EndUserText.label: 'PR_Date'
      PR_Date,
      @EndUserText.label: 'PR_Qty'
      PR_Qty,
      @EndUserText.label: 'Open_PO_Qty'
      Open_PO_Qty,
      @EndUserText.label: 'Open_PR_Qty'
      Open_PR_Qty,
      @EndUserText.label: 'Pallet_PCD_Box_Size'
      Pallet_PCD_Box_Size,
      @EndUserText.label: 'BOLT_SIZE'
      BOLT_SIZE,
      @EndUserText.label: 'Qty_of_Pallet_PCD_Box'
      Qty_of_Pallet_PCD_Box,
      @EndUserText.label: 'Std_No_of_Pcs_Pack'
      Std_No_of_Pcs_Pack,
      @EndUserText.label: 'Qty_of_Bolt'
      Qty_of_Bolt,
      @EndUserText.label: 'BOLT_REQD'
      BOLT_REQD,
      @EndUserText.label: 'PALLET_REQD'
      PALLET_REQD,
      @EndUserText.label: 'SHOP_FLOOR_NO'
      SHOP_FLOOR_NO
}
