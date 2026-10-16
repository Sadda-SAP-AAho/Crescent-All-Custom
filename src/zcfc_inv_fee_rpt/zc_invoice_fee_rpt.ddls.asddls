@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Invoice wise Foreign Exchange'
@Metadata.allowExtensions: true
@Analytics.dataCategory: #CUBE
define root view entity ZC_INVOICE_FEE_RPT
  provider contract transactional_query
  as projection on ZI_INVOICE_FEE_RPT
{
      @EndUserText.label: 'Company Code'
  key CompCode,
      @EndUserText.label: 'FY'
  key FY,
      @EndUserText.label: 'Journal Entry No'
  key JENo,
      @EndUserText.label: 'Journal Entry Date'
      JEDate,
      @EndUserText.label: 'Month Year'
      MonthYear,
      @UI.hidden: true
      CompanyCodeCurrency,
      @EndUserText.label: 'GL Code-1'
      GLCode1,
      @EndUserText.label: 'GL Name-1'
      GLName1,
      @EndUserText.label: 'Amount in INR-1'
      AmtInr1,
      @EndUserText.label: 'GL Code-2'
      GLCode2,
      @EndUserText.label: 'GL Name-2'
      GLName2,
      @EndUserText.label: 'Amount in INR-2'
      AmtInr2,
      @EndUserText.label: 'GL Code-3'
      GLCode3,
      @EndUserText.label: 'GL Name-3'
      GLName3,
      @EndUserText.label: 'Amount in INR-3'
      AmtInr3,
      @EndUserText.label: 'GL Code-4'
      GLCode4,
      @EndUserText.label: 'GL Name-4'
      GLName4,
      @EndUserText.label: 'Amount in INR-4'
      AmtInr4,
      @EndUserText.label: 'Total Amount in INR'
      TotalAmtInr,
      @EndUserText.label: 'Debtors Journal Entry'
      DebtJENo,
      @EndUserText.label: 'A/R Invoice No'
      ARNo,
      @EndUserText.label: 'A/R Invoice Date'
      InvDate,
      @EndUserText.label: 'Invoice Value'
      TotalNetAmount,
      @EndUserText.label: 'Invoice Currency'
      TransactionCurrency,
      @EndUserText.label: 'Invoice Ex. Rate'
      AccountingExchangeRate,
      @EndUserText.label: 'Invoice Value(INR)'
      InvValINR,
      @EndUserText.label: 'Customer'
      Customer,
      @EndUserText.label: 'Customer Name'
      CustName,
      @EndUserText.label: 'Entry Type'
      AccountingDocumentType,
      @EndUserText.label: 'Document Ref. Id'
      DocumentReferenceID,
      @EndUserText.label: 'Absolute Exchange Rate'
      AbsoluteExchangeRate,
      @EndUserText.label: 'Supplier'
      Supplier,
      @EndUserText.label: 'Supplier Name'
      SupplierName,
      @EndUserText.label: 'Bank G/L Amt'
      BankGLAmt,
      @EndUserText.label: 'PCFC Loan No'
      PCFCLoanNo,
      @EndUserText.label: 'PCFC JE No.'
      PCFCJENo,
      @EndUserText.label: 'Loan Ex. Rate'
      LoanExRate,
      @EndUserText.label: 'Loan Drawing Date'
      LoanDrawDate,
      @EndUserText.label: 'Bank Name'
      Bankname,
      @EndUserText.label: 'FX Contract No.'
      FXContrNo,
      @EndUserText.label: 'Rate of FX'
      FXRate,
      @EndUserText.label: 'FX Contract Booking Date'
      FXBookDate,
      @EndUserText.label: 'Rate on the Booking Date'
      ExchangeRate,
      @EndUserText.label: 'Final Loss or Gain 1'
      FinalLossGain1,
      @EndUserText.label: 'Final Loss or Gain 2'
      FinalLossGain2
}
