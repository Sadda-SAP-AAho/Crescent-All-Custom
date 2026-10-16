@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FD Interest'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_FDINTEREST

  as projection on ZR_FDINTEREST
{

  key id,
  key item,
      @EndUserText.label: 'Reference No.'
      referenceno,
      @EndUserText.label: 'Start Date'
      startdate,
      @EndUserText.label: 'End Date'
      enddate,
      @EndUserText.label: 'Document Date'
      documentdate,
      @EndUserText.label: 'Posting Date'
      postingdate,
      @EndUserText.label: 'Remarks'
      text,
      @EndUserText.label: 'Acc. Interest/Income Credit GL'
      interestgl,
      @EndUserText.label: 'Bank/FD Account Debit GL'
      bankgl,
      @EndUserText.label: 'House Bank ID'
      housebankid,
      @EndUserText.label: 'Account ID'
      accountid,
      @EndUserText.label: 'Amount'
      amount,
      @EndUserText.label: 'Accounting Doc No. - Interest'
      transactionno,
      @EndUserText.label: 'Accounting Doc Date - Interest'
      transactiondate,
      @EndUserText.label: 'TDS Rec. GL'
      tdsgl,
      @EndUserText.label: 'TDS Amount'
      tdsamount,
      /* Associations */
      _head : redirected to parent ZC_FDHEAD
}
