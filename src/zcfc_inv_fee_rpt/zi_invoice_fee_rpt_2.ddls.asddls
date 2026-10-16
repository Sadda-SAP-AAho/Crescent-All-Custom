@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice wise Forex Exchanges Report-2'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_INVOICE_FEE_RPT_2
  as select distinct from ZI_INVOICE_FEE_RPT_2_1 as a
    left outer join       ZTBL_FCTN_FX_DATA_2  as b on a.ARNo = b.remarks
    left outer join       ZI_FX_EX_RATE_2      as c on a.ARNo = c.Remarks
    left outer join       ZTBL_FCTN_FX_DATE_2  as d on a.ARNo = d.remarks
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

      a.DebtJENo,
      a.ARNo,
      a.InvDate,
      a.TotalNetAmount,
      a.TransactionCurrency,
      a.AccountingExchangeRate,
      a.InvValINR,
      a.Customer,
      a.CustName,
      a.AccountingDocumentType,
      a.DocumentReferenceID,
      a.AbsoluteExchangeRate,
      a.Supplier,
      a.SupplierName,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.BankGLAmt,
      ''                          as PCFCLoanNo,
      ''                          as PCFCJENo,
      cast( 0 as abap.dec(13,3) ) as LoanExRate,
      ''                          as LoanDrawDate,
      ''                          as Bankname,
      b.contnoext                 as FXContrNo,
      c.FXRate,
      d.Bookdate                  as FXBookDate
}
