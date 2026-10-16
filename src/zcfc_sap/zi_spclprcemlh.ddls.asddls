@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View for Sp. Price M/L Header'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_SPCLPRCEMLH 
  as select from zdt_spclprcemlh
  composition [0..*] of ZI_SPCLPRCEMLL  as _Item 
{
  key id as Id,
      loctncd as Loctncd,
      loctnnm as Loctnnm,
      costcd as Costcd,
      costnm as Costnm,
      _Item
   
}
