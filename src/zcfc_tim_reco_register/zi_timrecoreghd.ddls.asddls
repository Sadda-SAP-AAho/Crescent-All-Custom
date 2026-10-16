@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'TIM Reco Register-Header'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_TIMRECOREGHD
  as select from zdt_timrecoreghd
  composition [0..*] of ZI_TIMRECOREGIT as _Item
{
  key id        as Id,
      fisyear   as Fisyear,
      docnum    as Docnum,
      keyid     as Keyid,
      creon     as Creon,
      creby     as Creby,
      remadvno  as Remadvno,
      entrydate as Entrydate,
      remarks   as Remarks,
      _Item
}
