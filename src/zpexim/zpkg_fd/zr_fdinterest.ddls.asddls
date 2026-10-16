@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FD Interest'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_FDINTEREST

  as select from zdt_fd_interest

  association to parent ZR_FDHEAD as _head on $projection.id = _head.id

{
  key id,
  key item,
      referenceno,
      startdate,
      enddate,
      documentdate,
      postingdate,
      text,
      interestgl,
      bankgl,
      housebankid,
      accountid,
      amount,
      transactionno,
      transactiondate,
      tdsgl,
      tdsamount,
      _head
}
