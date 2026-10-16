@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for bank entry export'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_BNKENT_EXP_I
  as select from zdt_bnk_en_exp_i
  association to parent ZI_BNKENT_HDR as _head on $projection.Id = _head.Id
{
  key zdt_bnk_en_exp_i.id         as Id,
  key zdt_bnk_en_exp_i.item       as Item,
      zdt_bnk_en_exp_i.chargehed1 as Chargehed1,
      zdt_bnk_en_exp_i.waers      as Waers,
      @Semantics.amount.currencyCode: 'waers' 
      zdt_bnk_en_exp_i.amt1       as Amt1,
      zdt_bnk_en_exp_i.glaccount1 as Glaccount1,
      zdt_bnk_en_exp_i.taxc1      as Taxc1,
      zdt_bnk_en_exp_i.status1    as Status1,
      zdt_bnk_en_exp_i.costcenter1 as Costcenter1,
      _head
}
