@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Header Level 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_PAYMENT_HEAD_L1
  as select distinct from ZV_PAYMENT_HEAD_L2        as a
    inner join            ZV_PAYMENT_HEAD_L3        as a1 on(
      a1.AccountingDocument = a.AccountingDocument
      and a1.FiscalYear     = a.FiscalYear
      and a1.CompanyCode    = a.CompanyCode
    )
    inner join            ztmg_appr_matrix          as b  on  b.companycode = a.CompanyCode
                                                          and b.userid      = $session.user
                                                          and b.apprlevel   = '1'
    left outer join       I_PaymentProposalPayment  as d  on  d.PaymentDocument      = a.AccountingDocument
                                                          and d.PayingCompanyCode    = a.CompanyCode
                                                          and d.FinancialAccountType = 'K'

  //    inner join ZI_PAYMENTRUNID                      as d1 on  d1.PaymentDocument  =  d.PaymentDocument
  //                                                          and d1.PayingCompanyCode = d.PayingCompanyCode
  //                                                          and d1.PAYMENTRUNDATE   = d.PaymentRunDate
    left outer join       zdt_payment_head          as c  on  c.accountingdoc = a.AccountingDocument
                                                          and c.fiscalyear    = a.FiscalYear
                                                          and c.companycode   = a.CompanyCode
    left outer join       I_HouseBankAccountLinkage as e  on(
       e.CompanyCode          = a.CompanyCode
       and e.HouseBank        = a.HouseBank
       and e.HouseBankAccount = a.HouseBankAccount
     )

{
  key a.AccountingDocument                                           as Accountingdoc,
  key a.FiscalYear                                                   as Fiscalyear,
  key a.CompanyCode                                                  as Companycode,
      d.PaymentRunID,
      a.DocumentDate,
      a.PostingDate,
      a.ValueDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( a.AmountInCompanyCodeCurrency )                           as AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      a1.Supplier,
      a.PaymentMethod,
      a.HouseBank,
      a.HouseBankAccount,
      e.BankAccountNumber,
      cast( c.apprlevel as abap.numc(1) )                            as apprlevel,
      c.appr1comment                                                 as Appr1comment,
      c.appr2comment                                                 as Appr2comment,
      c.status                                                       as Status,
      c.senton                                                       as Senton,
      c.sentat                                                       as Sentat,
      c.sentby                                                       as Sentby,
      c.utr                                                          as Utr,
      c.message                                                      as Message,
      c.messagecode                                                  as Messagecode,
      cast( c.approved as abap.char(1) )                             as Approved,
      cast( c.rejected as abap.char(1) )                             as Rejected,
      cast( c.inprocess as abap.char(1) )                            as Inprocess,
      c.appr1                                                        as Appr1,
      c.senthsbc                                                     as Senthsbc,

      c.appr2                                                        as Appr2,
      c.appr3                                                        as Appr3,
      c.reject1                                                      as Reject1,
      c.reject2                                                      as Reject2,
      c.reject3                                                      as Reject3,
      c.filename                                                     as Filename,
      c.counter                                                      as Counter,
      case when c.accountingdoc is not initial then 'X' else 'Y' end as accdoc,
      d.PayeeBankAccount,
      d.PayeeBankKey,
      max(d.PaymentRunDate)                                          as rundate
}

group by
  a.AccountingDocument,
  a.FiscalYear,
  a.CompanyCode,
  d.PaymentRunID,
  a.DocumentDate,
  a.PostingDate,
  a.ValueDate,
  a.CompanyCodeCurrency,
  a1.Supplier,
  a.PaymentMethod,
  a.HouseBank,
  a.HouseBankAccount,
  e.BankAccountNumber,
  c.apprlevel,
  c.appr1comment,
  c.appr2comment,
  c.status,
  c.senton,
  c.sentat,
  c.sentby,
  c.utr,
  c.message,
  c.messagecode,
  c.approved,
  c.rejected,
  c.inprocess,
  c.appr1,
  c.senthsbc,
  c.appr2,
  c.appr3,
  c.reject1,
  c.reject2,
  c.reject3,
  c.accountingdoc,
  d.PayeeBankAccount,
  d.PayeeBankKey,
  c.filename,
  c.counter,
  d.PaymentRunDate
