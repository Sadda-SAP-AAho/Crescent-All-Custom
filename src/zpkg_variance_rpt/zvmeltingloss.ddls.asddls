@AbapCatalog.sqlViewName: 'ZZVMELT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Melting Loss Actual'
@Metadata.ignorePropagatedAnnotations: true
define view ZVMELTINGLOSS
  as select from I_JournalEntryItem as a
    inner join   zdt_costingpl_pc   as b on a.ProfitCenter = b.prctr
{
  key  a.AccountingDocument,
  key  a.CompanyCode,
  key  a.FiscalYear,
  key  a.AccountingDocumentItem,
  key  concat( substring(a.PostingDate, 5, 2) , substring(a.PostingDate, 1, 4) ) as mmyyyy,
  key  b.prctrclub,
       a.CompanyCodeCurrency,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       a.AmountInCompanyCodeCurrency
}
where
      GLAccount    = '0047600250'
  and Ledger       = '0L'
  and SourceLedger = '0L'
