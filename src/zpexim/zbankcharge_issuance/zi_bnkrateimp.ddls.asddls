@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For Bank Rate Import'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_BNKRATEIMP
  as select from zdt_bnkimp_itm
  association to parent ZI_BNKRATE_HDR as _head on $projection.Id = _head.Id
{
  key zdt_bnkimp_itm.id          as Id,
  key zdt_bnkimp_itm.item        as Item,
      zdt_bnkimp_itm.chargehead1 as Chargehead1,
      zdt_bnkimp_itm.waers       as Waers,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_bnkimp_itm.rate1       as Rate1,
      _head // Make association public
}
