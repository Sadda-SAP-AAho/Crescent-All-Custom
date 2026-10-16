@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Master Consumtion View'
@Metadata.allowExtensions: true
define root view entity ZC_EXIM_BANK_MAST
  provider contract transactional_query
  as projection on ZI_EXIM_BANK_MAST
{
              @EndUserText.label: 'ID'
              @UI.hidden: true
  key         Internaid,
              @EndUserText.label: 'Company Code'
  key         Bukrs,
              @EndUserText.label: 'Bank Type'
  key         banktype,
              @EndUserText.label: 'Country'
              Zland1,
              @EndUserText.label: 'HouseBank'
              hbkid,
              @EndUserText.label: 'HouseBankAccount'
              hktid,
              @EndUserText.label: 'BankInternalID'
              bankl,
              @EndUserText.label: 'IFSC Code'
              Zifsccode,
              @EndUserText.label: 'Account No'
              Zaccno,
              @EndUserText.label: 'Bank Name'
              Zbank,
              @EndUserText.label: 'Address'
              Zaddress,
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

              @EndUserText.label: 'Branch'
              Zbranch,

              @EndUserText.label: 'Address1'
              Zaddress1,
              @EndUserText.label: 'Address2'
              Zaddress2,
              @EndUserText.label: 'Address3'
              Zaddress3,
              @EndUserText.label: 'Code'
              Zadcode,
              @EndUserText.label: 'State Code'
              Zstate,
              Locallastchangedat
}
