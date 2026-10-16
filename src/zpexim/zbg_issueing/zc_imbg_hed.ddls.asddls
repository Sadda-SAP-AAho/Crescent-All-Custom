@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Issuing BG'
@Metadata.allowExtensions: true
define root view entity ZC_IMBG_HED
  provider contract transactional_query
  as projection on ZI_IMBG_HED

{
      @EndUserText.label:'ID'
  key Id,
      @EndUserText.label:'Company Code'
      Companycode,
      @EndUserText.label:'BG Reference No'
      Imbgrefno,
      @EndUserText.label:'Version'
      Version,
      @EndUserText.label:'BG Applicant Name'
      Bgappnam,
      @EndUserText.label:'BG Status'
      Bgstat,
      @EndUserText.label:'City'
      City,
      @EndUserText.label:'Country'
      Country,
      @EndUserText.label:'BG Character'
      Bgcharacter,
      @EndUserText.label:'House Bank'
      Hbkid,
      @EndUserText.label:'HouseBankAccount'
      Hktid,
      @EndUserText.label:'BankInternalID'
      Bankl,
      @EndUserText.label:'Bank name'
      Banknam,
      //      @EndUserText.label:''
      //      Bgbenfname,
      @EndUserText.label:'Bnak Address'
      Bankaddr,
      @EndUserText.label:'Bank Branch'
      Bankbrnch,
      @EndUserText.label:'IFSC Code'
      Zifsccode,
      @EndUserText.label:'Swift Code'
      Swift,
      @EndUserText.label:'Bank Vendor Code'
      Bankvendor,
      @EndUserText.label:'Bank Vendor Name'
      Bankvendorname,
      @EndUserText.label:'BG Request Date'
      Bgreqdt,
      @EndUserText.label:'BG Effective Date'
      Bgeffdt,
      @EndUserText.label:'BG Expiry Date'
      Bgexpdt,
      @EndUserText.label:'BG Claim Expiry Date'
      Bgclaimexpdt,
      @EndUserText.label:'BG Tenure'
      Bgtenure,
      @EndUserText.label:'BG Type '
      Bgtype,
      @EndUserText.label:'Exchange Rate'
      Bgexchangerate,
      @EndUserText.label:'BG Category '
      Bgcatag,
      @EndUserText.label:'BG Currency'
      Bgcurrency,
      @EndUserText.label:'BG Currency(FC)'
      Bgcurrencyfc,
      @EndUserText.label:'BG Amount(FC)'
      @Semantics.amount.currencyCode: 'Bgcurrencyfc'
      Bgamt,
      @EndUserText.label:'BG Amount(LC)'
      @Semantics.amount.currencyCode: 'Bgcurrency'
      Bglcamt,
      @EndUserText.label:'BG Opening Charges'
      @Semantics.amount.currencyCode: 'Bgcurrency'
      Bcopenchrgs,
      @EndUserText.label:'BG Beneficiary Code'
      Bgbenefcode,
      @EndUserText.label:'BG Beneficiary Name '
      Bgbenefname,
      @EndUserText.label:'Address'
      Bgaddress,
      @EndUserText.label:'Country'
      Bgcountry,
      @EndUserText.label:''
      Bgcity,
      @EndUserText.label:''
      Bgstate,
      @EndUserText.label:''
      Bgpostalcode,
      @EndUserText.label:'Purpose'
      Bgpurpose,
      @EndUserText.label:'Bank Limit'
      @Semantics.amount.currencyCode: 'Bgcurrency'
      Banklimit,
      @EndUserText.label:'Net BG Amount'
      @Semantics.amount.currencyCode: 'Bgcurrency'
      Netbglimit,
      @EndUserText.label:'BG Clean Limit'
      @Semantics.amount.currencyCode: 'Bgcurrency'
      Bgcleanlimit,
      @EndUserText.label:'BG Clean Assign'
      //      @Semantics.amount.currencyCode: 'Bgcurrency'
      Bgcleanassign,
      @EndUserText.label:'Bank FD Assignment'
      Bgbankfd,
      @EndUserText.label:'FD Tagging Provision'
      Bgfdtagprovision,
      @EndUserText.label:'Account DocNo'
      Accdocno,
      @EndUserText.label:'Acc Doc Year'
      Accdocyr,
      @EndUserText.label:'Acc Post'
      Accpost,
      @EndUserText.label:'Amendment'
      Amendment,
      @EndUserText.label:'Setout'
      Setout
}
