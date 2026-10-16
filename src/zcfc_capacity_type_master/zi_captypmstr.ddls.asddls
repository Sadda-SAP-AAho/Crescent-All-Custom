@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Capacity Type Master'
@ObjectModel.representativeKey: 'capcode'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_CAPTYPMSTR
  as select from zdt_captypmstr_n
{
  key Id,
  key capcode as capcode,
  key capname as capname,
      capperday,
      noofline,
      noofbox,
      noofpatt,
      capcatg,
      ratefc2
}
