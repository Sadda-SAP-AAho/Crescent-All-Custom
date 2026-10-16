@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Debtors Report - Insia'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_DEBTORSINSIA
  as select distinct from ZI_DEBTORSINSIA_1
{

  key CompanyCode,
  key FiscalYear,
  key Accounting_Document,
  key AccountingDocumentItem,
  key Document_Type,
  key Document_Type_Name,
  key ARInvoice_No,
      ARInvoice_Date,
      DelInvoice_No,
      DelInvoice_No_Ref,
      Create_Date,
      Update_Date,
      Document_Reference,
      Customer_Code,
      Customer_Name,
      Sales_Person,
      Currency,
      FC_Total,
      Exchange_Rate,
      Paid_Amount_INR,
      Balance_Amount_INR,
      Paid_Amount_FC,
      Balance_Amount_FC,
      Due_Date,
      cast( case when Oversue_Days > 0 then 'Future Remit'
                 else cast( Oversue_Days as abap.char(12) ) end as abap.char(12) ) as Oversue_Days,
      Inward_Value_Recd_FC,
      Inward_Recd_Dt

}

where
  Balance_Amount_FC > 0
