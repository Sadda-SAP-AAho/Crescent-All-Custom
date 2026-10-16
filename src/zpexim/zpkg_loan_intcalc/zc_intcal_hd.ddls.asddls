@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interest Calc. Header'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_INTCAL_HD

  provider contract transactional_query

  as projection on ZR_INTCAL_HD

{

      @EndUserText.label: 'ID'
  key id,
      @EndUserText.label: 'Run ID'
      nameid,
      @EndUserText.label: 'Month'
      tmonth,
      @EndUserText.label: 'Year'
      tyear,
      @EndUserText.label: 'Start Date'
      startdate,
      @EndUserText.label: 'End Date'
      enddate,
      @EndUserText.label: 'Loan Type'
      loantype,
      @EndUserText.label: 'Loan Account No.'
      loanacno,
      @EndUserText.label: 'Bank Key'
      bankkey,
      @EndUserText.label: 'Bank Name'
      bankname,
      @EndUserText.label: 'Document Date'
      documentdate,
      @EndUserText.label: 'Posting Date'
      postingdate,
      @EndUserText.label: 'Header Text'
      headertext,
      @EndUserText.label: 'Currency'
      currency,
      @EndUserText.label: 'Exchange Rate'
      exchangerate,
      @EndUserText.label: 'House Bank ID'
      housebankid,
      @EndUserText.label: 'Account ID'
      accountid,
      @EndUserText.label: 'Bank GL'
      bankgl,
      @EndUserText.label: 'Interest Reference'
      ineterestref,
      @EndUserText.label: 'Acc. Doc. No.'
      accdocno,
      @EndUserText.label: 'Acc. Doc. Year'
      accdocyr,
      @EndUserText.label: 'Status'
      status,
      @EndUserText.label: 'Status Desc.'
      statusdesc,
      @EndUserText.label: 'Cost Center'
      costcenter,
      @EndUserText.label: 'Interest GL'
      interestgl,
      @EndUserText.label: 'Penalty(CC)'
      penalty,
      @EndUserText.label: 'Penalty(FC)'
      penaltyfc,
      @EndUserText.label: 'Post?'
      post,
      @EndUserText.label: 'Full Calc.'
      fullcalc,
      @EndUserText.label: 'Created By'
      local_created_by,
      @EndUserText.label: 'Created At'
      local_created_at,
      local_last_changed_by,
      local_last_changed_at,
      last_changed_at,

      /* Associations */
      _item : redirected to composition child ZC_INTCAL_IT

}
