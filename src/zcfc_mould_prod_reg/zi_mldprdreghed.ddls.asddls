@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View of Mould Prod Reg Head'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L

define root view entity ZI_MLDPRDREGHED
  as select from zdt_mldprdreghed
  composition [0..*] of ZI_MLDPRDREGITM as _Item
{
  key zdt_mldprdreghed.id as ID,
      zdt_mldprdreghed.prddate,
      zdt_mldprdreghed.plntcd,
      zdt_mldprdreghed.plntnm,
      zdt_mldprdreghed.cstcntr,
      zdt_mldprdreghed.cstcntrnm,
      zdt_mldprdreghed.prftcntr,
      zdt_mldprdreghed.prftcntrnm,
      _Item
}
