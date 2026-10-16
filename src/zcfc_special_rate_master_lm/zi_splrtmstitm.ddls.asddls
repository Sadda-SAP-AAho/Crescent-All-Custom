@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View Spl Rate Master LM - Item'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_SPLRTMSTITM
  as select from ZDT_SPLRTMSTITM
  association to parent ZI_SPLRTMSTHED as _Head on $projection.Id = _Head.Id
{
    key ZDT_SPLRTMSTITM.id as Id,
    key ZDT_SPLRTMSTITM.item as Item,
    ZDT_SPLRTMSTITM.datefrom as Datefrom,
    ZDT_SPLRTMSTITM.dateto as Dateto,
    ZDT_SPLRTMSTITM.currency as Currency,
    ZDT_SPLRTMSTITM.rate as Rate,
    _Head
}

 