@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Commitment Item Projection View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity Z_C_Sales_Cmmt_Item
  as projection on Z_I_SALES_COMMT_ITEM
{
  key Requestuuid,
  key Line_item_no,
      Customer_Code,
      Customer_Name,
      plantcode,
      plantname,
      profitcenter,
      matcode,
      matname,
      April_w,
      May_w,
      June_w,
      July_w,
      Aug_w,
      Sept_w,
      Oct_w,
      Nov_w,
      Dec_w,
      Jan_w,
      Feb_w,
      March_w,
      uom,
      Last_changed_at as Last_changed_at,
      _Sales : redirected to parent Z_C_Sales_Commitment


}
