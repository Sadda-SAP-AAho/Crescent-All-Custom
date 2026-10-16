@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Commitment Report'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_SALESCOMMRPT
  provider contract transactional_query
  as projection on ZI_SALESCOMMRPT

{
      @UI.hidden: true
  key Requestuuid,
      @UI.hidden: true
  key Line_item_no,
      @EndUserText.label: 'Commitment Code'
      docnum,
      @EndUserText.label: 'Commitment Name'
      sales_comm_name,
      @EndUserText.label: 'Sales Employee'
      Sales_employee_name,
      @EndUserText.label: 'Commitment Type'
      commitment_type,
      @EndUserText.label: 'Financial Year'
      Fiscal_year,
      @EndUserText.label: 'Created By'
      Created_by,
      @EndUserText.label: 'Customer Code'
      Customer_Code,
      @EndUserText.label:'Plant Code'
      plantcode,
      @EndUserText.label:'Profit Center'
      profitcenter,
      @EndUserText.label: 'Material Code'
      matcode,
      @EndUserText.label: 'April'
      April_w,
      @EndUserText.label: 'May'
      May_w,
      @EndUserText.label: 'June'
      June_w,
      @EndUserText.label: 'July'
      July_w,
      @EndUserText.label: 'August'
      Aug_w,
      @EndUserText.label: 'September'
      Sept_w,
      @EndUserText.label: 'October'
      Oct_w,
      @EndUserText.label: 'November'
      Nov_w,
      @EndUserText.label: 'December'
      Dec_w,
      @EndUserText.label: 'January'
      Jan_w,
      @EndUserText.label: 'February'
      Feb_w,
      @EndUserText.label: 'March'
      March_w
}
