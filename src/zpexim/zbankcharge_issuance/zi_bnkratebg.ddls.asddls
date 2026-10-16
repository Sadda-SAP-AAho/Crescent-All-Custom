@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For Bank Rate BG'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_BNKRATEBG
  as select from zdt_bnkbg_itm
  association to parent ZI_BNKRATE_HDR as _head on $projection.Id = _head.Id
{
  key zdt_bnkbg_itm.id as Id,
  key zdt_bnkbg_itm.item as Item,
  zdt_bnkbg_itm.chargehead2 as Chargehead2,
  zdt_bnkbg_itm.waers as Waers,
  @Semantics.amount.currencyCode: 'Waers'
  zdt_bnkbg_itm.rate2 as Rate2,
      _head // Make association public
}
