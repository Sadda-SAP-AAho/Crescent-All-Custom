@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interest Calc. Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_INTCAL_HD

  as select from zdt_intcal_hd

  composition [0..*] of ZR_INTCAL_IT as _item

{
  key id,
      nameid,
      tmonth,
      tyear,
      startdate,
      enddate,
      loantype,
      loanacno,
      bankkey,
      bankname,
      documentdate,
      postingdate,
      headertext,
      currency,
      exchangerate,
      housebankid,
      accountid,
      bankgl,
      ineterestref,
      accdocno,
      accdocyr,
      status,
      statusdesc,
      costcenter,
      interestgl,
      penalty,
      penaltyfc,
      post,
      fullcalc,
      local_created_by,
      local_created_at,
      local_last_changed_by,
      local_last_changed_at,
      last_changed_at,

      _item
}
