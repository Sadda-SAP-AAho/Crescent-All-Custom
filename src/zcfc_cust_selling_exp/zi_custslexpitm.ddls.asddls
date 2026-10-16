@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface view for Cust Sell Exp-Item'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_CUSTSLEXPITM
  as select from zdt_custslexpitm
 association to parent ZI_CUSTSLEXPHDR as _Head on $projection.Id = _Head.Id
{
  key zdt_custslexpitm.id       as Id,
  key zdt_custslexpitm.item     as Item,
      zdt_custslexpitm.datefrom as Datefrom,
      zdt_custslexpitm.dateto   as Dateto,
      zdt_custslexpitm.currency as Currency,
      zdt_custslexpitm.rate     as Rate,
      _Head
}
