@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Commitment Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity  ZI_SALESCOMMRPT
  as select from Z_I_Sales_Commitment as a
    inner join   Z_I_SALES_COMMT_ITEM as b on a.Requestuuid = b.Requestuuid

{
  key a.Requestuuid,
  key b.Line_item_no,
      a.docnum,
      a.sales_comm_name,
      a.Sales_employee_name,
      a.commitment_type,
      a.Fiscal_year,
      a.Created_by,
      b.Customer_Code,
      b.plantcode,
      b.profitcenter,
      b.matcode,
      b.April_w,
      b.May_w,
      b.June_w,
      b.July_w,
      b.Aug_w,
      b.Sept_w,
      b.Oct_w,
      b.Nov_w,
      b.Dec_w,
      b.Jan_w,
      b.Feb_w,
      b.March_w

}
