@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Export LC Header'
@Metadata.allowExtensions: true

define root view entity zc_lcexphead
  provider contract transactional_query
  as projection on ZI_LCEXPHEAD
{
      @EndUserText.label: 'ID'
  key Id,
      @EndUserText.label: 'LC Ref. Number'
      Lc_Refnr,
      @EndUserText.label: 'Version'
      Version,
      @EndUserText.label: 'Status'
      Status,
      @EndUserText.label: 'Criticality'
      Criticality,
      @EndUserText.label: 'Company Code'
      Companycode,
      @EndUserText.label: 'Sales Org.'
      Ekorg,
      @EndUserText.label: 'Company Name'
      Companyname,
      @EndUserText.label: 'Sales Org Name'
      Sales_Org_Name,
      @EndUserText.label: 'Customer'
      Lifnr,
      @EndUserText.label: 'Customer Name'
      Vendor_Name,
      @EndUserText.label: 'LC Number'
      Lc_Appl,
      @EndUserText.label: 'LC From Bank'
      Lc_Number,
      @EndUserText.label: 'Sales Order No'
      So,
      @EndUserText.label: 'LC Status'
      Lc_Status,
      @EndUserText.label: 'LC Status Name'
      Lcstatus_Name,
      @EndUserText.label: 'LC Type'
      Lc_Type,
      @EndUserText.label: 'LC Type Name'
      Lctyp_Name,
      @EndUserText.label: 'LC Base'
      Lc_Base,
      @EndUserText.label: 'Division'
      Div,
      @EndUserText.label: 'Bank Reference'
      Bank_Xblnr,
      @EndUserText.label: 'Amnd. Date'
      Amend_Date,
      @EndUserText.label: 'Amnd. Text'
      Amend_Txt,
      @EndUserText.label: 'Final Assesment'
      Finala,
      @EndUserText.label: 'LC Charges'
      Charges,
      @EndUserText.label: 'Accounting Doc'
      Belnr,
      @EndUserText.label: 'Order'
      Zorder,
      @EndUserText.label: 'Porforma Invoice No.'
      Lc_Prof_Num,
      @EndUserText.label: 'LC Req Date'
      Lc_Req_Date,
      @EndUserText.label: 'Opening Date'
      Lc_Open_Dt,
      @EndUserText.label: 'LC Expiry Date'
      Lc_Exp_Date,
      @EndUserText.label: 'Customer Name'
      Lc_Appl_Name,
      @EndUserText.label: 'Company Name'
      Lc_Benf_Name,
      @EndUserText.label: 'Proforma Invoice Date'
      Lc_Prod_Date,
      @EndUserText.label: 'Purpose'
      Lc_Purpose,
      @EndUserText.label: 'Creator'
      Lc_Creator,
      @EndUserText.label: 'Serv. Contract No.'
      Lc_Serv_Cont_No,
      @EndUserText.label: 'IEC Code'
      Lc_Iec_Code,
      @EndUserText.label: 'Usance Days'
      Usance,
      @EndUserText.label: 'Payt Terms'
      Zterm,
      @EndUserText.label: 'Payt Terms Desc.'
      Payterm_Description,
      @EndUserText.label: 'RA Vendors'
      Ra_Vendor,
      @EndUserText.label: 'LC Tenture'
      Tenure,
      @EndUserText.label: 'Grace Days'
      Grace,
      @EndUserText.label: 'Exchange Rate'
      Wkurs,
      @EndUserText.label: 'Currency'
      @Consumption.valueHelpDefinition: [ {
        entity: {
          name: 'I_Currency',
          element: 'Currency'
        }
      } ]
      Waers,
      @EndUserText.label: 'INR Currency'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_Currency', element: 'Currency' } } ]
      
      Currinr,
      @EndUserText.label: 'LC Amount In FC'
      
      Lc_Tot_Amt_Fc,
      @EndUserText.label: 'LC Amount In INR'
      
      Lc_Tot_Amt_Lc,
      @EndUserText.label: 'LC Add Amount'
      
      Lc_Add,
      @EndUserText.label: 'LC Tolerance'
      
      Lc_Tolerance,
      @EndUserText.label: 'LC Tot Amount'
      
      Lc_Tol_Amt,
      @EndUserText.label: 'LC Tot Amount in FC'
      
      Lc_Tot_Amt_Fc_Tol,
      @EndUserText.label: 'LV Tot Amount in INR'
      
      Lc_Tot_Amt_Lc_Tol,
      @EndUserText.label: 'Interest'
      
      Interest,
      @EndUserText.label: 'Credit Period'
      Lc_Buyers_Credit,
      @EndUserText.label: 'Interest Value'
      Interest_Value,
      @EndUserText.label: 'Interest in LC'
      Interest_Lc,
      @EndUserText.label: 'LC Opening'
      Lc_Opening,
      @EndUserText.label: 'Swift/Postage Charge'
      Swift_Charge,
      @EndUserText.label: 'Other Charge'
      Other_Charges,
      @EndUserText.label: 'Other Banking Charges'
      Lc_Adj_Chrg,
      @EndUserText.label: 'Non Taxable Charges'
      Lc_Non_Tax_Chrg,
      @EndUserText.label: 'LC Ammendment Charges'
      Ammend_Charge,
      @EndUserText.label: 'Bank Remarks'
      Bank_Remarks,
      @EndUserText.label: 'Bank rates'
      Bank_Rate,
      @EndUserText.label: 'CGST'
      Cgst,
      @EndUserText.label: 'SGST'
      Sgst,
      @EndUserText.label: 'IGST'
      Igst,
      @EndUserText.label: 'LC Shifting Charges'
      Lc_Shift_Char,
      @EndUserText.label: 'Commitment Priority Shipment/Expiry'
      Commitment_Prio,
      @EndUserText.label: 'Bank Vendor'
      Bank_Lifnr,
      @EndUserText.label: 'Bank Vendor Name'
      Bank_Vendor_Name,
      @EndUserText.label: 'Bussiness Place'
      Bupla,
      @EndUserText.label: 'Secco'
      Secco,
      @EndUserText.label: 'Mwskz'
      Mwskz,
      @EndUserText.label: 'LC Ammendment Charges'
      Lc_Amend_Charge,
      @EndUserText.label: 'LC Ammendment Date'
      Lc_Amend_Date,
      @EndUserText.label: 'LC Ammendment Reason'
      Lc_Amend_Reason,
      @EndUserText.label: 'Partial Shipment Indicator'
      Partial_Shipment,
      @EndUserText.label: 'Port Of Loading'
      Prt_Ld_Cod,
      @EndUserText.label: 'Port Of Discharge'
      Prt_Ds_Cod,
      @EndUserText.label: 'Latest Date of Shipment'
      Latest_Ship_Date,
      @EndUserText.label: 'Item Details'
      Item_Detail,
      @EndUserText.label: 'Country Of Origin'
      Cntry_Org,
      @EndUserText.label: 'Country Name'
      Country_Name,
      @EndUserText.label: 'Incoterm'
      Inco1,
      @EndUserText.label: 'Incoterms Desc'
      Inco2,
      @EndUserText.label: 'Shipment Mode'
      Shipment_Mode,
      @EndUserText.label: 'Port Discharge Name'
      Port_Discharge,
      @EndUserText.label: 'Loading Port Name'
      Port_Load,
      @EndUserText.label: 'Trans Shipment'
      Transship,
      @EndUserText.label: 'Insurance Number'
      Insurance_Number,
      @EndUserText.label: 'Insurance Start Date'
      Ins_Start_Date,
      @EndUserText.label: 'Insurance Expiry Date'
      Ins_Expiry_Date,
      @EndUserText.label: 'Risk Cover Type'
      Risk_Cover_Type,
      @EndUserText.label: 'Insurance Agent'
      Insurace_Agent,
      @EndUserText.label: 'Insurance Agent Name'
      Agent_Name,
      @EndUserText.label: 'Net LC Rem. Amount'
      Net_Lc_Amt,
      @EndUserText.label: 'Net LC Paid Amount'
      Net_Lc_Paid_Amt,
      @EndUserText.label: 'LC Clean Limit'
      Lc_Clean_Limit,
      @EndUserText.label: 'BG Clean Limit'
      Bg_Clean_Limit,
      @EndUserText.label: 'FD Customer Amount'
      Fd_Customer,
      @EndUserText.label: 'LC Clean Assigned'
      Lc_Clean_Assign,
      @EndUserText.label: 'BG Clean Assigned'
      Bg_Clean_Assign,
      @EndUserText.label: 'FD Customer Amount'
      Fd_Cust_Amt,
      @EndUserText.label: 'Limit Interchangeability'
      Bg_Lc_Intchng,
      @EndUserText.label: 'Make Payment'
      Pay,
      @EndUserText.label: 'Create Open LC'
      Create_Openlc,
      @EndUserText.label: 'Change LC'
      Change_Lc,
      @EndUserText.label: 'Create '
      Create_Acamnd,
      @EndUserText.label: 'Display'
      Display_Lc,
      @EndUserText.label: 'Release'
      Release_Lc,
      @EndUserText.label: 'Reverse'
      Release_Revsl,
      @EndUserText.label: 'Close'
      Close_Lc,
      @EndUserText.label: 'LUT No'
      Lc_Ut_Rpt,
      Locallastchangedat,
      @EndUserText.label:  'Amendment'
      Amendment,
      @EndUserText.label:  'Setout'
      Setout,
      @EndUserText.label: 'Remaining LC Amount'
      Avail_Amount,
      @EndUserText.label: 'fc currency'
      Currfc,
      
      
      /* Associations */
      _item1 : redirected to composition child zc_lcbnk_dlts,
      _item2 : redirected to composition child zc_lcexpitm
}
