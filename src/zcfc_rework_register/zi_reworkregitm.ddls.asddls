@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View of Rework Register- Item'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L

define view entity ZI_REWORKREGITM
  as select from zdt_reworkregitm
  association to parent ZI_REWORKREGHED as _Head on $projection.id = _Head.id
{
  key  zdt_reworkregitm.id,
  key  zdt_reworkregitm.item,
       zdt_reworkregitm.rptdate,
       zdt_reworkregitm.matcd,
       zdt_reworkregitm.matnm,
       zdt_reworkregitm.quantity,
       zdt_reworkregitm.resource_name,
       zdt_reworkregitm.workdetls,
       zdt_reworkregitm.workmin,
       zdt_reworkregitm.totalcost,
       _Head
}
