@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for bank entry bg'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_BNKENT_BG_I
  as select from zdt_bnk_en_bg_i
  association to parent ZI_BNKENT_HDR as _head on $projection.Id = _head.Id
{
  key zdt_bnk_en_bg_i.id         as Id,
  key zdt_bnk_en_bg_i.item       as Item,
      zdt_bnk_en_bg_i.chargehed3 as Chargehed3,
      zdt_bnk_en_bg_i.waers      as Waers,
      @Semantics.amount.currencyCode: 'waers'
      zdt_bnk_en_bg_i.amt3       as Amt3,
      zdt_bnk_en_bg_i.glaccount3 as Glaccount3,
      zdt_bnk_en_bg_i.taxc3      as Taxc3,
      zdt_bnk_en_bg_i.status3    as Status3,
      zdt_bnk_en_bg_i.costcenter3 as Costcenter3,
      _head
}
