@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For Bank Rate Export'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_BNKRATEEXP
  as select from zdt_bnkexp_itm
  association to parent ZI_BNKRATE_HDR as _head on $projection.Id = _head.Id
{
  key zdt_bnkexp_itm.id as Id,
  key zdt_bnkexp_itm.item as Item,
  zdt_bnkexp_itm.chargehead as Chargehead,
  zdt_bnkexp_itm.waers as Waers,
  @Semantics.amount.currencyCode: 'Waers'
  zdt_bnkexp_itm.rate as Rate,
      _head // Make association public
}
