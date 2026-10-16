@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Labour Booking Item'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_LABBKREGITEM
  as select from zdt_labbkregitem
  association to parent ZI_LABBKREGHEAD as _Head on $projection.Id = _Head.Id
{
  key zdt_labbkregitem.id       as Id,
  key zdt_labbkregitem.item     as Item,
      zdt_labbkregitem.workcode as Workcode,
      zdt_labbkregitem.workname as Workname,
      zdt_labbkregitem.uom      as Uom,
      zdt_labbkregitem.quantity as Quantity,
      zdt_labbkregitem.rate     as Rate,
      zdt_labbkregitem.amount   as Amount,
      zdt_labbkregitem.aprvcode as Aprvcode,
      zdt_labbkregitem.aprvname as Aprvname,
      zdt_labbkregitem.remark as Remark,
      _Head
}
