@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GST New Vendor Ref Register'
@ObjectModel.representativeKey: 'id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_GSTNEWVENREF
  as select from zdt_gstnewvenref
{
  key id           as Id,
      fisyear      as Fisyear,
      jeno         as Jeno,
      jedate       as Jedate,
      supplcode    as Supplcode,
      jerefno      as Jerefno,
      newvendrefno as Newvendrefno
}
