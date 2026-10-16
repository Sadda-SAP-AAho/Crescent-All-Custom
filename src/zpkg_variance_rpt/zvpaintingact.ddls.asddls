@AbapCatalog.sqlViewName: 'ZZPAINTINGACT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hard Coke Standard'
@Metadata.ignorePropagatedAnnotations: true
define view ZVPAINTINGACT
  as select distinct from I_OperationalAcctgDocItem as a
    inner join            zdt_costingpl_pc          as b on a.ProfitCenter = b.prctr
{
  key  AccountingDocument,
  key  CompanyCode,
  key  FiscalYear,
  key  AccountingDocumentItem,
  key  concat( substring(PostingDate, 5, 2) , substring(PostingDate, 1, 4) ) as mmyyyy,
  key  prctrclub,
       CompanyCodeCurrency,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       AmountInCompanyCodeCurrency
}
where
  (
       GLAccount = '0047600050'
    or GLAccount = '0047600080'
    or GLAccount = '0047600090'
    or GLAccount = '0047600100'
  )
