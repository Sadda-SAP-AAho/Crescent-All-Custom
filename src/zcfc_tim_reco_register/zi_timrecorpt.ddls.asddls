@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'TIM Reco-Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_TIMRECORPT
  as select distinct from ZI_TIMRECOREGHD    as a
    inner join            ZI_TIMRECOREGIT    as b on a.Id = b.Id
    left outer join       ZI_FI_DEBTOR_RPT_1 as c on b.Gstinvno = c.taxinvref
{

  key a.Id,
  key b.Item,
      a.Docnum     as DocumentNo,
      a.Remadvno   as RANo,
      a.Entrydate,
      a.Remarks    as HeadReamarks,
      ( case when b.Amount > 0 then 'GST Invoice'
             when b.Amount < 0 then 'Debit Note'
             end ) as Type,
      b.Suppref,
      b.Invno,
      b.Invdate,
      b.Currency,
      b.Amount,
      b.Remarks    as LineReamarks,
      b.Paycurr,
      b.Payamount,
      b.Refdrnoteno,
      b.Gstinvno,
      c.arinv      as CommInvNo
}
