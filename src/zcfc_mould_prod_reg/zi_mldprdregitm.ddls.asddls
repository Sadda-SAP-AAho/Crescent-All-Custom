@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View of Mould Prod Reg Item'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L

define view entity ZI_MLDPRDREGITM
  as select from zdt_mldprdregitm
  association to parent ZI_MLDPRDREGHED as _Head on $projection.Id = _Head.ID
{
  key zdt_mldprdregitm.id      as Id,
  key zdt_mldprdregitm.item    as Item,
      zdt_mldprdregitm.typeofmould,
      zdt_mldprdregitm.qty     as Qty,
      zdt_mldprdregitm.remarks as Remarks,
      zdt_mldprdregitm.extra1  as Extra1,
      zdt_mldprdregitm.extra2  as Extra2,
      _Head
}
