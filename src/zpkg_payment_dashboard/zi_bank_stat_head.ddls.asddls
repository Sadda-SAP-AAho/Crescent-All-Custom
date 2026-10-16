@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Status Head'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_bank_stat_head as select from zdt_payment_head
  composition [0..*] of ZI_bank_stat_item as _item
  composition [0..*] of ZI_bank_stat_log  as _item1
{
    key accountingdoc as Accountingdoc,
    key fiscalyear as Fiscalyear,
    key companycode as Companycode,
    paymentrunid as Paymentrunid,
    documentdate as Documentdate,
    postingdate as Postingdate,
    supplier as Supplier,
    suppliername as suppliername,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    amountincompanycodecurrency as Amountincompanycodecurrency,
    companycodecurrency as Companycodecurrency,
    paymentmethod as Paymentmethod,
    housebank as Housebank,
    housebankaccount as Housebankaccount,
    bankaccountnumber as Bankaccountnumber,
    payeebankaccount as Payeebankaccount,
    payeebankkey as Payeebankkey,
    apprlevel as Apprlevel,
    appr1comment as Appr1comment,
    appr2comment as Appr2comment,
    status as Status,
    criticality as Criticality,
    senton as Senton,
    sentat as Sentat,
    sentby as Sentby,
    utr as Utr,
    message as Message,
    messagecode as Messagecode,
    approved as Approved,
    rejected as Rejected,
    inprocess as Inprocess,
    appr1 as Appr1,
    appr2 as Appr2,
    appr3 as Appr3,
    reject1 as Reject1,
    reject2 as Reject2,
    reject3 as Reject3,
      _item,
      _item1
}
where status <> 'In Approval'
