@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Labour Attendance Reg-Header'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_LABATTNHEAD
  as select from zdt_labattnhead
  composition [0..*] of ZI_LABATTNITEM as _Item
{
  key id         as Id,
      fisyear    as Fisyear,
      docnum     as Docnum,
      keyid      as Keyid,
      creon      as Creon,
      creby      as Creby,
      reportdate as Reportdate,
      plantcode  as Plantcode,
      plantname  as Plantname,
      _Item
}
