@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Confirmation Header'
@ObjectModel.representativeKey: 'Filename'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_ICICI_PAY
  as select from zdt_payst_icici
{
  key filename as Filename,
  key createdon as Createdon,
  key createdat as Createdat,
  filecontent  as Filecontent,
  processed as Processed
}
