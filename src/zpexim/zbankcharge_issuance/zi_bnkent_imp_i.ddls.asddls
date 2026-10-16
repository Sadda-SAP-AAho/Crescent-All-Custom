@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for bank entry import'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_BNKENT_IMP_I
  as select from zdt_bnk_en_imp_i
  association to parent ZI_BNKENT_HDR as _head on $projection.Id = _head.Id
{
  key zdt_bnk_en_imp_i.id         as Id,
  key zdt_bnk_en_imp_i.item       as Item,
      zdt_bnk_en_imp_i.chargehed2 as Chargehed2,
      zdt_bnk_en_imp_i.waers      as Waers,
      @Semantics.amount.currencyCode: 'waers'
      zdt_bnk_en_imp_i.amt2       as Amt2,
      zdt_bnk_en_imp_i.glaccount2 as Glaccount2,
      zdt_bnk_en_imp_i.taxc2      as Taxc2,
      zdt_bnk_en_imp_i.status2    as Status2,
      zdt_bnk_en_imp_i.costcenter2 as Costcenter2,
      _head
}
