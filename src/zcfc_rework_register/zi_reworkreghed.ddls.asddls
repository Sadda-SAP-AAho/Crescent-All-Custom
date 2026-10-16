@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View of Rework Register- Head'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L

define root view entity ZI_REWORKREGHED
  as select from ZDT_REWORKREGHED
  composition [0..*] of ZI_REWORKREGITM as _Item
{
  key ZDT_REWORKREGHED.id,
      ZDT_REWORKREGHED.plntcd,
      ZDT_REWORKREGHED.plntnm,
      ZDT_REWORKREGHED.oprcode,
      ZDT_REWORKREGHED.oprname,
      ZDT_REWORKREGHED.reportyear,
      ZDT_REWORKREGHED.reportmonth,
      _Item
}
