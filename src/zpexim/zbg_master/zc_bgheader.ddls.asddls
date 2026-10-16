@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
@EndUserText.label: 'Consumption View of BG Header'
define root view entity ZC_BGHEADER
  provider contract transactional_query
  as projection on ZI_BGHEADER
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      @EndUserText.label: 'ID'
  key Id,
   @EndUserText.label: 'BG Reference Number'
      Zeximbgrefno,
      @EndUserText.label: 'Version'
      Version,
      @EndUserText.label: 'Company Code'
      Bukrs,
      @EndUserText.label: 'BG Applicant Name'
      Butxt,
      @EndUserText.label: 'Street'
      Street,
      @EndUserText.label: 'City'
      City,
      @EndUserText.label: 'State'
      State,
      @EndUserText.label: 'Postal Code'
      Postcode,
      @EndUserText.label: 'Country'
      Country,
      @EndUserText.label: 'BG Status'
      Bgstat,
      @EndUserText.label: 'BG Charecter'
      Bgcharacter,
      @EndUserText.label: 'House Bank'
      Hbkid,
      @EndUserText.label: 'Account ID'
      Hktid,
      @EndUserText.label: 'Bank Key'
      Bankl,
      @EndUserText.label: 'BG Banenficairy Name'
      Bgbenfname,
      @EndUserText.label: 'Bank Address'
      Bankaddr,
      @EndUserText.label: 'Bank Branch'
      Brnch,
      @EndUserText.label: 'State'
      Bezei,
      @EndUserText.label: 'Country'
      Land1,
      @EndUserText.label: 'Postal Code'
      Lbankpostcode,
      @EndUserText.label: 'Swift/BIC'
      Swift,
      @EndUserText.label:  'Bank Vendor Code'
      Vendor,
       @EndUserText.label:  'Bank Vendor Name'
      Vendorname,
      @EndUserText.label:  'Bank Vendor Name2'
      Vendorname2,
      @EndUserText.label:  'BG Request Date'
      Bgreqdt,
      @EndUserText.label:  'BG Effective Date'
      Bgeffdt,
      @EndUserText.label:  'BG Expiry Date'
      Bgexpdt,
      @EndUserText.label:  'BG Claim Exp Date'
      Bgclaimexpdt,
      @EndUserText.label:  'BG Type'
      Bgtype,
      @EndUserText.label:  'BG Category'
      Bgcatag,
      @EndUserText.label:  'BG Amount'
      Bgamt,
      @EndUserText.label:  'BG Tenure'
      Bgtenure,
      @EndUserText.label:  'BG Tenure Unit'
      Bgtenureunit,
      @EndUserText.label:  'BG Beneficiary Code'
      Bgbenefcode,
      @EndUserText.label:  'BG Beneficairy Name'
      Bgbenefname,
      @EndUserText.label:  'Address1'
      Bgaddress1,
      @EndUserText.label:  'Address2'
      Bgaddress2,
      @EndUserText.label:  'Country'
      Bgcountry,
      @EndUserText.label:  'State'
      Bgstate,
      @EndUserText.label:  'City'
      Bgcity,
      @EndUserText.label:  'Postal Code'
      Bgpostalcode,
      @EndUserText.label:  'Purpose'
      Bgpurpose,
      @EndUserText.label:  'Exchange Rate'
      Bgexchangerate,
      @EndUserText.label:  'BG Amount'
      Bgamount,
      @EndUserText.label:  'Creator'
      Bgcreator,
      @EndUserText.label:  'BG Credit Days'
      Bgcreditdays,
      @EndUserText.label:  'Charges Rate'
      Chargesrate,
      @EndUserText.label:  'Currency'
      Waers,
      @EndUserText.label:  'BG Opening Charges'
      Bcopenchrgs,
      @EndUserText.label:  'Bank BG Opening Charges'
      Bankbcopenchrgs,
      @EndUserText.label:  'Min. BG Charges'
      Bankminchrgs,
      @EndUserText.label:  'Non-Taxable Amount'
      Nontaxamt,
      @EndUserText.label:  'Stamp/Swift Charges'
      Stampcharges,
      @EndUserText.label:  'P&T Charges'
      Pntcharges,
      @EndUserText.label:  'Tax Code'
      Taxcode,
      @EndUserText.label:  'CGST'
      Cgst,
      @EndUserText.label:  'SGST'
      Sgst,
      @EndUserText.label:  'IGST'
      Igst,
      @EndUserText.label:  'Total Charges'
      Totalchrgs,
      @EndUserText.label:  'Bank Remarks'
      Bankremarks,
      @EndUserText.label:  'Business Place'
      Busplc,
      @EndUserText.label:  'Section Code'
      Seccode,
      @EndUserText.label:  'BG Ammendment Charges'
      Bgammendcharges,
      @EndUserText.label:  'BG Tenure Date'
      Bgtendate,
      @EndUserText.label:  'Shift Charges'
      Shiftcharges,
      @EndUserText.label:  'Shift Date'
      Shiftdate,
      @EndUserText.label:  'Net BG Amount'
      Netbgamount,
      @EndUserText.label:  'BG Clean Amount'
      Bgcleanamount,
      @EndUserText.label:  'FD Amount Assigned'
      Fdamountassigned,
      @EndUserText.label:  'BG Clean Assigned'
      Bgcleanassigned,
      @EndUserText.label:  'Status'
      Status,
      @UI.hidden: true
      @EndUserText.label:  'Criticality'           
      Criticality , 
      @EndUserText.label:  'Amendment'     
      Amendment,
        @UI.hidden: true
      @EndUserText.label:  'Locallastchangedate' 
      Locallastchangedat,
      @EndUserText.label:  'Setout'
      Setout,
      /* Associations */
      _bgattachpo : redirected to composition child ZC_ATTACHPO,
      _bgfdassign : redirected to composition child ZC_FDASSIGN
}
