@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For SOFR Interest Rate'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_PCRITM1
  as select from zdt_pcr_sofritm
  association to parent ZI_PCRHDR as _head on  $projection.Id   = _head.Id
                                          
{
  key zdt_pcr_sofritm.id as Id,
  key zdt_pcr_sofritm.item as Item,
  zdt_pcr_sofritm.waers as Waers,
  @Semantics.amount.currencyCode: 'Waers'
  zdt_pcr_sofritm.sofr as Sofr,
  zdt_pcr_sofritm.validfromdt as Validfromdt,
  zdt_pcr_sofritm.validtodt as Validtodt,
  _head
}
