@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For Forward Contract'
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@Metadata.ignorePropagatedAnnotations:true
define root view entity ZI_FOREXTP
  as select from zdt_forex_hdr
  composition [0..*] of ZI_FOREXTPITM as _item
{
  key id           as Id,
      contnoext    as Contnoext,
      bankname     as Bankname,
      waers        as Waers,
      exchagecurr  as Exchagecurr,
      contractdate as Contractdate,
//      @Semantics.amount.currencyCode: 'Exchagecurr'
      exchangerate as Exchangerate,
      @Semantics.amount.currencyCode: 'Waers'
      contamt      as Contamt,
      @Semantics.amount.currencyCode: 'Waers'
      balanceval   as Balanceval,
      bookdate     as Bookdate,
      maturitydate as Maturitydate,
      opendate     as Opendate,
      allocdate    as Allocdate,
      upd          as Upd,
      _item
}
