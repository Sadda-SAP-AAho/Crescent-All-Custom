@EndUserText.label: 'Interface View of Bank Rate Maintenance'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZI_BANKRATE
  as select from zdb_bankrate
{
  key internaid          as Internaid,
  key bukrs              as Bukrs,
  key bankl              as Bankl,
      exp_imp_type       as exp_imp_type,
      type               as Type,
      lc_charges         as lc_charges,
      interestrate       as Interestrate,
      swiftcharges       as Swiftcharges,
      maincharges        as Maincharges,
      amendement         as Amendement,
      commisson          as Commisson,
      rate               as Rate,
      sfms               as Sfms,
      taxcode            as Taxcode,
      locallastchangedat as Locallastchangedat
}
