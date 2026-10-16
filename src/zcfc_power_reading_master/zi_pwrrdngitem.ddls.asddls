@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Power Reading Item'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_PWRRDNGITEM
  as select from zdt_PWRRDNGITEM
  association to parent ZI_PWRRDNGHEAD as _Head on $projection.Id = _Head.Id
{
  key id        as Id,
  key item      as Item,
      subhdcd   as Subhdcd,
      subhdnm   as Subhdnm,
      headcd    as Headcd,
      headnm    as Headnm,
      metertyp  as Metertyp,
      meterrdng as Meterrdng,
      _Head
}
