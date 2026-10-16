@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PCFC Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_PCFC_DETAILS
  as select distinct from I_JournalEntry     as a
    inner join            I_JournalEntryItem as b on  a.CompanyCode        = b.CompanyCode
                                                  and a.FiscalYear         = b.FiscalYear
                                                  and a.AccountingDocument = b.AccountingDocument
    left outer join       ZI_PCRHDR          as c on  a.DocumentReferenceID = c.Loanacno
                                                  and a.AccountingDocument  = c.Accountdocno
    left outer join       ZI_PCRITM          as d on c.Id = d.Id

{
  key a.CompanyCode          as CompCode,
  key a.FiscalYear           as FY,
  key a.AccountingDocument   as PCFCJENo,
  key d.Invno                as ARNo,
      a.DocumentReferenceID  as PCFCLoanNo,
      a.AbsoluteExchangeRate as ExchangeRate,
      a.DocumentDate         as LoanDrawDate,
      c.Bankname

}

where
       b.SourceLedger = '0L'
  and  b.Ledger       = '0L'
  and(
       b.GLAccount    = '0024200010'
    or b.GLAccount    = '0024200020'
    or b.GLAccount    = '0024200030'
    or b.GLAccount    = '0024200050'
    or b.GLAccount    = '0024200100'
  )
