@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FD Head'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_FDHEAD

  as select from zdt_fd_head as a

  composition [0..*] of ZR_FDOUTGL    as _outgl

  composition [0..*] of ZR_FDINCGL    as _incgl

  composition [0..*] of ZR_FDINTEREST as _interest

{
  key a.id,
      a.statuscode,
      a.statusdesc,
      a.fdcertificateno,
      a.documentdate,
      a.postingdate,
      a.bankkey,
      a.bankname,
      a.fdstartdate,
      a.fdmaturedate,
      a.revfdmaturedate,
      a.exchangerate,
      @Semantics.amount.currencyCode : 'currency'
      a.amount,
      a.rateofinterest,
      a.revrateofinterest,
      a.renewal,
      a.currency,
      a.fdgl,
      a.profitcenter,
      a.transactionno,
      a.transactiondate,
      a.fdclosetrxnno,
      a.fdclosetrxndate,
      a.postclose,
      a.postfd,
      a.postfdint,
      a.tconfirm,
      a.remarkopen,
      a.remarkclose,
      a.interestcum,
      a.bg,
      a.closedocumentdate,
      a.closepostingdate,
      a.local_created_by,
      a.local_created_at,
      a.local_last_changed_by,
      a.local_last_changed_at,
      a.last_changed_at,

      _outgl,
      _incgl,
      _interest
}
