@EndUserText.label: 'Consumption View of Bank Rate Maintenance App'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity zc_bankrate
  provider contract transactional_query
  as projection on ZI_BANKRATE
{
      @EndUserText.label: 'ID'
      @UI.hidden: true
  key Internaid,
      @EndUserText.label: 'Company Code'
  key Bukrs,
      @EndUserText.label: 'Bank Key'
  key Bankl,
      @EndUserText.label: 'Export/Import'
      exp_imp_type,
      @EndUserText.label: 'Type'
      type,
      @EndUserText.label: 'LC Charges'
      lc_charges,
      @EndUserText.label: 'Interest Rate'
      interestrate,
      @EndUserText.label: 'SWIFT Charges'
      swiftcharges,
      @EndUserText.label: 'Main Charges'
      maincharges as Maincharges,
      @EndUserText.label: 'Amendment Charges'
      amendement  as Amendement,
      @EndUserText.label: 'Commisson Charges'
      commisson   as Commisson,
      @EndUserText.label: 'Rate %'
      rate        as Rate,
      @EndUserText.label: 'SFMS Charges'
      sfms        as Sfms,
      @EndUserText.label: 'Tax Code'
      taxcode,
      Locallastchangedat




}
