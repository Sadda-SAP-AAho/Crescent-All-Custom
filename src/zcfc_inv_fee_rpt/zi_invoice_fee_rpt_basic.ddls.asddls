@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice wise Forex Exchanges Report-Basic'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_INVOICE_FEE_RPT_BASIC
  as select distinct from ZI_INVOICE_FEE_RPT_1

{
  key CompCode,
  key FY,
  key JENo,
      JEDate,
      MonthYear,
      CompanyCodeCurrency,
      
      GLCode1,
      GLName1,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmtInr1,
      
      GLCode2,
      GLName2,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmtInr2,
      
      GLCode3,
      GLName3,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmtInr3,
      
      GLCode4,
      GLName4,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmtInr4,
      
      TotalAmtInr,
      
      DebtJENo,
      ARNo,
      InvDate,
      TotalNetAmount,
      TransactionCurrency,
      cast( AccountingExchangeRate as abap.dec(13,2) ) as AccountingExchangeRate,
      InvValINR,
      Customer,
      CustName,
      AccountingDocumentType,
      DocumentReferenceID,
      cast( AbsoluteExchangeRate as abap.dec(13,2) )   as AbsoluteExchangeRate,
      Supplier,
      SupplierName,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      BankGLAmt,
      PCFCLoanNo,
      PCFCJENo,
      cast( LoanExRate as abap.dec(13,2) )             as LoanExRate,
      LoanDrawDate,
      Bankname,
      FXContrNo,
      cast( FXRate as abap.dec(13,2) )                 as FXRate,
      FXBookDate

}

union all

select distinct from ZI_INVOICE_FEE_RPT_2

{
  key CompCode,
  key FY,
  key JENo,
      JEDate,
      MonthYear,
      CompanyCodeCurrency,
      
      GLCode1,
      GLName1,
      AmtInr1,
      
      GLCode2,
      GLName2,
      AmtInr2,
      
      GLCode3,
      GLName3,
      AmtInr3,
      
      GLCode4,
      GLName4,
      AmtInr4,
      
      TotalAmtInr,
      
      DebtJENo,
      ARNo,
      InvDate,
      TotalNetAmount,
      TransactionCurrency,
      cast( AccountingExchangeRate as abap.dec(13,2) ) as AccountingExchangeRate,
      InvValINR,
      Customer,
      CustName,
      AccountingDocumentType,
      DocumentReferenceID,
      cast( AbsoluteExchangeRate as abap.dec(13,2) )   as AbsoluteExchangeRate,
      Supplier,
      SupplierName,

      BankGLAmt,
      PCFCLoanNo,
      PCFCJENo,
      cast( LoanExRate as abap.dec(13,2) )             as LoanExRate,
      LoanDrawDate,
      Bankname,
      FXContrNo,
      cast( FXRate as abap.dec(13,2) )                 as FXRate,
      FXBookDate

}

union all

select distinct from ZI_INVOICE_FEE_RPT_3

{
  key CompCode,
  key FY,
  key JENo,
      JEDate,
      MonthYear,
      CompanyCodeCurrency,
      
      GLCode1,
      GLName1,
      AmtInr1,
      
      GLCode2,
      GLName2,
      AmtInr2,
      
      GLCode3,
      GLName3,
      AmtInr3,
      
      GLCode4,
      GLName4,
      AmtInr4,
      
      TotalAmtInr,
      
      DebtJENo,
      ARNo,
      InvDate,

      TotalNetAmount,
      TransactionCurrency,
      cast( AccountingExchangeRate as abap.dec(13,2) ) as AccountingExchangeRate,
      InvValINR,
      Customer,
      CustName,
      AccountingDocumentType,
      DocumentReferenceID,
      cast( AbsoluteExchangeRate as abap.dec(13,2) )   as AbsoluteExchangeRate,
      Supplier,
      SupplierName,

      BankGLAmt,
      PCFCLoanNo,
      PCFCJENo,
      cast( LoanExRate as abap.dec(13,2) )             as LoanExRate,
      LoanDrawDate,
      Bankname,
      FXContrNo,
      cast( FXRate as abap.dec(13,2) )                 as FXRate,
      FXBookDate

}
