@AbapCatalog.sqlViewName: 'ZZMACHINESTD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hard Coke Standard'
@Metadata.ignorePropagatedAnnotations: true
define view ZVMACHINESTD
  as select distinct from I_JournalEntryItem as a
    inner join            zdt_costingpl_pc   as b on a.ProfitCenter = b.prctr
//    left outer join ZR_REJECTED_QTY as c on a.OrderID = c.OrderID

    
{
  key  AccountingDocument,
  key  CompanyCode,
  key  FiscalYear,
  key  AccountingDocumentItem,
  key  concat( substring(PostingDate, 5, 2) , substring(PostingDate, 1, 4) ) as mmyyyy,
  key  b.prctrclub,
     key a.OrderID,
       CompanyCodeCurrency,
       cast(a.AmountInCompanyCodeCurrency as abap.dec( 15,2 ) ) as AmountInCompanyCodeCurrency,
       cast( a.Quantity as abap.dec( 21, 3 )) as quantity

}
where
  (
       GLAccount                = '0099900630'
    or GLAccount                = '0099900520'
  )
  and  a.OrderID                is not initial
  and  a.AccountingDocumentType = 'CO'
  and a.Ledger                 = '0L'
  and a.SourceLedger           = '0L'
