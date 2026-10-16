@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order-wise Component Requirement Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE

define root view entity ZC_SOBOMCOMPRPT
  provider contract transactional_query
  as projection on ZI_SOBOMCOMPRPT
{
      @EndUserText.label: 'SO No'
      @Search.defaultSearchElement: true
  key SO_No,
      @EndUserText.label: 'SO Line No'
  key SO_Row_Number,
      @UI.hidden: true
  key MaterialCode,
      @EndUserText.label: 'SO Date'
      SO_Dt,
      @EndUserText.label: 'Delivery Date'
      Del_Dt,
      @EndUserText.label: 'Customer Code'
      Customer_Code,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Material No'
      Material_No,
      @EndUserText.label: 'Material Name'
      Material_Name,
      @EndUserText.label: 'SO Open Qty'
      SO_Open_Qty,
      @EndUserText.label: 'Order Quantity Unit'
      OrderQuantityunit,
      @EndUserText.label: 'Profit Center Name'
      Profit_Center_Name,
      @EndUserText.label: 'Our Committed Del Date'
      Our_Committed_Del_Date,
      @EndUserText.label: 'Component Material Code'
      Component_Material_Code,
      @EndUserText.label: 'Component Material name'
      Component_Material_Name,
      @EndUserText.label: 'Component Qty'
      Component_Qty,
      @EndUserText.label: 'Component Material Group Name'
      Component_Material_Group_Name,
      @EndUserText.label: 'Component Stock'
      Component_Stock,
      @EndUserText.label: 'PR No'
      PR_No,
      @EndUserText.label: 'PR Date'
      PR_Date,
      @EndUserText.label: 'PR Qty'
      PR_Qty,
      @EndUserText.label: 'Open PR Qty'
      Open_PR_Qty,
      @EndUserText.label: 'Open PO Qty'
      Open_PO_Qty
      
}
