@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Master New Consumption View'
define root view entity ZC_EXIM_BANK_MASTN
  provider contract transactional_query
  as projection on ZI_EXIM_BANK_MASTN
{

      @EndUserText.label: 'Company Code'
  key Bukrs,
      @EndUserText.label: 'Country'
  key Zland1,
      @EndUserText.label: 'HouseBank'
  key hbkid,
      @EndUserText.label: 'BankInternalID'
  key bankl,  
      @EndUserText.label: 'IFSC Code'
  key ZifscCode,
      @EndUserText.label: 'Swift Code'
      Zswift,
      @EndUserText.label: 'House Bank GL'
      zbankgl,
      @EndUserText.label: 'Incoming GL'
      zincgl,
      @EndUserText.label: 'Outgoing GL'
      zoutgl,
      @EndUserText.label: 'Bank Vendor Code'
      zvendor,
      @EndUserText.label: 'Bank Code'
      Zbank,
      @EndUserText.label: 'Account No'
      ZaccNo,
      @EndUserText.label: 'Branch'
      Zbranch,
      @EndUserText.label: 'Address'
      Zaddress,
      @EndUserText.label: 'Address1'
      Zaddress1,
      @EndUserText.label: 'Address2'
      Zaddress2,
      @EndUserText.label: 'Address3'
      Zaddress3,
      @EndUserText.label: 'Code'
      ZadCode,
      @EndUserText.label: 'State Code'
      Zstate,
      locallastchangedat
}
