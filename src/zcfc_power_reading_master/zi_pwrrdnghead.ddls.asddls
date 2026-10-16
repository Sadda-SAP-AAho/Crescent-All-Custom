@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Power Reading Header'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_PWRRDNGHEAD
  as select from zdt_pwrrdnghead
  composition [0..*] of ZI_PWRRDNGITEM as _Item
{
  key id        as Id,
      fisyear   as Fisyear,
      docnum    as Docnum,
      keyid     as Keyid,
      creon     as Creon,
      creby     as Creby,
      readdate  as Readdate,
      readloccd as Readloccd,
      readlocnm as Readlocnm,
      readdept  as Readdept,
      unitrate  as UnitRate,
      _Item
}
