@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface view for Cust Sell Exp-Header'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_CUSTSLEXPHDR
  as select from zdt_custslexphdr
  composition [0..*] of ZI_CUSTSLEXPITM as _Item
{
  key zdt_custslexphdr.id       as Id,
      zdt_custslexphdr.custcode as Custcode,
      zdt_custslexphdr.custname as Custname,
      zdt_custslexphdr.expcode  as Expcode,
      zdt_custslexphdr.expname  as Expname,
      _Item
}
