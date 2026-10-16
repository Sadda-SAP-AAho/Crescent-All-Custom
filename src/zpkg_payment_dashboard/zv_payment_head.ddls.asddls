@AbapCatalog.sqlViewName: 'ZVPAYMENTHEAD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Header'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_PAYMENT_HEAD
  as select from    ZV_PAYMENT_HEAD_L1 as a
    left outer join ZV_VEND_BANK       as b on b.BusinessPartner = a.Supplier

{
  key a.Accountingdoc,
  key a.Fiscalyear   as Fiscalyear,
  key a.Companycode  as Companycode,
      a.PaymentRunID,
      a.DocumentDate,
      a.PostingDate,
      a.ValueDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      a.Supplier,
      a.PaymentMethod,
      a.HouseBank,
      a.HouseBankAccount,
      a.BankAccountNumber,
      case when a.PayeeBankAccount is null then b.BankAccount
           else  a.PayeeBankAccount
           end       as PayeeBankAccount,
      case when a.PayeeBankKey is null then b.BankNumber
           else  a.PayeeBankKey
           end       as PayeeBankKey,
      ////      a.PayeeBankKey,
      a.apprlevel,
      a.Appr1comment as Appr1comment,
      a.Appr2comment as Appr2comment,
      a.Status       as Status,
      a.Senton       as Senton,
      a.Sentat       as Sentat,
      a.Sentby       as Sentby,
      a.Utr          as Utr,
      a.Message      as Message,
      a.Messagecode  as Messagecode,
      a.Approved     as Approved,
      a.Rejected     as Rejected,
      a.Inprocess    as Inprocess,
      a.Appr1        as Appr1,
      a.Senthsbc     as Senthsbc,
      a.Appr2        as Appr2,
      a.Appr3        as Appr3,
      a.Reject1      as Reject1,
      a.Reject2      as Reject2,
      a.Reject3      as Reject3,
      a.Filename     as Filename,
      a.Counter      as Counter

}
where
  (
    a.accdoc = 'Y'
  )

union all

select distinct from I_OperationalAcctgDocItem as a
  inner join         ztmg_appr_matrix          as b on  a.CompanyCode = b.companycode
                                                    and b.userid      = $session.user
                                                    and b.apprlevel   = '2'
  left outer join    I_PaymentProposalPayment  as d on  d.PaymentDocument      = a.AccountingDocument
                                                    and d.PayingCompanyCode    = a.CompanyCode
                                                    and d.FinancialAccountType = 'K'
  left outer join    zdt_payment_head          as c on  c.accountingdoc = a.AccountingDocument
                                                    and c.fiscalyear    = a.FiscalYear
                                                    and c.companycode   = a.CompanyCode
  left outer join    I_HouseBankAccountLinkage as e on(
    e.CompanyCode          = a.CompanyCode
    and e.HouseBank        = a.HouseBank
    and e.HouseBankAccount = a.HouseBankAccount
  )

{
  key a.AccountingDocument as Accountingdoc,
  key a.FiscalYear         as Fiscalyear,
  key a.CompanyCode        as Companycode,

      d.PaymentRunID,
      a.DocumentDate,
      a.PostingDate,
      a.ValueDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      a.Supplier,
      a.PaymentMethod,
      a.HouseBank,
      a.HouseBankAccount,
      e.BankAccountNumber,
      d.PayeeBankAccount,
      d.PayeeBankKey,
      c.apprlevel,
      c.appr1comment       as Appr1comment,
      c.appr2comment       as Appr2comment,
      c.status             as Status,
      c.senton             as Senton,
      c.sentat             as Sentat,
      c.sentby             as Sentby,
      c.utr                as Utr,
      c.message            as Message,
      c.messagecode        as Messagecode,
      c.approved           as Approved,
      c.rejected           as Rejected,
      c.inprocess          as Inprocess,
      c.appr1              as Appr1,
      c.senthsbc           as Senthsbc,
      c.appr2              as Appr2,
      c.appr3              as Appr3,
      c.reject1            as Reject1,
      c.reject2            as Reject2,
      c.reject3            as Reject3,
      c.filename           as Filename,
      c.counter            as Counter
}
where
          c.appr1                  is not initial
  and     c.appr2                  is initial
  and(
          a.AccountingDocumentType =  'ZP'
    and   a.Supplier               is not initial
    and   c.inprocess              =  'X'
    and(
          c.rejected               <> 'X'
      and c.approved               <> 'X'
    )
  )

union all

select distinct from I_OperationalAcctgDocItem as a
  inner join         ztmg_appr_matrix          as b on  a.CompanyCode = b.companycode
                                                    and b.userid      = $session.user
                                                    and b.apprlevel   = '3'
  left outer join    I_PaymentProposalPayment  as d on  d.PaymentDocument      = a.AccountingDocument
                                                    and d.PayingCompanyCode    = a.CompanyCode
                                                    and d.FinancialAccountType = 'K'
  left outer join    zdt_payment_head          as c on  c.accountingdoc = a.AccountingDocument
                                                    and c.fiscalyear    = a.FiscalYear
                                                    and c.companycode   = a.CompanyCode
  left outer join    I_HouseBankAccountLinkage as e on(
    e.CompanyCode          = a.CompanyCode
    and e.HouseBank        = a.HouseBank
    and e.HouseBankAccount = a.HouseBankAccount
  )

{
  key a.AccountingDocument as Accountingdoc,
  key a.FiscalYear         as Fiscalyear,
  key a.CompanyCode        as Companycode,

      d.PaymentRunID,
      a.DocumentDate,
      a.PostingDate,
      a.ValueDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency,
      a.CompanyCodeCurrency,
      a.Supplier,
      a.PaymentMethod,
      a.HouseBank,
      a.HouseBankAccount,
      e.BankAccountNumber,
      d.PayeeBankAccount,
      d.PayeeBankKey,
      c.apprlevel          as Apprlevel,
      c.appr1comment       as Appr1comment,
      c.appr2comment       as Appr2comment,
      c.status             as Status,
      c.senton             as Senton,
      c.sentat             as Sentat,
      c.sentby             as Sentby,
      c.utr                as Utr,
      c.message            as Message,
      c.messagecode        as Messagecode,
      c.approved           as Approved,
      c.rejected           as Rejected,
      c.inprocess          as Inprocess,
      c.appr1              as Appr1,
      c.senthsbc           as Senthsbc,
      c.appr2              as Appr2,
      c.appr3              as Appr3,
      c.reject1            as Reject1,
      c.reject2            as Reject2,
      c.reject3            as Reject3,
      c.filename           as Filename,
      c.counter            as Counter
}
where
          c.appr1                  is not initial
  and     c.appr2                  is not initial
  and     c.appr3                  is initial
  and(
          a.AccountingDocumentType =  'ZP'
    and   a.Supplier               is not initial
    and   c.inprocess              =  'X'
    and(
          c.rejected               <> 'X'
      and c.approved               <> 'X'
    )
  )
