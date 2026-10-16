@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Labour Attendance Reg-Item'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_LABATTNITEM
  as select from zdt_labattnitem
  association to parent ZI_LABATTNHEAD as _Head on $projection.Id = _Head.Id
{
  key id       as Id,
  key item     as Item,
      contcode as Contcode,
      contname as Contname,
      deptcode as Deptcode,
      deptname as Deptname,
      category as Category,
      oprcode  as Oprcode,
      oprname  as Oprname,
      noofhead as Noofhead,
      _Head
}
