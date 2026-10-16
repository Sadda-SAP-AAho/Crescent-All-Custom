@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FD Head'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_FDHEAD

  provider contract transactional_query

  as projection on ZR_FDHEAD
{
      @EndUserText.label: 'ID'
  key id,
      @EndUserText.label: 'Status Code'
      statuscode,
      @EndUserText.label: 'Status'
      statusdesc,
      @EndUserText.label: 'FD Certificate No.'
      fdcertificateno,
      @EndUserText.label: 'Document Date'
      documentdate,
      @EndUserText.label: 'Posting Date'
      postingdate,
      @EndUserText.label: 'Bank Key'
      bankkey,
      @EndUserText.label: 'Bank Name'
      bankname,
      @EndUserText.label: 'FD Start Date'
      fdstartdate,
      @EndUserText.label: 'FD Maturity Date'
      fdmaturedate,
      @EndUserText.label: 'Revised FD Maturity Date'
      revfdmaturedate,
      @EndUserText.label: 'Exchange Rate'
      exchangerate,
      @Semantics.amount.currencyCode: 'currency'
      @EndUserText.label: 'Amount'
      amount,
      @EndUserText.label: 'Rate of Interest'
      rateofinterest,
      @EndUserText.label: 'Revised Rate of Interest'
      revrateofinterest,
      @EndUserText.label: 'Currency'
      currency,
      @EndUserText.label: 'FD GL'
      fdgl,
      @EndUserText.label: 'Profit Center'
      profitcenter,
      @EndUserText.label: 'FD Accounting Number'
      transactionno,
      @EndUserText.label: 'FD Accounting Date'
      transactiondate,
      @EndUserText.label: 'FD Close Accounting Number'
      fdclosetrxnno,
      @EndUserText.label: 'FD Close Accounting Date'
      fdclosetrxndate,
      @EndUserText.label: 'FD Closed?'
      postclose,
      @EndUserText.label: 'FD Creation Posted?'
      postfd,
      @EndUserText.label: 'FD Interest Posted?'
      postfdint,
      @EndUserText.label: 'Confirmed?'
      tconfirm,
      @EndUserText.label: 'Opening Remarks'
      remarkopen,
      @EndUserText.label: 'Closing Remarks'
      remarkclose,
      @EndUserText.label: 'Interest Accrued'
      interestcum,
      @EndUserText.label: 'Renewal Remarks'
      renewal,
      @EndUserText.label: 'BG'
      bg,
      @EndUserText.label: 'Closing Document Date'
      closedocumentdate,
      @EndUserText.label: 'Closing Posting Date'
      closepostingdate,
      local_created_by,
      local_created_at,
      local_last_changed_by,
      local_last_changed_at,
      last_changed_at,
      /* Associations */
      _outgl    : redirected to composition child ZC_FDOUTGL,
      _incgl    : redirected to composition child ZC_FDINCGL,
      _interest : redirected to composition child ZC_FDINTEREST

}
