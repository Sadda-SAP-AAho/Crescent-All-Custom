@AbapCatalog.sqlViewName: 'ZZMODELACT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hard Coke Standard'
@Metadata.ignorePropagatedAnnotations: true
define view ZVMODELACT
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
       GLAccount = '0047600190'
    or GLAccount = '0047600200'
    or GLAccount = '0047600210'
    or GLAccount = '0047600220'
  )
