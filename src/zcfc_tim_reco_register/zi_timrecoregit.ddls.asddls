@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'TIM Reco Register-Item'
@ObjectModel.representativeKey: 'Id'
@ObjectModel.usageType.dataClass: #TRANSACTIONAL
@ObjectModel.usageType.serviceQuality: #A
@ObjectModel.usageType.sizeCategory: #L
define view entity ZI_TIMRECOREGIT
  as select from zdt_timrecoregit
  association to parent ZI_TIMRECOREGHD as _Head on $projection.Id = _Head.Id
{
  key id                               as Id,
  key item                             as Item,
      cast( suppref as abap.char(20) ) as Suppref,
      cast( invno as abap.char(20) )   as Invno,
      invdate                          as Invdate,
      amount                           as Amount,
      currency                         as Currency,
      remarks                          as Remarks,
      tdsothr                          as Tdsothr,
      payamount                        as Payamount,
      paycurr                          as Paycurr,
      refdrnoteno                      as Refdrnoteno,
      gstinvno                         as Gstinvno,
      _Head
}
