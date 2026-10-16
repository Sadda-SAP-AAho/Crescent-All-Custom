@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Spl Price for Misc Work Item'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_SPPRMSWRKITM
  as select from zdt_spprmswrkitm
  association to parent ZI_SPPRMSWRKHDR as _Head on $projection.Id = _Head.Id
{
  key zdt_spprmswrkitm.id       as Id,
  key zdt_spprmswrkitm.item     as Item,
      zdt_spprmswrkitm.datefrom as Datefrom,
      zdt_spprmswrkitm.dateto   as Dateto,
      zdt_spprmswrkitm.uom      as Uom,
      zdt_spprmswrkitm.currency as Currency,
      zdt_spprmswrkitm.rate     as Rate,
      _Head
}
