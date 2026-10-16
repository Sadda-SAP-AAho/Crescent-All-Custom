@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bank Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_BANK_DETAILS
  as select distinct from I_JournalEntryItem as a
    left outer join       I_GLAccountText    as b on  a.GLAccount = b.GLAccount
                                                  and b.Language  = 'E'
{
  key a.CompanyCode                        as CompCode,
  key a.FiscalYear                         as FY,
  key a.AccountingDocument                 as JENo,
      a.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum( a.AmountInCompanyCodeCurrency ) as AmtInr

}

where
      a.SourceLedger =    '0L'
  and a.Ledger       =    '0L'
  and a.GLAccount    like '0012500%'

group by
  a.CompanyCode,
  a.FiscalYear,
  a.AccountingDocument,
  a.CompanyCodeCurrency
