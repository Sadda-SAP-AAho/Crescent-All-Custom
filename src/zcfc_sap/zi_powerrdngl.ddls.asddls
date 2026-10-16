@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'INTERFACE VIEW FOR POWER READING LINE'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_POWERRDNGL
  as select from zdt_powerrdngl
  association to parent ZI_POWERRDNGH as _Head on $projection.Id = _Head.Id
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
