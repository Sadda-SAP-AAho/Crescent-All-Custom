@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Monthly Budget-Header'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define root view entity ZI_MONTHBUD_HED
  as select from zdt_monthbud_hed
  composition [0..*] of ZI_MONTHBUD_ITM as _Item
{
  key zdt_monthbud_hed.id         as Id,
      zdt_monthbud_hed.keyid      as Keyid,
      zdt_monthbud_hed.creon      as Creon,
      zdt_monthbud_hed.creby      as Creby,
      zdt_monthbud_hed.budgetcode as Budgetcode,
      zdt_monthbud_hed.budgetname as Budgetname,
      zdt_monthbud_hed.fiscalyear as Fiscalyear,
      zdt_monthbud_hed.currency   as Currency,
      _Item
}
