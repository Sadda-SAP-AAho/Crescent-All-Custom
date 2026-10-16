@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Interface View Spl Rate Master LM - Head'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_SPLRTMSTHED
  as select from ZDT_SPLRTMSTHED
  composition [0..*] of ZI_SPLRTMSTITM as _Item
{
    key id as Id,
    plntcd as Plntcd,
    plntnm as Plntnm,
    lmcd as Lmcd,
    lmnm as Lmnm,
    _Item
}

