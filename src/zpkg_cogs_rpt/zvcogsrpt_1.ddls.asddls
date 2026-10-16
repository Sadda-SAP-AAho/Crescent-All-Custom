@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'COGS Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVCOGSRPT_1

  as select from I_JournalEntryItem as a

    inner join   zdt_cost_glpl      as b on  b.gl     = a.GLAccount
                                         and b.gltype = 90

    inner join   I_GLAccountText    as c on  c.Language  = $session.system_language
                                         and c.GLAccount = a.GLAccount

    inner join   I_ProfitCenterText as d on  d.Language     = $session.system_language
                                         and d.ProfitCenter = a.ProfitCenter

{

  key a.AccountingDocument,
  key a.FiscalYear,
  key a.CompanyCode,
  key a.AccountingDocumentItem,
      concat( a.ReferenceDocument, a.ReferenceDocumentItem )          as OriginalReferenceDocument,
      a.ReferenceDocument                                             as MaterialDocument,
      cast( ltrim( a.ReferenceDocumentItem, '0' ) as abap.char( 6 ) ) as MaterialDocumentItem,
      a.PostingDate,
      a.GLAccount,
      c.GLAccountName,
      a.ProfitCenter,
      d.ProfitCenterName,
      a.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      a.AmountInCompanyCodeCurrency

}

where
      a.SourceLedger = '0L'
  and a.Ledger       = '0L'
