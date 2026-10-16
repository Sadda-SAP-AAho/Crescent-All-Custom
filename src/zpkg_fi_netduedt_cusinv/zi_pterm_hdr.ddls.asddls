@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.representativeKey: 'id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@EndUserText.label: 'Interface View for Payment Term'
define root view entity ZI_PTERM_HDR
  as select from zdt_pterm
  association to ZI_BASIS_F4 as _basis on $projection.Basis = _basis.value_low
{
  key id              as Id,
      zterm           as Zterm,
      pdesc           as Pdesc,
      basis           as Basis,
      noofday         as Noofday,
      credt           as Credt,
      lastchngdt      as Lastchngdt,
      _basis.basistxt as Basistxt,
      
      _basis
}
