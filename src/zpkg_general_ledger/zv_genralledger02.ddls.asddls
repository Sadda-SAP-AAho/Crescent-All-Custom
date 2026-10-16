@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'General Ledger'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_GENRALLEDGER02

  with parameters
    p_endda : datum

  as select from    I_GLAccount        as b

    inner join      I_GLAccountText    as c on  c.Language  = $session.system_language
                                            and c.GLAccount = b.GLAccount

    left outer join I_JournalEntryItem as a on  b.GLAccount            = a.GLAccount
                                            and a.FinancialAccountType = 'S'
                                            and a.Ledger               = '0L'
                                            and a.SourceLedger         = '0L'
                                            and a.PostingDate          <= $parameters.p_endda

{
  key     $parameters.p_endda                as postingdate,
  key     b.GLAccount,
  key     a.CompanyCode,
          c.GLAccountName,
          a.CompanyCodeCurrency,
          concat( b.GLAccount, 'C' )         as SortCode,
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          sum(a.AmountInCompanyCodeCurrency) as AmountInCompanyCodeCurrency,
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          sum(a.DebitAmountInCoCodeCrcy)     as DebitAmountInCoCodeCrcy,
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
          sum(a.CreditAmountInCoCodeCrcy)    as CreditAmountInCoCodeCrcy
}

group by
  a.CompanyCodeCurrency,
  b.GLAccount,
  a.CompanyCode,
  c.GLAccountName
