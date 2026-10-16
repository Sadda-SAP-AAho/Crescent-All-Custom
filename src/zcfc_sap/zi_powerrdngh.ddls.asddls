@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'INTERFACE VIEW FOR POWER READING HEADER'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_POWERRDNGH
  as select from zdt_powerrdngh
  composition [0..*] of ZI_POWERRDNGL as _Item
{
  key id        as Id,
      docnum    as Docnum,
      readdate  as Readdate,
      readloccd as Readloccd,
      readlocnm as Readlocnm,
      readdept  as Readdept,
      unitrate as UnitRate,
      _Item
}
