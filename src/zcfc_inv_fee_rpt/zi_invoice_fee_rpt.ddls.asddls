@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice wise Foreign Exchange Earnings Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_INVOICE_FEE_RPT
  as select distinct from ZI_INVOICE_FEE_RPT_BASIC as a

    left outer join       ZI_BOOK_EX_RATE          as b on  a.CompCode            = b.compcode
                                                        and a.FY                  = b.fy
                                                        and a.JENo                = b.jeno
                                                        and a.TransactionCurrency = b.SourceCurrency
                                                        and a.CompanyCodeCurrency = b.TargetCurrency

    left outer join       ZI_BOOK_EX_RATE          as c on  a.CompCode            = c.compcode
                                                        and a.FY                  = c.fy
                                                        and a.JENo                = c.jeno
                                                        and a.CompanyCodeCurrency = c.SourceCurrency

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
      a.PCFCLoanNo,
      a.PCFCJENo,
      a.LoanExRate,
      a.LoanDrawDate,
      a.Bankname,
      a.FXContrNo,
      a.FXRate,
      a.FXBookDate,
      ( case when ( a.Supplier is not null or a.Supplier <> '' )
             then ( cast ( c.ExchangeRate as abap.dec(12,3) ) * 100 )
             else cast( b.ExchangeRate as abap.dec(13,2) ) end ) as ExchangeRate,

      ( case when cast( b.ExchangeRate as abap.dec(13,2) ) <> cast( 0 as abap.dec(13,2) )
             then
             cast ( ( b.ExchangeRate * a.TotalNetAmount ) as abap.dec(12,3) ) -
             cast ( ( a.AbsoluteExchangeRate * a.TotalNetAmount ) as abap.dec(12,3) )

             else cast( 0 as abap.dec(13,2) ) end )              as FinalLossGain1,

      ( case when ( a.Supplier is not null or a.Supplier <> '' )
             then cast (
                         (
                           (
                             ( case when cast( a.AbsoluteExchangeRate as abap.dec(12,3) ) <> cast ( 0 as abap.dec(12,3) )
                                    then division( cast( abs( a.TotalAmtInr ) as abap.dec(12,3) ) , cast( a.AbsoluteExchangeRate as abap.dec(12,3) ) , 3 )
                                    else cast( abs( a.TotalAmtInr ) as abap.dec(12,3) ) end )
                           * ( case when ( a.Supplier is not null or a.Supplier <> '' )
                                    then ( cast ( c.ExchangeRate as abap.dec(12,3) ) * 100 )
                               else cast( b.ExchangeRate as abap.dec(13,2) ) end )
                           )
                          - cast( abs( a.TotalAmtInr ) as abap.dec(12,3) )
                         )
                        as abap.dec(12,3) )
             else cast ( 0 as abap.dec(12,3) )
         end )                                                   as FinalLossGain2
}
