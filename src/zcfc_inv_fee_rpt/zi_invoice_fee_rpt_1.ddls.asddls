@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice wise Forex Exchanges Report-1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_INVOICE_FEE_RPT_1
  as select distinct from ZI_JE_DETAILS        as a
    left outer join       ZI_AR_DETAILS        as b on a.JENo = b.JENo
    left outer join       ZI_BANK_DETAILS      as c on  a.CompCode = c.CompCode
                                                    and a.FY       = c.FY
                                                    and a.JENo     = c.JENo
    left outer join       ZI_PCFC_DETAILS      as d on  d.ARNo                = b.BillingDocument
                                                    and a.DocumentReferenceID = d.PCFCLoanNo
    left outer join       ZTBL_FCTN_FX_DATA    as e on  d.Bankname     = e.bankname
                                                    and d.LoanDrawDate = e.instructdate
    left outer join       ZTBL_FCTN_FX_DATE    as f on  d.Bankname     = f.bankname
                                                    and d.LoanDrawDate = f.instructdate
    left outer join       ZI_FX_EX_RATE        as g on  d.Bankname     = g.Bankname
                                                    and d.LoanDrawDate = g.Instructdate
    left outer join       ZTBL_FCTN_DEBT_JE_NO as h on a.JENo = h.jeno

{
  key a.CompCode,
  key a.FY,
  key a.JENo,
      a.JEDate,
      a.MonthYear,
      a.CompanyCodeCurrency,

      a.GLCode1,
      a.GLName1,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmtInr1,

      a.GLCode2,
      a.GLName2,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmtInr2,

      a.GLCode3,
      a.GLName3,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmtInr3,

      a.GLCode4,
      a.GLName4,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmtInr4,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.TotalAmtInr,

      h.debtjeno                                  as DebtJENo,
      b.BillingDocument                           as ARNo,
      b.BillingDocumentDate                       as InvDate,

      cast ( b.TotalNetAmount as abap.dec(15,2) ) as TotalNetAmount,
      b.TransactionCurrency,

      b.AccountingExchangeRate,
      b.InvValINR,
      b.Customer,
      b.CustName,
      a.AccountingDocumentType,
      a.DocumentReferenceID,
      a.AbsoluteExchangeRate,
      a.Supplier,
      a.SupplierName,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      c.AmtInr                                    as BankGLAmt,
      d.PCFCLoanNo,
      d.PCFCJENo,
      d.ExchangeRate                              as LoanExRate,
      d.LoanDrawDate,
      d.Bankname,
      e.contnoext                                 as FXContrNo,
      g.FXRate,
      f.Bookdate                                  as FXBookDate

}

where

  (
        b.BillingDocument <> ''
    and b.BillingDocument is not null
  )
  and(
        d.PCFCLoanNo      <> ''
    or  d.PCFCLoanNo      is not null
  )
//      a.AccountingDocumentHeaderText is not initial
//  and d.PCFCLoanNo                   is not initial
