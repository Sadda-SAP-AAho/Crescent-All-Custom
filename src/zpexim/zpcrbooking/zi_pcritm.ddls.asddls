@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For PCR adjustment details'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define view entity ZI_PCRITM
  as select from zdt_pcr_adjitm
  association to parent ZI_PCRHDR as _head on $projection.Id = _head.Id
{
  key zdt_pcr_adjitm.id            as Id,
  key zdt_pcr_adjitm.item          as Item,
      zdt_pcr_adjitm.waers         as Waers,
      zdt_pcr_adjitm.adjustdoctype as Adjustdoctype,
      zdt_pcr_adjitm.invno         as Invno,
      zdt_pcr_adjitm.invdt         as Invdt,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_pcr_adjitm.invopenamt    as Invopenamt,
      zdt_pcr_adjitm.remarks       as Remarks,
      zdt_pcr_adjitm.othercurr     as Othercurr,
      zdt_pcr_adjitm.instructdt    as Instructdt,
      @Semantics.amount.currencyCode: 'Waers'
      zdt_pcr_adjitm.adjamt        as Adjamt,
      zdt_pcr_adjitm.lcnumber      as Lcnumber,
      zdt_pcr_adjitm.lcdate        as Lcdate,
//      zdt_pcr_adjitm.fiscalyear    as Fiscalyear,
//      zdt_pcr_adjitm.cocode        as Cocode,
      zdt_pcr_adjitm.lcurr         as Lcurr,
      @Semantics.amount.currencyCode: 'Lcurr'
      zdt_pcr_adjitm.lcamt         as Lcamt,
      zdt_pcr_adjitm.fiscalyear    as Fiscalyear,
      zdt_pcr_adjitm.cocode        as Cocode,
     @Semantics.amount.currencyCode:'Othercurr'
      zdt_pcr_adjitm.otheramt as Otheramt,
      zdt_pcr_adjitm.othertext as Othertext,
      _head // Make association public
}
