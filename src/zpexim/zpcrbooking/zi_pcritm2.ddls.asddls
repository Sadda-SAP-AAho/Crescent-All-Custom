@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For Sales Order Details'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_PCRITM2
  as select from zdt_pcr_sorditm
  association to parent ZI_PCRHDR as _head on $projection.Id = _head.Id

{
  key zdt_pcr_sorditm.id            as Id,
  key zdt_pcr_sorditm.item          as Item,
      zdt_pcr_sorditm.waers         as Waers,
      zdt_pcr_sorditm.sodocentry    as Sodocentry,
      zdt_pcr_sorditm.sordno        as Sordno,
      zdt_pcr_sorditm.sorddt        as Sorddt,
      zdt_pcr_sorditm.cuscode       as Cuscode,
      zdt_pcr_sorditm.payterm       as Payterm,
      zdt_pcr_sorditm.bank          as Bank,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_pcr_sorditm.basicamt      as Basicamt,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_pcr_sorditm.applicableamt as Applicableamt,

      _head // Make association public
}
