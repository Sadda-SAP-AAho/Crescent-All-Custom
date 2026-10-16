@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report - Insia'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_DEBTORSINSIA
  provider contract transactional_query
  as projection on ZI_DEBTORSINSIA
{
      @UI.hidden: true
  key CompanyCode,
      @UI.hidden: true
  key FiscalYear,
      @EndUserText.label: 'Accounting Document'
      @Search.defaultSearchElement: true
  key Accounting_Document,
      @UI.hidden: true
  key AccountingDocumentItem,
      @EndUserText.label: 'Document Type'
  key Document_Type,
      @EndUserText.label: 'Document Type Name'
  key Document_Type_Name,
      @EndUserText.label: 'AR Invoice No.'
  key ARInvoice_No,
      @EndUserText.label: 'AR Invoice Date'
      ARInvoice_Date,
      @EndUserText.label: 'Delivery Invoice No'
      DelInvoice_No,
      @EndUserText.label: 'Delivery Invoice Ref '
      DelInvoice_No_Ref,
      @EndUserText.label: 'Create Date'
      Create_Date,
      @EndUserText.label: 'Update Date'
      Update_Date,
      @EndUserText.label: 'Document Reference'
      Document_Reference,
      @EndUserText.label: 'Customer Code'
      Customer_Code,
      @EndUserText.label: 'Customer Name'
      Customer_Name,
      @EndUserText.label: 'Sales Person'
      Sales_Person,
      @EndUserText.label: 'Currency'
      Currency,
      @EndUserText.label: 'FC Total'
      FC_Total,
      @EndUserText.label: 'Exchange Rate'
      Exchange_Rate,
      @EndUserText.label: 'Paid Amount(INR)'
      Paid_Amount_INR,
      @EndUserText.label: 'Balance Amount(INR)'
      Balance_Amount_INR,
      @EndUserText.label: 'Paid Amount(FC)'
      Paid_Amount_FC,
      @EndUserText.label: 'Balance Amount(FC)'
      Balance_Amount_FC,
      @EndUserText.label: 'Due Date'
      Due_Date,
      @EndUserText.label: 'Oversue Days'
      Oversue_Days,
      @EndUserText.label: 'Inward Value Recd(FC)'
      Inward_Value_Recd_FC,
      @EndUserText.label: 'Inward Recd. Dt'
      Inward_Recd_Dt

}
