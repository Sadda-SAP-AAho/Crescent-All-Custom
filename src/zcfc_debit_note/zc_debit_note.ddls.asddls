@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@OData.entitySet.name: 'debitSet'
define view entity ZC_DEBIT_NOTE
  as select from ZDEBIT_NOTE
{
  @UI.selectionField: [{position: 10}]
  key CompanyCode,
  @UI.selectionField: [{position: 20}]
  key FiscalYear,
  @UI.selectionField: [{position: 30}]
  key Document_No,
  key item_No,
      Document_Date,
      ref_doc,
      ref_date,
      GLAccount,
      GLAccountLongName,
      HSN,
      Material_Code,
      Material_Description,
      Unit,
      Quantity,
      UOM,
      Currency,
      Unit_Price,
      Total_Price,
      Cgst_Amt,
      Cgst_Rate,
      Sgst_Amt,
      Sgst_Rate,
      Igst_Amt,
      Igst_Rate,
      Vendor_Name,
      Vendor_Address_Line1,
      Vendor_Address_Line3,
      Vendor_Address_Line4,
      Vendor_Full_Address,
      Vendor_GST_No,
      Vendor_PAN_No,
      Place_Of_Supply_City,
      Note_In_Header,
      PAN_No,
      Plant_Address_Line1,
      Plant_Address_Line2,
      Plant,
      Plant_State_Code,
      BusinessPlace,
      GSTN_No

}
