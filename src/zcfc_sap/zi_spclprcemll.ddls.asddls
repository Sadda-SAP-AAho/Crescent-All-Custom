@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Sp. Price M/L Line'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_SPCLPRCEMLL
  as select from zdt_spclprcemll
  association to parent ZI_SPCLPRCEMLH as _Head on $projection.Id = _Head.Id
{
  key id as Id,
  key item as Item,
      fromdate as Fromdate,
      todate as Todate,
      unit as Unit,
      currency  as Currency,
      rate as Rate,
      _Head
    
}
